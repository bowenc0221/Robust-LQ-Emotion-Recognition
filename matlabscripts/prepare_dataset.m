clear,clc,close all,

data_path = 'PATH/TO/AVEC_2016';
video_path = fullfile(data_path,'recordings_video');
time_path = fullfile(data_path,'recordings_video_frame_time');

file_name = {'train_1','train_2','train_3','train_4','train_5','train_6','train_7','train_8',...
             'train_9',...
             'dev_1','dev_2','dev_3','dev_4','dev_5','dev_6','dev_7','dev_8','dev_9'};

save_root = 'PATH/TO/CAFFE_EMOTION';

%%%%%%%%%%%% CHANGE save DIR %%%%%%%%%%%%%
save_dir = fullfile(save_root,'data','raw_data','HQ'); % save HQ, change here for different LQ

imSize = 96;

noDebug = 1; % 0: debug mode
isDisplay = 0; % 1: display every cropped faces
isSave = 1; % 1: save cropped faces

for n = 1:length(file_name)^noDebug
    tic;
    fprintf('Start processing %d th file.\n',n);
    
    % load frame-time pair
    frame_time = dlmread(fullfile(time_path,[file_name{n},'.csv']),';',1,0);
    
    % load bbox
    load(fullfile(save_root,'data/bbox',[file_name{n},'.mat']))
    bbox_time = time;
    
    % load gsd
    load(fullfile(save_root,'data/gsd',[file_name{n},'.mat']))
    gsd_time = time;
    
    % load video and initialize
    v = VideoReader(fullfile(video_path,[file_name{n},'.mp4']));
    video = zeros(imSize,imSize,1);
    valence = zeros(1,1);
    video_time = zeros(1,1);
    count = 1;
    
    % processing frame-by-frame
    for i = 1:size(frame_time,1)
        real_time = frame_time(i,2);
        real_bbox_idx = find(bbox_time == real_time);
        real_gsd_idx = find(gsd_time == real_time);
        if isempty(real_bbox_idx) || isempty(real_gsd_idx)
            error('No matched bbox or gsd!')
        end
        % left-top x, lefp-top y, width, height
        cur_bbox = bbox(real_bbox_idx,:);
        temp = readFrame(v);
        
        if sum(cur_bbox,2) ~= 0 && cur_bbox(3)>100 && cur_bbox(4)>100
            temp = rgb2ycbcr(temp);
            temp = temp(:,:,1);
            temp = single(temp)/255;
            [hei,wid] = size(temp);
            
            
            left = ceil(cur_bbox(1));
            top = ceil(cur_bbox(2));
            right = ceil(cur_bbox(1)+cur_bbox(3)-1);
            bot = ceil(cur_bbox(2)+cur_bbox(4)-1);

            if top < 1, top = 1; end
            if bot > hei, bot = hei; end
            if left < 1, left = 1; end
            if right > wid, right = wid; end
            
            temp_cropped = imresize(temp(top:bot,...
                                         left:right),...
                           [imSize,imSize],'bicubic');
                       

            %%%%%%%%%%%%%%%%%%%%%%%%
            %%%% CHANGE HERE %%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%
            % temp_cropped = imresize(imresize(temp_cropped, 1/16, 'bicubic'), [imSize,imSize], 'bicubic');

            if isDisplay
                fprintf('Frame: %d, x: %d, y: %d, width: %d, height: %d\n',...
                        i,floor(cur_bbox(1)),floor(cur_bbox(2)),...
                          floor(cur_bbox(3)),floor(cur_bbox(4)));
                figure(1000),imshow(temp_cropped);
                pause(0.5)
            end
            video(:,:,count) = temp_cropped;
            valence(count) = gsd(real_gsd_idx);
            video_time(count) = real_time;
            count = count + 1;
        end
    end
    
    % save results
    if isSave
        % warning('Not implemented!')
        fprintf('Saving %s to file %s.\nVideo size: %d. \n',file_name{n},fullfile(save_dir,[file_name{n},'.mat']),size(video,3));
        save(fullfile(save_dir,[file_name{n},'.mat']),'video','valence','video_time');
        fprintf('Time: %f minutes.\n',toc/60);
    end
end
