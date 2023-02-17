% input object names, one of Apple, Pear, Elephant
% output illumination direction, intensity, mask of the object and image
% file names
function [li_dir, li_value, maskobj,images] = illum_dir_int(object)

mask1 = imread(['./Assignment_1_tif_images/', object, '/mask_dir_1.png']);
mask2 = imread(['./Assignment_1_tif_images/', object, '/mask_dir_2.png']);
maskobj = imread(['./Assignment_1_tif_images/', object, '/mask.png']);
% for input light intensity calculation
maski = imread(['./Assignment_1_tif_images/', object, '/mask_I.png']);
% change masks to grey scale values
mask1 = rgb2gray(mask1);
mask2 = rgb2gray(mask2);
maskobj = rgb2gray(maskobj);
maski = rgb2gray(maski);
% make a list of image names
directory = dir(['./Assignment_1_tif_images/', object]);
filenames = strings(length(directory),1);
for i = 1:length(directory)
    filenames(i) = directory(i).name;  
end
filenames = filenames(3:end);
n = 1;
for i = 1:length(filenames)
    str = regexp(filenames(i),'[\d.]','split');
    type = str{end};
    if strcmp(type,'tif')
        images(n) = filenames(i);
        n = n + 1;
    end
end

% for each image, get the intensity of input light (a number)
li_value = zeros(length(images),1);
for i = 1:length(images)
    img  = imread(strcat(['./Assignment_1_tif_images/',object,'/'],images(i)));
    % change to gray scale
    img = rgb2gray(img);
    whiteball = zeros(size(img,1),size(img,2));
    for j = 1:size(maski,1)
        for k = 1:size(maski,2)
            if maski(j,k) > 0
                whiteball(j,k) = img(j,k);
            end
        end
    end
    li_value(i) = max(whiteball,[],'all');
end

% find radius of two metal ball (maximum number of non-zeros in a row/2)
r1 = max(sum(mask1>0,2))/2;
% find location of centers for two metal ball
firstrow = find(sum(mask1>0,2),1,'first');
lastrow = find(sum(mask1>0,2),1,'last');
center1(1) = floor(firstrow + (lastrow - firstrow + 1)/2);
firstcol = find(sum(mask1>0,1),1,'first');
lastcol = find(sum(mask1>0,1),1,'last');
center1(2) = floor(firstcol + (lastcol - firstcol + 1)/2);
r2 = max(sum(mask2>0,2))/2;
firstrow = find(sum(mask2>0,2),1,'first');
lastrow = find(sum(mask2>0,2),1,'last');
center2(1) = floor(firstrow + (lastrow - firstrow + 1)/2);
firstcol = find(sum(mask2>0,1),1,'first');
lastcol = find(sum(mask2>0,1),1,'last');
center2(2) = floor(firstcol + (lastcol - firstcol + 1)/2);
% angle of view
v = [0,0,1]';
% for each image, get the direction of input light (average two metal ball)
li_dir = zeros(length(images),3);
for i = 1:length(images)
    img  = imread(strcat(['./Assignment_1_tif_images/',object,'/'],images(i)));
    img = rgb2gray(img);
    metalball1 = zeros(size(img,1),size(img,2));
    metalball2 = zeros(size(img,1),size(img,2));
    for j = 1:size(maski,1)
        for k = 1:size(mask1,2)
            if mask1(j,k) > 0
                metalball1(j,k) = img(j,k);
            end
            if mask2(j,k) > 0
                metalball2(j,k) = img(j,k);
            end
        end
    end
    % metalball1 normal direction
    maximum = max(max(metalball1));
    [m1,m2]=find(metalball1==maximum,1); % location of the shinest point
    x1 = m1 - center1(1);
    y1 = m2 - center1(2);
    z1 = sqrt(r1^2 - x1^2 - y1^2);
    % normal at the shinest point
    n1 = [x1,y1,z1]'/r1;
    l1 = 2*n1'*v*n1 - v;
    % metalball2 normal direction
    maximum = max(max(metalball2));
    [m1,m2]=find(metalball2==maximum,1);
    x2 = m1 - center2(1);
    y2 = m2 - center2(2);
    z2 = sqrt(r2^2 - x2^2 - y2^2);
    n2 = [x2,y2,z2]'/r2;
    l2 = 2*n2'*v*n2 - v;
    % average the two directions to get input light direction
    li_dir(i,:) = (l1 + l2)/2;
end
end
