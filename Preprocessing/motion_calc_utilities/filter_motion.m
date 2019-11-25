function mvm_filt = filter_motion(TR,mvm)


% do the filtering
[butta buttb]=butter(1,0.1/(0.5/TR),'low');
pad = 100;
d = size(mvm);
temp_mot = cat(1, zeros(pad, d(2)), mvm, zeros(pad, d(2)));
[temp_mot]=filtfilt(butta,buttb,double(temp_mot));
temp_mot = temp_mot(pad+1:end-pad, 1:d(2));
mvm_filt = temp_mot;

end
