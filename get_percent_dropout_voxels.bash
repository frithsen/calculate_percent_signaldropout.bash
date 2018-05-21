
cd ../20-39

for i in 12????; do

cd $i

if [ -e good_motion_sub_allruns ]; then

3dTstat -mean -prefix MEAN_allruns_modelspace scaled_allruns_AC_regression_modelspace.nii # first make a mean of your functional dataset (not a necessary step)

mkdir Percent_Zero
cd Percent_Zero

# -------------------- first figure out how many voxels are zero (signifying signal dropout) within each ROI -----------------------

function CalcZero {
    # Pass in ROInum, Dataset, OutputName
    3dBrickStat -count -zero -mask ../../../templates/ModelROIs_May2016_wEllipseRule_1.5.nii -mrange $1 $2 ../$3[0] > zero_voxels_$4

}


CalcZero 13 18 MEAN_allruns_modelspace+tlrc bilateral_Hippo
CalcZero 7 8 MEAN_allruns_modelspace+tlrc bilateral_PRC
CalcZero 9 10 MEAN_allruns_modelspace+tlrc bilateral_ERC
CalcZero 11 12 MEAN_allruns_modelspace+tlrc bilateral_PHC





# -------------------- then calcualte what percentage is zero within each ROI -----------------------
# for this step, you'll need to know how many voxels should be in each ROI, I've already done this using 3dBrickStat (like above) and created these 'voxel_count' files in a directory called 'template'
# for example, run something like this: 3dBrickStat -count -mask ModelROIs_May2016_wEllipseRule_1.5.nii -mrange 13 18 ModelROIs_May2016_wEllipseRule_1.5.nii > voxel_count_bilateral_hippocampus

function CalcPZero {
    # Pass in NumZerofile TotalVoxelFile OutputName
    a=`cat zero_voxels_$1`
    b=`cat ../../../$2`

    echo "scale=0; 100 * $a/$b" | bc -l > percent_zero_$1   # the 'scale = 0' bit tells it to not have any numbers after the decimal point (i.e., make it an integer)
}

CalcPZero bilateral_Hippo templates/voxel_count_bilateral_hippocampus
CalcPZero bilateral_PRC templates/voxel_count_bilateral_PRC
CalcPZero bilateral_ERC templates/voxel_count_bilateral_ERC
CalcPZero bilateral_PHC templates/voxel_count_bilateral_PHC






# -------------------- then mark whether each ROI is good (1) or bad (0) -----------------------

function CheckSigDropOut {
    #Pass in file to check, OutputName
    g=`cat percent_zero_$1`
    if [ "$g" -gt 40 ]; then   # here, I'm using 40% as my cutoff, so if the % zero value is more than 40 consider it a bad ROI
    echo bad_ROI
    echo "0" > $1.txt
    elif [ "$g" -le 40 ]; then
    echo good_ROI
    echo "1" > $1.txt
    else 
    echo "Do not know if good or bad"
    fi 

}

CheckSigDropOut bilateral_Hippo
CheckSigDropOut bilateral_PRC
CheckSigDropOut bilateral_ERC
CheckSigDropOut bilateral_PHC



cd ../


# -------------------- lastly, create a subject-specific mask -----------------------

3dcalc -a MEAN_allruns_modelspace+tlrc[0] -b ../../templates/ModelROIs_May2016_wEllipseRule_1.5.nii -expr 'b*notzero(a)*notzero(b)' -prefix sub_specific_ROI_mask  # note, I don't think the last notzero(b) part is necessary here, but this is what was posted on the AFNI board, so I left it as is (doesn't hurt)


cd ../


else

cd ../

fi

done