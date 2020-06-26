#!/bin/csh
echo "\n START: CreateRibbon"

set CARET7DIR = /usr/local/workbench/bin_rh_linux64/
set subject = $1
set freedir = $2
set T1image = $3
set resolution = $4
set freelables = /home/data/scripts/Cifti_creation/FreeSurferAllLut.txt


set LeftGreyRibbonValue="3"
set LeftWhiteMaskValue="2"
set RightGreyRibbonValue="42"
set RightWhiteMaskValue="41"

	set T1filename = ${freedir}/$T1image
	set nativedir = ${freedir}/Native
	set outputdir = ${freedir}/Ribbon
  	echo "${outputdir}"
  	mkdir "${outputdir}"
	foreach hem ( L R )
  		if  ( $hem == "L" ) then
    			set GreyRibbonValue="$LeftGreyRibbonValue"
    			set WhiteMaskValue="$LeftWhiteMaskValue"
  		endif

  		if  ( $hem == "R" ) then
    			set GreyRibbonValue="$RightGreyRibbonValue"
    			set WhiteMaskValue="$RightWhiteMaskValue"
  		endif
   

 		${CARET7DIR}/wb_command -create-signed-distance-volume ${nativedir}/${subject}.${hem}.white.native.surf.gii ${T1filename} ${outputdir}/${subject}.${hem}.white.native.nii.gz 
  		${CARET7DIR}/wb_command -create-signed-distance-volume ${nativedir}/${subject}.${hem}.pial.native.surf.gii ${T1filename} ${outputdir}/${subject}.${hem}.pial.native.nii.gz 

  		fslmaths ${outputdir}/${subject}.${hem}.white.native.nii.gz -thr 0 -bin -mul 255 ${outputdir}/${subject}.${hem}.white_thr0.native.nii.gz
 		fslmaths ${outputdir}/${subject}.${hem}.white_thr0.native.nii.gz -bin ${outputdir}/${subject}.${hem}.white_thr0.native.nii.gz
 		fslmaths ${outputdir}/${subject}.${hem}.pial.native.nii.gz -uthr 0 -abs -bin -mul 255 ${outputdir}/${subject}.${hem}.pial_uthr0.native.nii.gz
  		fslmaths ${outputdir}/${subject}.${hem}.pial_uthr0.native.nii.gz -bin ${outputdir}/${subject}.${hem}.pial_uthr0.native.nii.gz
  		fslmaths ${outputdir}/${subject}.${hem}.pial_uthr0.native.nii.gz -mas ${outputdir}/${subject}.${hem}.white_thr0.native.nii.gz -mul 255 ${outputdir}/${subject}.${hem}.ribbon.nii.gz
  		fslmaths ${outputdir}/${subject}.${hem}.ribbon.nii.gz -bin -mul $GreyRibbonValue ${outputdir}/${subject}.${hem}.ribbon.nii.gz
  		#fslmaths ${outputdir}/${subject}.${hem}.white.native.nii.gz -uthr 0 -abs -bin -mul 255 ${outputdir}/${subject}.${hem}.white_uthr0.native.nii.gz
  		#fslmaths ${outputdir}/${subject}.${hem}.white_uthr0.native.nii.gz -bin ${outputdir}/${subject}.${hem}.white_uthr0.native.nii.gz
  		#fslmaths ${outputdir}/${subject}.${hem}.white_uthr0.native.nii.gz -mul $WhiteMaskValue ${outputdir}/${subject}.${hem}.white_mask.native.nii.gz
  		#fslmaths ${outputdir}/${subject}.${hem}.ribbon.nii.gz -add ${outputdir}/${subject}.${hem}.white_mask.native.nii.gz ${outputdir}/${subject}.${hem}.ribbon.nii.gz
  		rm ${outputdir}/${subject}.${hem}.white.native.nii.gz ${outputdir}/${subject}.${hem}.white_thr0.native.nii.gz ${outputdir}/${subject}.${hem}.pial.native.nii.gz ${outputdir}/${subject}.${hem}.pial_uthr0.native.nii.gz ${outputdir}/${subject}.${hem}.white_uthr0.native.nii.gz ${outputdir}/${subject}.${hem}.white_mask.native.nii.gz
	end

	fslmaths ${outputdir}/${subject}.L.ribbon.nii.gz -add ${outputdir}/${subject}.R.ribbon.nii.gz ${outputdir}/ribbon.nii.gz
	rm ${outputdir}/${subject}.L.ribbon.nii.gz ${outputdir}/${subject}.R.ribbon.nii.gz
	${CARET7DIR}/wb_command -volume-label-import ${outputdir}/ribbon.nii.gz ${freelables} ${outputdir}/ribbon.nii.gz -discard-others -unlabeled-value 0
	
	#Downsample to BOLD dimensions
    flirt -in ${outputdir}/ribbon -ref ${outputdir}/ribbon -init $FSLDIR/etc/flirtsch/ident.mat -applyisoxfm $resolution -out ${outputdir}/ribbon_$resolution$resolution$resolution

	#gunzip ${outputdir}/ribbon.nii.gz
	#nifti_4dfp -4 ${outputdir}/ribbon ${outputdir}/ribbon
	#t4img_4dfp none ${outputdir}/ribbon ${outputdir}/ribbon_333 -O333 
	#niftigz_4dfp -n ${outputdir}/ribbon_333 ${outputdir}/ribbon_333
	
echo -e "\n END: CreateRibbon"

