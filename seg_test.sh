#!/bin/bash

conda activate fast
####关键命令
export FASTSURFER_HOME=${PWD}
weights_sag="$FASTSURFER_HOME/checkpoints/Sagittal_Weights_FastSurferCNN/ckpts/Epoch_30_training_state.pkl"
weights_ax="$FASTSURFER_HOME/checkpoints/Axial_Weights_FastSurferCNN/ckpts/Epoch_30_training_state.pkl"
weights_cor="$FASTSURFER_HOME/checkpoints/Coronal_Weights_FastSurferCNN/ckpts/Epoch_30_training_state.pkl"
clean_seg=""
viewagg="check"
cuda=""
batch_size="1"
fastsurfercnndir="$FASTSURFER_HOME/FastSurferCNN"
data='/home/adni/adni/bids/bids'
dest='/home/cv/yb/data/test'
while read -r line
do
    arr=(${line/// })
    sub=${arr[0]}
    ses=${arr[1]}
    

    path=$data/$sub/$ses/anat/$sub'_'$ses'_T1w.nii.gz'
    mkdir   -p    $dest/$sub'_'$ses
    temp=$dest/$sub'_'$ses/seg.mgz


    pushd FastSurferCNN
    python eval.py --in_name $path  --conformed_name $path --out_name $temp --order 1 --network_sagittal_path $weights_sag  --network_axial_path $weights_ax  --network_coronal_path $weights_cor --batch_size 1  --simple_run  --run_viewagg_on $viewagg $cuda 
    popd
    cp $path   $dest/$sub'_'$ses/orig.nii.gz
    mri_convert $temp  $dest/$sub'_'$ses/seg.nii.gz 
done <'Test.txt'