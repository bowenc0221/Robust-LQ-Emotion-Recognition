# Robust LQ Emotion Recognition

## Usage
Download the data package for the Multimodal Affect Recognition Sub-Challenge (MASC) of the 6th Audio/Visual Emotion Challenge and Workshop (AVEC 2016): "Depression, Mood and Emotion".  

1. Use /MATLAB_Scripts/prepare_dataset.m to generate cropped faces.  
2. Use /MATLAB_Scripts/generate_h5/prepare_h5_files.m to generate HDF5 files for training  
3. Use network Experiments/network/model_1F_CNN+D.prototxt and solver Experiments/solver/solver_1F_CNN+D.prototxt for HQ and LQ  

4. Use /Pretrain/generate_train.m(test) to generate HDF5 files for SR model  
5. Use /Pretrain/Pretrain_solver.prototxt to train SR model  

6. Use /Experiments/network/model_1F_CNN+D_vlqr_non_joint.prototxt and /Experiments/solver/solver_1F_CNN+D_vlqr_non_joint.prototxt for LQ-non-joint  
7. Use /Experiments/network/model_1F_CNN+D_vlqr.prototxt and /Experiments/solver/solver_1F_CNN+D_vlqr.prototxt for vlqr  
