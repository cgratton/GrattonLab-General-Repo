function ROIbased_Infomap_GrattonLab(corrmat,atlas,outDir,outname)
% ROIbased_Infomap_GrattonLab(corrmat,atlas,outDir,outname)
% Wrapper for running infomap commands on a (smallish) correlation matrix
% (e.g., 300 x 300)
%
% EXAMPLE:
% ROIbased_infomap(sub_corrmat,'Seitzman300','/projects/b1081/iNetworks/Nifti/derivatives/preproc_FCProc/corrmats_Seitzman300/infomaps/','sub-INET003_allses_test')
%
% sub_corrmat: a roi X roi correlation matrix - you can avg as you will
%   note: this can be fisher transformed or not, as % edges rather than
%   hard threshold used
% atlas: rois used
% outDir: where to save output
% outname: used to create a new subfolder with relevant output
%
% THIS SHOULD BE FAST. If it is not, probably something is wrong. There is
% a wait command in Run_Infomap that can make things hang.
%
% CG - 7/2020
% Based on versions run at WashU

addpath('/projects/b1081/Scripts/CIFTI_RELATED/Infomap/');
atlas_dir = '/projects/b1081/Atlases/';


%% ROI info
atlas_params = atlas_parameters_GrattonLab(atlas,atlas_dir);
distmat = calc_distances(atlas_params);
%group_parcel_communities = '/data/cn4/laumannt/Parcellation/Parcels_LR.dtseries.nii';
if ~exist(outDir)
    mkdir(outDir);
end
outDir_spec = [outDir outname '/']; %where to store infomap specific output files
mkdir(outDir_spec);
currDir = pwd;

% set some constants - Infomap
threshstep = .01; %or .0025
startthresh = .01;
endthresh = .1;
thresholdarray = [startthresh: threshstep: endthresh];
xdistance = 20;
numiter = 100;

% post-proc constants
minsize = 5; %min # of nodes to consider something a real network

%make string version of nums without the dots - this is important!
threshstepstr = num2str(threshstep);
threshstepstr(threshstepstr=='.') = [];
startthreshstr = num2str(startthresh);
startthreshstr(startthreshstr=='.') = [];
endthreshstr = num2str(endthresh);
endthreshstr(endthreshstr=='.') = [];

    
% Run infomap
cd(outDir)
Run_Infomap(corrmat,distmat,xdistance,thresholdarray,0,outDir_spec,1);

% do post-processing on infomap
cd(outDir_spec);
ngt.modify_clrfile('simplify','rawassn.txt',minsize);
ngt.rawoutput2clr(['rawassn_minsize' num2str(minsize) '.txt'],'outfile.txt');
load outfile.mat

% make a quick figure of the results
colors = distinguishable_colors(max(unique(clrs)));
colors(1,:) = [1 1 1];

figure('Position',[1 1 800 1200]);
imagesc(clrs(atlas_params.sorti,:),[1 max(unique(clrs))]);

set(gca,'box','off');
hline_new(atlas_params.transitions,'k:',3);
set(gca,'YTick',atlas_params.centers,'TickDir','out');
set(gca,'YTicklabel','');
ty= text(-1*ones(1,length(atlas_params.centers)),atlas_params.centers,atlas_params.networks);

xlabel('thresholds');
ylabel('rois');
title('Assignments across thresholds');
colormap(colors);

saveas(gcf,[outname '_AssignmentsAcrossThresholds.tiff'],'tiff');

% consensusizing
%     consensusVote_weightsBeta(clrs,[subject],[],1:1:10,'parcel');
%     clear clrs;
%     load([subject '_conBensus_weighted_minsize' num2str(minsize) '.mat']);
%
% recoloring - v1: match to group parcels
%     [recolor_consen color_list] = recolor_consensus_indparcels(consen,parcel_cifti_file,group_parcel_communities,atlas_params);
%     fout = [outdir subject '_parcel_communities_colors'];
%     save(fout,'recolor_consen','color_list'); % save out info about assignments
%     indparcel_correlmat_figmaker_cg(avg_corrmat,recolor_consen,color_list,atlas_params.networks,[-0.4 1])
%     save_fig(gcf,[outdir subject '_indparcel_corrmat.pdf']);
%     fout = [outdir subject '_parcel_communities'];% save output as a dlabel file
%     make_parcel_label_file(1:length(recolor_consen),recolor_consen,color_list,parcel_cifti_file,fout)
%
%     % clear things out
%     clear recolor_consen color_list avg_corrmat parcel_corrmat;
    

cd(currDir);

end

function consen_new = relabel_in_order(consen)

consen_new = zeros(size(consen));
nets = unique(consen);
for n = 1:length(nets)
    consen_new(consen == nets(n)) = n;
end
end

function distmat = calc_distances(atlas_params)

% first extract xyz coordinates for each region.
% Currently set up based on Seitzman300 atlas. May need to modify per atlas
switch atlas_params.atlas
    case 'Seitzman300'
        roi_info = readtable(atlas_params.roi_file);
        coord_table = [roi_info.x roi_info.y roi_info.z];
    otherwise
        error('not yet tested with other atlases; check ROI file set up');
end

distmat = squareform(pdist(coord_table,'euclidean'));

end
