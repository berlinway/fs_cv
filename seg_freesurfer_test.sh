#!/bin/bash

conda activate fast
####关键命令
export FREESURFER_HOME=/home/cv/app/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# export FASTSURFER_HOME=${PWD}
# weights_sag="$FASTSURFER_HOME/checkpoints/Sagittal_Weights_FastSurferCNN/ckpts/Epoch_30_training_state.pkl"
# weights_ax="$FASTSURFER_HOME/checkpoints/Axial_Weights_FastSurferCNN/ckpts/Epoch_30_training_state.pkl"
# weights_cor="$FASTSURFER_HOME/checkpoints/Coronal_Weights_FastSurferCNN/ckpts/Epoch_30_training_state.pkl"
# clean_seg=""
# viewagg="check"
# cuda=""
# batch_size="1"
# fastsurfercnndir="$FASTSURFER_HOME/FastSurferCNN"
fastsurferdir='/home/cv/yb/data/adni_all'
data='/home/adni/adni/bids/bids'
dest='/home/data/dateset/ad/Test'
while read -r line
do
    arr=(${line/// })
    sub=${arr[0]}
    ses=${arr[1]}
    

    path=$data/$sub/$ses/anat/$sub'_'$ses'_T1w.nii.gz'
    temp=$dest/$sub'_'$ses/seg.mgz

    if [ -f "$path" ];then
    ./run_fastsurfer.sh --t1 $path  --run_viewagg_on 'gpu'   --sid $sub'_'$ses --sd $fastsurferdir/seg > $fastsurferdir/logs/out-$sub'_'$ses.log &
    sleep 300s
    fi
    # 如果文件不存在，进行记录
    if [ ! -f "$path" ];then
    echo $sub' '$ses >> ./labels/qs1.txt
    fi
    # pushd FastSurferCNN
    # python3 eval.py --in_name $path  --out_name $temp --order 1 --network_sagittal_path $weights_sag  --network_axial_path $weights_ax  --network_coronal_path $weights_cor --batch_size 1  --simple_run  --run_viewagg_on $viewagg $cuda 
    # popd
    # cp $path   $dest/$sub'_'$ses/orig.nii.gz
    # mri_convert $temp  $dest/$sub'_'$ses/seg.nii.gz 
done <'./labels/toy3.txt'