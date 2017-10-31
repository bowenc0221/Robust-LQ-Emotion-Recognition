function generate_h5(input, inputsz, savepath, chunksz, options)

% initialization
switch options.mode
    case 'single'
        data = zeros(inputsz, inputsz, 1, 1);
    case 'multi'
        data = zeros(inputsz, inputsz, 1, 3);
    otherwise
        error('Unknow mode.')
end
label = zeros(1, 1);
count = 0;

% generate data
for n = 1:length(input)
    
    load(input{n},'video','valence');
    
    switch options.mode
        case 'single'
            data(:,:,count+1:count+size(video,3)) = video;
        case 'multi'
            data(:,:,count+1:count+size(video,3)-2,1) = video(:,:,1:end-2);
            data(:,:,count+1:count+size(video,3)-2,2) = video(:,:,2:end-1);
            data(:,:,count+1:count+size(video,3)-2,3) = video(:,:,3:end-0);
        otherwise
            error('Unknow mode.')
    end
    
    label(1,count+1:count+size(video,3)) = valence;
    count = count + size(video,3);
end

if options.mix
    mix_lr = options.mix_lr;
    for n = 1:count
        data(:,:,n) = imresize(imresize(data(:,:,n),1/mix_lr(unidrnd(length(mix_lr))),'bicubic'),[96,96],'bicubic');
    end
end     

data = permute(data,[1,2,4,3]);
order = randperm(count);
data = data(:, :, :, order);
label = label(1, order); 

if options.augmentation
    data = flip(data,2);
end

if options.mean_sub
    data = data-mean(data(:));
end

if options.norm
    data = data./std(data(:));
end

switch options.mode
    case 'single'
        savepath = [savepath,'.h5'];
        created_flag = false;
        totalct = 0;
        
        for batchno = 1:floor(count/chunksz)
            last_read=(batchno-1)*chunksz;
            batchdata = data(:,:,:,last_read+1:last_read+chunksz); 
            batchlabs = label(1,last_read+1:last_read+chunksz);

            startloc = struct('dat',[1,1,1,totalct+1], 'lab', [1,totalct+1]);
            curr_dat_sz = store2hdf5(savepath, batchdata, batchlabs, ~created_flag, startloc, chunksz); 
            created_flag = true;
            totalct = curr_dat_sz(end);
        end
        h5disp(savepath);
    case 'multi'
        new_count = floor(count/options.split);
        for i = 1:options.split
            writeh5file(new_count, chunksz, data(:,:,:,(i-1)*new_count+1:i*new_count), label(1,(i-1)*new_count+1:i*new_count), [savepath,'_',num2str(i),'.h5']);
        end
    otherwise
        error('Unknow mode.')
end