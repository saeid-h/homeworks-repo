
% Home work 1 - part 1
% CS 532 - 3D Computer Vision
% Saeid Hosseinipoor
% shossei1@stevens.edu

% This code is completion of given sample code

% Sample use of PointCloud2Image(...)
% 
% The following variables are contained in the provided data file:
%       BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size
% None of these variables needs to be modified


clc
clear all
% load variables: BackgroundPointCloudRGB,ForegroundPointCloudRGB,K,crop_region,filter_size)
load data.mat

data3DC = {BackgroundPointCloudRGB,ForegroundPointCloudRGB};
R       = eye(3);

step_size = 0.25;
max_step = 10;
move    = [0 0 -step_size]';

% Estimate the center postion of foreground object
x_FG = mean (ForegroundPointCloudRGB (1,:))
y_FG = mean (ForegroundPointCloudRGB (2,:))
z_FG = mean (ForegroundPointCloudRGB (3,:))
t = -[x_FG y_FG 0]';

K (1,1) = K(1,1) .* 400 ./ 250;
K (2,2) = K(2,2) .* 640 ./ 400;
K_Dolly = K;

seq = 0;

for step = [0:max_step max_step-1:-1:0]
    seq = seq + 1;
    tic
    fname         = sprintf('DollyZoomFrame%03d.jpg',seq);
    fprintf         ('\nGenerating %s',fname);
    
    t (3)         = step * -step_size;
    
    K_Dolly (1,1) = K(1,1) .* ((z_FG + t(3)) ./ z_FG);
    K_Dolly (2,2) = K(2,2) .* ((z_FG + t(3)) ./ z_FG);
    M             = K_Dolly * [R t];
    
    im            = PointCloud2Image (M,data3DC,crop_region,filter_size);
    imwrite         (im, fname);
    toc    
end
