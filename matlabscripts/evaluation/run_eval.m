clear,clc,close all;
addpath('PATH/TO/caffe/matlab/');
caffe.reset_all();
gpu_id = 0;
caffe.set_mode_gpu();
caffe.set_device(gpu_id);
display_ind = 0;

single_model = '../recon/deploy/model_1F_CNN+D.prototxt';
single_weights = '../recon/weights/class/HQ.caffemodel';
options.single_net = caffe.Net(single_model, single_weights, 'test');

options.save_feature = 0;

data_path = '/ws/ifp-06_1/bcheng9/ACMMM2017/data/raw_data/HQ/';
file_name = {'dev_1','dev_2','dev_3','dev_4','dev_5','dev_6','dev_7','dev_8','dev_9'};
results = cell(size(file_name));
feature = cell(size(file_name));
ground_truth = cell(size(file_name));
RMSE = zeros(size(file_name));
CC = zeros(size(file_name));
CCC = zeros(size(file_name));

for n = 1:length(file_name)
    load([data_path,file_name{n},'.mat']);
    fprintf('Evaluating %d\n',n);
    tic;
    output = eval_video(permute(single(video),[1,2,3]),options);
    toc;
    results{n} = output.results;
    if options.save_feature
        feature{n} = output.feature;
    end
    ground_truth{n} = valence;
    RMSE(n) = sqrt(sum((results{n}-valence).^2)/length(valence));
    CC(n) = mean((valence-mean(valence)).*(results{n}-mean(results{n})))/...
            (std(valence)*std(results{n}));
    CCC(n) = 2*CC(n)*std(valence)*std(results{n})/...
             (var(valence)+var(results{n})+(mean(valence)-mean(results{n}))^2);
    if display_ind
        figure;hold on;
        plot(video_time,valence,'Color','k','LineWidth',2);
        plot(video_time,results{n},'Color','b','LineWidth',2);
        hold off;
        title({['RMSE: ',num2str(RMSE(n))],['CC: ',num2str(CC(n))],['CCC: ',num2str(CCC(n))]});
        legend('Ground Truth','CNN Prediction');
    end
end

total_res = [];
total_gnd = [];

for n = 1:length(file_name)
    total_res = [total_res, results{n}];
    total_gnd = [total_gnd, ground_truth{n}];
end

total_RMSE = sqrt(mean((total_res-total_gnd).^2));
total_CC = mean((total_gnd-mean(total_gnd)).*(total_res-mean(total_res)))/...
           (std(total_gnd)*std(total_res));
total_CCC = 2*total_CC*std(total_gnd)*std(total_res)/...
           (var(total_gnd)+var(total_res)+(mean(total_gnd)-mean(total_res))^2);
figure;hold on;
plot(total_gnd,'Color','k','LineWidth',2);
plot(total_res,'Color','b','LineWidth',2);
hold off;
title({['RMSE: ',num2str(total_RMSE)],['CC: ',num2str(total_CC)],['CCC: ',num2str(total_CCC)]});
legend('Ground Truth','CNN Prediction');