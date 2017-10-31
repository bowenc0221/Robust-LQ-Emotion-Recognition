clear, clc;

data_path = 'PATH/TO/CAFFE_EMOTION/data/raw_data/HQ/';
file_name = {'train_1','train_2','train_3','train_4','train_5','train_6','train_7','train_8',...
             'train_9',...
             'dev_1','dev_2','dev_3','dev_4','dev_5','dev_6','dev_7','dev_8','dev_9'};

for n = 1:length(file_name)/2
    train_input{n,1} = [data_path,file_name{n},'.mat'];
end


for n = length(file_name)/2+1:length(file_name)
    test_input{n-length(file_name)/2,1} = [data_path,file_name{n},'.mat'];
end

save_path_train = 'PATH/TO/CAFFE_EMOTION/h5_files/HQ/train';
save_path_test = 'PATH/TO/CAFFE_EMOTION/h5_files/HQ/test';

options.mode = 'single';
options.augmentation = 0;
options.mean_sub = 0;
options.norm = 0;
options.split = 1;
% to generate LR or multi-scale LR
options.mix = 0;
options.mix_lr = [3,4,6];

generate_h5(train_input, 96, save_path_train, 128, options);
generate_h5(test_input, 96, save_path_test, 128, options);
