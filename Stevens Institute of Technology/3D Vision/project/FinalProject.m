

clear
close all

tic

Scene{3} = [];
for i = 1:3
    Scene{i} = GetProjectSpecifications(i);
end

s = 2; r = 5;

left                = Scene{s}.Camera{r+1};
left.intensity      = Scene{s}.Image{r+1};

center              = Scene{s}.Camera{r};
center.intensity	= Scene{s}.Image{r};

right           	= Scene{s}.Camera{r-1};
right.intensity     = Scene{s}.Image{r-1};

f = center.K(1,1);
B = center.t-left.t;
B = (B(1).^2 + B(2).^2 + B(3).^2) .^ 0.5;

load data.mat
data3DC = {BackgroundPointCloudRGB,ForegroundPointCloudRGB};
Ground_Truth = GenerateGroundTruth (data3DC, center.K);
figure; imshow(Ground_Truth,[])
% save Ground_Truth

Z = 5:0.1:9;

window_size = 5;
n = [0 0 1];
depth_map = FindDepth (left, center, right, n, Z, window_size);
e = abs(f .* B .* (depth_map - Ground_Truth));
figure; imshow(depth_map,[])
figure; imshow(e,[])
sum(e(:)) / numel(e(:))
figure; histogram(e(:))
figure; histogram(e(:),'Normalization','cdf')

n = [-1 0 1];
n = n ./ (n(1).^2 + n(2).^2 + n(3).^2) .^ 0.5;
depth_map_s = FindDepth (left, center, right, n, Z, window_size);
e_s = abs(f .* B .* (depth_map_s - Ground_Truth));
figure; imshow(depth_map_s,[])
figure; imshow(e_s,[])
sum(e_s(:)) / numel(e_s(:))
figure; histogram(e_s(:))
figure; histogram(e_s(:),'Normalization','cdf')


toc







%% Function Section


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

    sad = abs(double(left_window)-double(right_window));
    sad = sad(:,:,1)*0.299 + sad(:,:,2)*0.587 + sad(:,:,3)*0.114;
    sad = sum(sad(:));
        
end




function H = Homography (R2, t2, R1, t1, K, n, d)

    M = [R1' -R1'*t1'; 0 0 0 1] * [R2 t2'; 0 0 0 1];
    R22 = M(1:3,1:3)';
    t22 = R22 * M(1:3,4);
   
    H = (K * (R22 - (t22 * n) ./d)) / K;          
        
end





function depth_map = FindDepth (left, center, right, n, Z, window_size)


    half_window = floor(window_size/2);
    [width, height, ~] = size (center.intensity);
    depth_map = zeros (width, height);

    min_cost = inf * ones (width, height);
    for d_z = Z

        H_left = Homography (left.R, left.t, center.R, center.t, center.K, n, d_z);
        H_right = Homography (right.R, right.t, center.R, center.t, center.K, n, d_z);

        for x = 1+half_window:height-half_window
            for y = 1+half_window:width-half_window

                temp = H_left * [x y 1]';
                temp = temp ./ temp(3);
                x_left = round (temp(1));
                y_left = round (temp(2));

                temp = H_right * [x y 1]';
                temp = temp ./ temp(3);
                x_right = round (temp(1));
                y_right = round (temp(2));

                cost = 0; cost_right = 0; cost_left = 0;
                if x_right > half_window && x_right < height-half_window && ...
                        y_right > half_window && y_right < width-half_window
                    cost_right = 1;
                    cost = cost + SAD (...
                        center.intensity(y-half_window:y+half_window, ...
                        x-half_window:x+half_window,:), ...
                        right.intensity(y_right-half_window:y_right+half_window, ...
                        x_right-half_window:x_right+half_window,:));
                end

                if x_left > half_window && x_left < height-half_window && ...
                        y_left > half_window && y_left < width-half_window
                    cost_left = 1;
                    cost = cost + SAD (...
                        center.intensity(y-half_window:y+half_window, ...
                        x-half_window:x+half_window,:), ...
                        left.intensity(y_left-half_window:y_left+half_window, ...
                        x_left-half_window:x_left+half_window,:));
                end

                if cost_right && cost_left 
                    cost = cost ./ 2;
                end

                if cost < min_cost(y,x) && (cost_right || cost_left)
                    depth_map(y,x) = 1./d_z;
                    min_cost(y,x) = cost;
                end

            end
        end

    end

end




function GT = GenerateGroundTruth (data3DC, K)

    height = 3072;
    width = 2048;
    GT = zeros(width,height);
    
    for i = 1:2
        [~, n] = size(data3DC{i});
        for j = 1:n
            temp = K * [eye(3) [0 0 0]'] * [data3DC{i}(1:3,j); 1];
            temp = temp ./ temp(3);
            temp = round(temp);
            
            if temp(1) > 0 && temp(1) <= height && temp(2) > 0 && temp(2) <= width
                GT (temp(2), temp(1)) = 1./data3DC{i}(3,j);
                
            end
        end
    end
end
