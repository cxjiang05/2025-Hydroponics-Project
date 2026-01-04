function [pH, Char1] = ReadPH4App(cam, Char1)
% ReadPH4App captures an image, detects the pH strip, and returns the pH value

if nargin < 2
    Char1 = {};
end

%% =======================
%  Capture Image
% ========================
cam = webcam('USB Camera');       % <-- you may change name
img = snapshot(cam);
clear cam;

% Brightness adjustment
brightnessFactor = 2.0;
img = im2double(img);
img = img * brightnessFactor;
img(img > 1) = 1;

figure; imshow(img); title('Captured Image');
imwrite(img,'captured_image.png');


%% =======================
% Load Reference Colors
% =======================
refImage = imread('pHBlack.jpg');

refColors = struct( ...
    'pH3', [162 63 58]/255, ...
    'pH4', [183 96 53]/255, ...
    'pH5', [194 129 49]/255, ...
    'pH6', [200 147 53]/255, ...
    'pH7', [172 147 54]/255, ...
    'pH8', [139 131 82]/255, ...
    'pH9', [120 123 59]/255 ...
);

pHvals = 3:9;
fields = fieldnames(refColors);
refImageDouble = im2double(refImage);
refColorData = [];
tolerance = 0.12;   % MORE TOLERANT

for i = 1:numel(fields)
    targetColor = refColors.(fields{i});
    mask = ...
        abs(refImageDouble(:,:,1)-targetColor(1))<tolerance & ...
        abs(refImageDouble(:,:,2)-targetColor(2))<tolerance & ...
        abs(refImageDouble(:,:,3)-targetColor(3))<tolerance;

    [L, num] = bwlabel(mask);
    if num>0
        stats = regionprops(L,'Area','BoundingBox');
        [~, idx] = max([stats.Area]);
        bb = stats(idx).BoundingBox;
        cx = round(bb(1)+bb(3)/2);
        cy = round(bb(2)+bb(4)/2);
        refColorData = [refColorData; squeeze(refImageDouble(cy,cx,:))'];
    else
        refColorData = [refColorData; targetColor];
    end
end


%% =======================
% Strip Detection (More Broad)
% =======================
hsvImage = rgb2hsv(img);

% VERY WIDE ORANGE-YELLOW RANGE
orangeMask = ...
    hsvImage(:,:,1)>=0.02 & hsvImage(:,:,1)<=0.20 & ...   % broader hue
    hsvImage(:,:,2)>=0.25 & ...                           % more tolerant saturation
    hsvImage(:,:,3)>=0.25;                                % more tolerant brightness

% Heavy morphological filtering
orangeMask = imgaussfilt(double(orangeMask), 2) > 0.3;    % blur + threshold
orangeMask = imopen(orangeMask, strel('disk',7));
orangeMask = imclose(orangeMask, strel('disk',12));
orangeMask = bwareaopen(orangeMask, 300);

[labeled, num] = bwlabel(orangeMask);

if num == 0
    error('No pH strip detected (broad detection could not find it).');
end

stats = regionprops(labeled,'Area','BoundingBox');

% MUCH BROADER AREA LIMITS
minArea = 300;     % was 500
maxArea = 20000;   % was 5000 — big increase

validIdx = find([stats.Area] >= minArea & [stats.Area] <= maxArea);
if isempty(validIdx)
    error('Detected objects but none match pH strip size.');
end

% Pick largest found area
[~, idxMax] = max([stats(validIdx).Area]);
bbox = stats(validIdx(idxMax)).BoundingBox;

% Expand bounding box more
bbox(1) = max(1, bbox(1)-30);
bbox(2) = max(1, bbox(2)-30);
bbox(3) = bbox(3)+60;
bbox(4) = bbox(4)+60;

figure; imshow(img); hold on;
rectangle('Position', bbox,'EdgeColor','r','LineWidth',3);
title('Detected pH Strip');
hold off;


%% =======================
% Extract Patch Color
% =======================
cx = round(bbox(1)+bbox(3)/2);
cy = round(bbox(2)+bbox(4)/2);

patchSize = 45;  % bigger sample
x1 = max(1, cx-patchSize); x2 = min(size(img,2), cx+patchSize);
y1 = max(1, cy-patchSize); y2 = min(size(img,1), cy+patchSize);

patch = im2double(img(y1:y2, x1:x2, :)).^0.8;   % gamma correction
testColor = squeeze(mean(mean(patch,1),2));


%% =======================
% LAB Color Match
% =======================
testLAB = rgb2lab(reshape(testColor,[1 1 3]));
refLAB  = rgb2lab(reshape(refColorData,[size(refColorData,1) 1 3]));

distances = sqrt(sum((refLAB - testLAB).^2,3));
[~, bestIdx] = min(distances);

pH = pHvals(bestIdx);

Char1{end+1} = sprintf('pH read: %.2f', pH);
disp(['Detected pH (LAB match): ', num2str(pH)]);

end


