function img = load_untouch_nii_wrapper(fname)
% quick function for loading linearized version of nii
% note: this assumes dimensions always loaded in same order. Check for
% this?

tmp = load_untouch_nii(fname);
img = tmp.img;
img = img(:);



end