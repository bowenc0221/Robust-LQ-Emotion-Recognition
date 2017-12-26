# Robust Low-Quality Emotion Recognition

This is codes for [Robust Emotion Recognition from Low Quality and Low Bit Rate Video: A Deep Learning Approach](https://arxiv.org/abs/1709.03126)

## Requirements
* compile [CAFFE](http://caffe.berkeleyvision.org/) and matcaffe
* install MATLAB

## Usage
Download the data package for the Multimodal Affect Recognition Sub-Challenge (MASC) of the 6th Audio/Visual Emotion Challenge and Workshop (AVEC 2016): "Depression, Mood and Emotion".  

1. Use ```./matlabscripts/prepare_dataset.m``` to generate cropped faces.  
2. Use ```./matlabscripts/generate_h5/prepare_h5_files.m``` to generate HDF5 files for training  
3. Use network ```./experiments/network/model_1F_CNN+D.prototxt``` and solver ```./experiments/solver/solver_1F_CNN+D.prototxt``` for HQ and LQ  

4. Use ```./pretrain/generate_train.m``` and ```./pretrain/generate_test.m``` to generate HDF5 files for SR model  
5. Use ```./pretrain/Pretrain_solver.prototxt``` to train SR model  

6. Use ```./experiments/network/model_1F_CNN+D_vlqr_non_joint.prototxt``` and ```./experiments/solver/solver_1F_CNN+D_vlqr_non_joint.prototxt``` for LQ-non-joint  
7. Use ```./experiments/network/model_1F_CNN+D_vlqr.prototxt``` and ```./experiments/solver/solver_1F_CNN+D_vlqr.prototxt``` for vlqr  

## Pretrain Model
You can download the pretrained model from [Dropbox](https://www.dropbox.com/sh/9qmsk7xottrtuht/AAAUnjcZ8o4JWkUdSYhrmEuNa/MATLABscripts/recon/weights?dl=0&lst=)  

## Citation
If you use this code for research, please cite our papers:

```
@article{cheng2017robust,
  title={Robust emotion recognition from low quality and low bit rate video: A deep learning approach},
  author={Cheng, Bowen and Wang, Zhangyang and Zhang, Zhaobin and Li, Zhu and Liu, Ding and Yang, Jianchao and Huang, Shuai and Huang, Thomas S},
  journal={arXiv preprint arXiv:1709.03126},
  year={2017}
}
```

```
@article{liu2017enhance,
  title={Enhance Visual Recognition under Adverse Conditions via Deep Networks},
  author={Liu, Ding and Cheng, Bowen and Wang, Zhangyang and Zhang, Haichao and Huang, Thomas S},
  journal={arXiv preprint arXiv:1712.07732}, year={2017} }
```
