
% clear
% close all

tic

Scene{3} = [];
for i = 2
    Scene{i} = GetProjectSpecifications(i);
end

s = 2; r = 6;

left                = Scene{s}.Camera{r+1};
left.intensity      = Scene{s}.Image{r+1};

center              = Scene{s}.Camera{r};
center.intensity	= Scene{s}.Image{r};

right           	= Scene{s}.Camera{r-1};
right.intensity     = Scene{s}.Image{r-1};

n = [0 0 1];
D = 4:0.5:10;

I1 = center.intensity;
I2 = left.intensity;
% A = matching (I1, I2);
% H = autohomest2d(A);

[width, height, color] = size (center.intensity);
depth = size (D,2);
% cost = zeros (width, height, depth);
disparity_depth = zeros (width, height, 3, 'uint8');
window_size = 5;
half_window = floor(window_size/2);


% for A = [left right]
A = right;
% H_left = Homography (A.R, A.t, center.R, center.t, center.K, n, 4);
% for y = 1:width
%     for x = 1:height
%         temp = H_left * [x y 1]';
% %         temp = temp ./ temp(3);
%         x_left = round (temp(1));
%         y_left = round (temp(2));
%         if x_left > 0 & x_left < height & ...
%                     y_left > 0 & y_left < width
%             disparity_depth (y_left, x_left,:) = center.intensity(y,x,:);
%         end
%     end
% end
% 

disparity_depth = A.intensity;
for d = 5:0.5:9
    H_left = Homography (A.R, A.t, center.R, center.t, center.K, n, d);
    
    temp = H_left * [1418 1616    1]';
    temp = temp ./ temp(3);
    x_left = round (temp(1));
    y_left = round (temp(2));
    if x_left > 5 && y_left > 5 %&& 0
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,1) = 255;
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,2) = 0;
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,3) = 0;
    end
    
    temp = H_left * [2807 1646   1]';
    temp = temp ./ temp(3);
    x_left = round (temp(1));
    y_left = round (temp(2));
    if x_left > 5 && y_left > 5 %&& 0
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,1) = 0;
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,2) = 255;
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,3) = 0;
    end
    
    temp = H_left * [ 92 79   1]';
    temp = temp ./ temp(3);
    x_left = round (temp(1));
    y_left = round (temp(2));
    if x_left > 5 && y_left > 5 %&& 0
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,1) = 0;
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,2) = 0;
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,3) = 255;
    end
    
    temp = H_left * [ 2240 397    1]';
    temp = temp ./ temp(3);
    x_left = round (temp(1));
    y_left = round (temp(2));
    if x_left > 5 && y_left > 5 %&& 0
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,1) = 255;
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,2) = 255;
    disparity_depth (y_left-5:y_left+5, x_left-5:x_left+5,3) = 255;
    end
    
end


figure
imshow(disparity_depth)
% figure 
% imshow(left.intensity)
% end

toc


function H = Homography (R2, t2, R1, t1, K, n, d)

    M = [R1' -R1'*t1'; 0 0 0 1] * [R2 t2'; 0 0 0 1];
    R22 = M(1:3,1:3)';
    t22 = R22 * M(1:3,4);
    t22 = t22';
   
    H = (K * (R22 - (t22' * n) ./d)) / K;      
    
end


% This funcion forms a data structure as a project
% The project contains:
%   Name:               Data set name
%   numberofCameras:    number of camera and images
%   Path:               the current path of project files in my machine
%                       it should be adjusted in other machines.
%   Images:             An structure that keeps all the images.
%   Cameras:            An structure that keeps camera information.

function project = GetProjectSpecifications (proj_number)

    project_names = {'castle_entry' 'fountain' 'herzjesu'};
    number_of_cameras = [10 11 8];
    
    project.Name = project_names {proj_number};
    project.numberofCameras = number_of_cameras (proj_number);
    project.Path = [project_names{proj_number} '/'];

    project.Image = ReadImages (project);
    project.Camera = ReadCameras (project);

end


% This function is part of above function that read the images.
function images = ReadImages (project)
    images{project.numberofCameras} = [];
    for i = 1:project.numberofCameras
        file_name = [project.Path project.Name '_dense_images/00' ...
            num2str(i-1,'%02d') '.png'];
        images{i} = imread(file_name);
    end
end


% This function is part of above function that read the camera parametrs.
function cameras = ReadCameras (project)
    cameras{project.numberofCameras} = [];
    for i = 1:project.numberofCameras
        file_name = [project.Path project.Name '_dense_cameras/00' ...
            num2str(i-1,'%02d') '.png.camera'];
        temp = dlmread(file_name, ' ');
        cameras{i}.K = temp (1:3, 1:3);
        cameras{i}.R = temp (5:7, 1:3);
        cameras{i}.t = temp (8, 1:3);
        cameras{i}.C = temp (9, 1:2);
        cameras{i}.Cx = temp (9, 1);
        cameras{i}.Cy = temp (9, 2);
        file_name = [project.Path project.Name '_dense_p/00' ...
            num2str(i-1,'%02d') '.png.P'];
        temp = dlmread(file_name, ' ');
        cameras{i}.P = temp(1:3,1:4);
    end
end



function sad = SAD (left_window, right_window)
    
%     [~, ~, depth] = size(left_window);
%     sad = 0.0;
%     
%     for color = 1:depth
%         left = left_window (:,:,color);
%         right = right_window (:,:,color);
%         sad = sad + abs(double(left)-double(right));
%     end
    
    sad = abs(double(left_window)-double(right_window));
    sad = sum(sad(:));
        
end


