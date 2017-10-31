function output = eval_video(data, options)

    results = zeros(1,1);
    feature = zeros(300,1);
    for n = 1:size(data,3)
        res = options.single_net.forward({data(:,:,n)});
        results(n) = res{1};
        if options.save_feature
            feature(:,n) = options.single_net.blobs('fc4').get_data();
        end
    end

    output.results = results;
    if options.save_feature
        output.feature = feature;
    end
end