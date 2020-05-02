
% Home work 1 - part 1
% CS 532 - 3D Computer Vision
% Saeid Hosseinipoor
% shossei1@stevens.edu


% Clear the variables and close all figures
clear
close all

% Read the image
image_file = 'basketball-court.ppm';
original_image = imread (image_file);

% Make a new empty array for file
new_height = 940;
new_width = 500;
converted_image = zeros (new_height, new_width, 3, 'uint8');

% Show the image to grab four corner points
image (original_image);

% Corner points read from the image
q1 = [247 52; 
      23 194; 
      280 280; 
      403 76]';
% New corner points
q2 = [1 1; 
      1 new_height; 
      new_width new_height; 
      new_width 1]';

% Convert corner points into 3D coordinates
original_corners = [q1; 1 1 1 1];
new_corners = [q2; 1 1 1 1];

% Extract the image dimendions
[h1, w1, d1] = size (original_image);
[h2, w2, d2] = size (converted_image);

% Normaliztion matrix 
%T1 = inv ([w1+h1 0 w1/2; 0 w1+h1 h1/2; 0 0 1]);
%T2 = inv ([w2+h2 0 w2/2; 0 w2+h2 h2/2; 0 0 1]);
T1 = eye (3); T2 = eye(3);

% Normalized pixels
p1 =  T1 * original_corners;
p2 =  T2 * new_corners;


% Construct the coefecient matrix
A = [];
for point = 1:4
       
    A = [A; 0 0 0 -p2(1,point) -p2(2,point) -1 ...
        p1(2,point) * p2(1,point) ...
        p1(2,point) * p2(2,point) ...
        p1(2,point)];
    
    A = [A; p2(1,point) p2(2,point) 1 0 0 0 ...
        -p1(1,point) * p2(1,point) ...
        -p1(1,point) * p2(2,point) ...
        -p1(1,point)];
   
end

% Find the solution
[~,~,V] = svd (A);
h = V(:,end);

H_tilda = [h(1) h(2) h(3); h(4) h(5) h(6); h(7) h(8) h(9)];
H = (T2 \ H_tilda) * T1;

% Test the homography matrix for corner points
original_corners
p3 = H * new_corners;
for i = 1:4
    p3(:,i) = p3(:,i) ./ p3(3,i);
end
p3


% Pixel interpolation 
for i2 = 1:new_width
    for j2 = 1:new_height
        p_old = H * [i2 j2 1]';
        p_old = p_old / p_old(3);
        i1 = floor(p_old(1));
        j1 = floor(p_old(2));
        a = p_old(1) - i1;
        b = p_old(2) - j1;
        
        if i1 > w1 - 1
            i1 = w1 - 1;
        end
        if j1 > h1 - 1 
            j1 = h1 - 1;
        end
                
        converted_image (j2, i2, :) = ...
            (1-a) * (1-b) * original_image (j1, i1, :) ...
            + a * (1-b) * original_image (j1, i1 + 1, :) ...
            + a * b * original_image (j1 + 1, i1 + 1, :) ...
            + (1-a) * b * original_image (j1 + 1, i1, :);
        
    end
end



% Test using library
figure('position', [1000, 500, new_width, new_height])
result_image = image (converted_image);
imwrite (converted_image, 'Basketball Court.png')


% Test using library
figure('position', [300, 300, new_width, new_height])
image (homwarp (homography(q1, q2), original_image, ...
    'size',[new_width,new_height]))
