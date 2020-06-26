function  goodvoxels_singlesub_GrattonLab(funcvol, surfdir, outfile,subject,sequence_name,T1name,force_ribbon)
% originally from EMN
% edited by CG to work at NU, 5/2020

neighsmooth = '5';
factor = .5;

ribbonname = [surfdir '/Ribbon/ribbon_222.nii.gz']; %changed from 333 to 222
if ~exist(ribbonname) || force_ribbon
    %system(['csh create_ribbon_singlesub_GrattonLab.csh ' subject ' ' surfdir ' ' T1name ' 2']); %changed 3 to 2 for resolution
    create_ribbon_singlesub_GrattonLab(subject,surfdir,T1name,'2',funcvol); 
else
    disp('>>> WARNING: making goodvoxels out of previously saved ribbon. If not desired, set to force');
end

meanname = [outfile sequence_name '_mean'];
stdname = [outfile sequence_name '_sd1'];

system(['module load fsl/5.0.8; fslmaths ' funcvol ' -Tmean ' meanname]);
system(['module load fsl/5.0.8; fslmaths ' funcvol ' -Tstd ' stdname]);

covname = [outfile sequence_name '_cov'];
system(['module load fsl/5.0.8; fslmaths ' stdname ' -div ' meanname ' ' covname]);

system(['module load fsl/5.0.8; fslmaths ' covname ' -mas ' ribbonname ' ' covname '_ribbon']);

Ribmean = num2str(str2num(evalc(['!module load fsl/5.0.8; fslstats ' covname '_ribbon -M'])));
system(['module load fsl/5.0.8; fslmaths ' covname '_ribbon -div ' Ribmean ' ' covname '_ribbon_norm']);
system(['module load fsl/5.0.8; fslmaths ' covname '_ribbon_norm -bin -s ' neighsmooth ' ' outfile sequence_name '_SmoothNorm']);
system(['module load fsl/5.0.8; fslmaths ' covname '_ribbon_norm -s ' neighsmooth ' -div ' outfile sequence_name '_SmoothNorm -dilD ' covname '_ribbon_norm_s' neighsmooth]);
system(['module load fsl/5.0.8; fslmaths ' covname ' -div ' Ribmean ' -div ' covname '_ribbon_norm_s' neighsmooth ' -uthr 1000 ' covname '_norm_modulate']);
system(['module load fsl/5.0.8; fslmaths ' covname '_norm_modulate -mas ' ribbonname ' ' covname '_norm_modulate_ribbon']);

Final_Ribstd = str2num(evalc(['!module load fsl/5.0.8; fslstats ' covname '_norm_modulate_ribbon -S']));
Final_Ribmean = str2num(evalc(['!module load fsl/5.0.8; fslstats ' covname '_norm_modulate_ribbon -M']));

%Lower = Final_Ribmean - (Final_Ribstd * factor);
Upper = Final_Ribmean + (Final_Ribstd * factor);

system(['module load fsl/5.0.8; fslmaths ' meanname ' -bin ' outfile sequence_name '_mask']);
system(['module load fsl/5.0.8; fslmaths ' covname '_norm_modulate -thr ' num2str(Upper) ' -bin -sub ' outfile sequence_name '_mask -mul -1 ' outfile sequence_name '_goodvoxels']);

warning off
delete([meanname '.nii.gz'])
delete([stdname '.nii.gz'])
delete([covname '.nii.gz'])
delete([covname '_ribbon.nii.gz'])
delete([covname '_ribbon_norm.nii.gz'])
delete([outfile sequence_name '_SmoothNorm.nii.gz'])
delete([covname '_ribbon_norm_s' neighsmooth '.nii.gz'])
delete([covname '_norm_modulate.nii.gz'])
delete([covname '_norm_modulate_ribbon.nii.gz'])
delete([outfile sequence_name '_mask.nii.gz']);




