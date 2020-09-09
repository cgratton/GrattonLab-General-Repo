function [pwr_high, pwr_high_rel, pwr_high_rel_max, pd, pd_prop, pd_relative, freq] = mot_FFT(mot_data,TR,varargin)
% creates power spectra of motion parameters for analysis

if ~isempty(varargin)
    plot_results = varargin{1};
else
    plot_results = 0;
end

Fs = 1/TR; % Sampling frequency
L = size(mot_data,1); % Signal length
t = [0:L-1]*TR; % time vector
NFFT = L;% 2^nextpow2(L); % next power of 2 from length
%freq = Fs/2*linspace(0,1,NFFT/2+1)';
freq_in = 0:0.001:0.2;

% PMTM approach (as used in D. Fair paper)
for x = 1:6
    %pd(:,x) = pmtm(mot_data(:,x),[],NFFT,Fs);
    [pd(:,x) freq] = pmtm(mot_data(:,x),8,[],Fs);

    % store pd as just a percentage
    pd_prop(:,x) = pd(:,x)./sum(pd(:,x));
    
    pd_scaled(:,x) = 10.*log10(pd(:,x));
    pd_normal(:,x) = zscore(pd_scaled(:,x));

    %store this for scaling later - this was done in D. Fair paper for
    %comparison; dispensing of here for the moment.
    %Pcoeffs(:,x) = polyfit(pd_scaled(:,x),pd_normal(:,x),1);
    
    % convert to percentiles
    thisDir = pd_normal(:,x);
    pd_relative(:,x) = (thisDir - min(thisDir))./(max(thisDir) - min(thisDir))*100;
end


% Calculate HF motion
inds = freq > 0.1; % indices of freq > 0.1 Hz.
pwr_high = sum(pd(inds,:),1)./sum(pd,1); %as a proportion of total pwr
pwr_high_rel = sum(pd_relative(inds,:),1)./sum(pd_relative,1); %as a proportion of total pwr
pwr_high_rel_max = max(pd_relative(inds,:));

%plot_results = 1;

if plot_results
    % plot results
    figure('Position',[0 0 1000 800]);
    subplot(2,2,1:2)
    plot(mot_data);
    xlim([1,size(mot_data,1)]);
    xlabel('TR');
    ylabel('mm');
    title(['motion data']);
    
    % Frequency per motion parameter
    subplot(2,2,3)
    plot(freq,pd,'LineWidth',1.5);
    ylabel('Power');
    ylim([0,0.5]);
    %plot(freq,10*log10(pd),'LineWidth',1.5);
    %ylabel('Power/frequency (dB/Hz)');
    box off;
    xlabel('Freq (Hz)');
    title(sprintf('Power Spectrum, y HF: %.02f, Sum HF: %.02f',pwr_high(2),sum(pwr_high)));
    
    % Relative frequency
    subplot(2,2,4)
    plot(freq,pd_relative,'LineWidth',1.5); hold on;
    ylabel('Relative Power');
    ylim([0 100]);
    box off;
    xlabel('Freq (Hz)');
    title(sprintf('Relative Power, y HF: %.02f, All HF: %.02f, y HFmax: %.02f',pwr_high_rel(2),mean(pwr_high_rel),pwr_high_rel_max(2)));
end



end