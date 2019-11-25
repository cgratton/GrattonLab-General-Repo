function save_fig(h,fname)
%function save_fig(h,fname)
% wrapper for export_fig
%
% assumes plot is still up
% makes plot with a transparent background

% Might need to add the path?
% addpath();

set(h,'Color','w');
export_fig(h,fname)


end