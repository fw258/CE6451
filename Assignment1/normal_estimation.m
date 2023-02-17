function [nf,kd] = normal_estimation(object, maskobj,li_dir, li_value, images, band)
% input: object name (one of Apple, Pear and Elephant)
% illumination direction (number of image by 3) and intensity (number of image by 1)
% string array contains image file names
% band, 0: gray, 1: R, 2: G, 3: B
% remove shadow
% for each image, find whether each pixel will be included or not
include = zeros(size(maskobj,1),size(maskobj,2),length(images));
for i = 1:length(images)
    img  = imread(strcat(['./Assignment_1_tif_images/',object,'/'],images(i)));
    img = rgb2gray(img);
    % use mask to find the object
    obj = zeros(size(img,1),size(img,2));
    for j = 1:size(maskobj,1)
        for k = 1:size(maskobj,2)
            if maskobj(j,k) > 0
                obj(j,k) = img(j,k);
            end
        end
    end
    % number of non-zero pixel
    count = sum(sum(obj > 0));
    vector = obj(:);
    vector = sort(vector,'ascend');
    [idx,~] = find(vector,1);
    % find 10% of darkest pixel (a cutoff value) and remove pixels darker
    % than cutoff value
    cutoff = vector(floor(idx + count*0.1));
    for j = 1:size(obj,1)
        for k = 1:size(obj,2)
            if obj(j,k) > cutoff
                include(j,k,i) = 1;
            end
        end
    end
end

% calculate normal direction (pixel wise)
nf = zeros(size(maskobj,1), size(maskobj,2), 3);
kd = zeros(size(maskobj,1), size(maskobj,2)); % albedo
for j = 1:size(maskobj,1)
        for k = 1:size(maskobj,2)
            if maskobj(j,k) > 0
                clear pixels idx
                nimg = 0;
                for i = 1:length(images)
                    % if not excluded, record the pixel value
                    % (output light intensity)
                    if include(j,k,i) == 1
                        img  = imread(strcat(['./Assignment_1_tif_images/',object,'/'],images(i)));
                        if band == 0
                            img = rgb2gray(img);
                        elseif band == 1
                            img = img(:,:,1);
                        elseif band == 2
                            img = img(:,:,2);
                        else
                            img = img(:,:,3);
                        end
                        nimg = nimg + 1;
                        pixels(nimg) = img(j,k);
                        idx(nimg) = i;
                    end
                end
                % if few than 3 images, suppress calculation
                if nimg >= 3
                    clear mat_G 
                    % calculate normal direction based on page 30, lec 2-2
                    li_value_cal = li_value(idx);
                    li_dir_cal = li_dir(idx,:);
                    li_dir_value = bsxfun(@times, li_dir_cal, li_value_cal);
                    mat_G = li_dir_value\pixels';
                    kd(j,k) = norm(mat_G);
                    nf(j,k,:) = mat_G/norm(mat_G);
                end
            end
        end
end
save([object,num2str(band),'kd.mat'],'kd')
end
