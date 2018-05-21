cd ../templates

3dBrickStat -count -mask ModelROIs_May2016_wEllipseRule_1.5.nii -mrange 13 18 ModelROIs_May2016_wEllipseRule_1.5.nii > voxel_count_bilateral_hippocampus
3dBrickStat -count -mask ModelROIs_May2016_wEllipseRule_1.5.nii -mrange 7 8 ModelROIs_May2016_wEllipseRule_1.5.nii > voxel_count_bilateral_PRC
3dBrickStat -count -mask ModelROIs_May2016_wEllipseRule_1.5.nii -mrange 9 10 ModelROIs_May2016_wEllipseRule_1.5.nii > voxel_count_bilateral_ERC
3dBrickStat -count -mask ModelROIs_May2016_wEllipseRule_1.5.nii -mrange 11 12 ModelROIs_May2016_wEllipseRule_1.5.nii > voxel_count_bilateral_PHC

