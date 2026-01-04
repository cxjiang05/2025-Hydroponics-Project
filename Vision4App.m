function [LightLevel, PlantHeight, Blooming, image] = Vison4App(cam)
% Vision4App captures an image, analyzes plant features (light level, height, blooming)
% cam - a camera object passed in (currently unused, image captured internally)
% Returns:
%   LightLevel - mean light intensity of cropped image
%   PlantHeight - tallest plant height in inches
%   Blooming - 1 if red blooms detected, 0 if none
%   image - captured full image

% --- Capture Image from Camera ---
cam = webcam('USB Camera');        % exact original line
image = snapshot(cam);   % exact original line
clear cam

% === Brightness Boost ===
brightnessFactor = 7;  % 1 = no change, >1 = brighter
img = im2double(image);
img = img * brightnessFactor;
img(img > 1) = 1;        % clip to max 1

figure;
imshow(img);
title('Captured Image');

% --- Crop Image for Analysis ---
[height, width, ~] = size(image);
cropRect = [width/4, height/4, width/2, height/2];
croppedImg = imcrop(image, cropRect);

figure, imshow(croppedImg);
title('Cropped Image');

% --- Mean Light Level ---
if size(croppedImg,3) == 3
    grayImg = rgb2gray(croppedImg);
else
    grayImg = croppedImg;
end

LightLevel = mean(grayImg(:));
disp(['Mean Light Level of Background: ', num2str(LightLevel)]);

% --- Plant Mask Processing ---
binaryImg = imbinarize(grayImg, 'adaptive', 'ForegroundPolarity','bright','Sensitivity',0.4);
figure, imshow(binaryImg);
title('Binary Image');

se = strel('disk',3);
cleanedBinaryImg = imclose(imopen(binaryImg,se), se);
figure, imshow(cleanedBinaryImg);
title('Cleaned Binary Image');

% Extract plants using color threshold
lowerThreshold = [30,100,30];
upperThreshold = [100,255,100];

plantMask = (croppedImg(:,:,1)>=lowerThreshold(1) & croppedImg(:,:,1)<=upperThreshold(1)) & ...
            (croppedImg(:,:,2)>=lowerThreshold(2) & croppedImg(:,:,2)<=upperThreshold(2)) & ...
            (croppedImg(:,:,3)>=lowerThreshold(3) & croppedImg(:,:,3)<=upperThreshold(3));

extractedPlants = uint8(zeros(size(croppedImg)));
for c = 1:3
    extractedPlants(:,:,c) = croppedImg(:,:,c).*uint8(plantMask);
end

figure, imshow(extractedPlants);
title('Extracted Plants');

% --- Plant Height Detection ---
lowerThreshold = [25,70,25];
upperThreshold = [120,255,120];

plantMaskFull = (image(:,:,1)>=lowerThreshold(1) & image(:,:,1)<=upperThreshold(1)) & ...
                (image(:,:,2)>=lowerThreshold(2) & image(:,:,2)<=upperThreshold(2)) & ...
                (image(:,:,3)>=lowerThreshold(3) & image(:,:,3)<=upperThreshold(3));

plantMaskCleanFull = bwareaopen(imfill(plantMaskFull,'holes'),50);
[Lfull, numPlantsFull] = bwlabel(plantMaskCleanFull);

if numPlantsFull > 0
    statsFull = regionprops(Lfull,'BoundingBox');
    plantHeightsFull = zeros(numPlantsFull,1);

    for k = 1:numPlantsFull
        plantHeightsFull(k) = statsFull(k).BoundingBox(4);
    end

    tallestPlantHeightPixels = max(plantHeightsFull);
    totalImageHeightPixels = size(image,1);
    PlantHeight = (tallestPlantHeightPixels/totalImageHeightPixels)*9;  % convert to inches
else
    PlantHeight = NaN;
end

% RED BLOOM DETECTION (USING BRIGHTENED IMAGE) 


% Use the brightened image in the cropped region
cropBright = imcrop(img, cropRect);

R = cropBright(:,:,1);
G = cropBright(:,:,2);
B = cropBright(:,:,3);

% Convert to double for math
R = double(R); G = double(G); B = double(B);

% RED DETECTION RULE FOR BRIGHTENED IMAGES
% - Red must be bright
% - Red must dominate green and blue even after brightening
redMask = (R > 0.4) & ...          % at least 40% brightness
          (R > G + 0.15) & ...     % red noticeably stronger
          (R > B + 0.15);          % red noticeably stronger

Blooming = any(redMask(:));

figure;
imshow(redMask);
title('Detected Red Bloom Mask (Brightened Image)');



% --- Show Red Bloom Mask as Image ---
figure;
imshow(redMask);
title('Detected Red Bloom Mask');

disp('==========================================================');
disp('                   FINAL ANALYSIS RESULTS                 ');
disp('==========================================================');
fprintf('Mean Light Level: %.1f\n', LightLevel);
fprintf('Tallest Plant Height: %.2f inches\n', PlantHeight);
if Blooming
    disp('Blooms: DETECTED');
else
    disp('Blooms: NONE DETECTED');
end
disp('==========================================================');

end