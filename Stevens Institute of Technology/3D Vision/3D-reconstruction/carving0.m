
clear 
close all

tic

%% Initialization

% Read Silhouette images
silhouettes{8} = [];
for i = 0:7
    silhouettes{i+1} = imread(['silh_cam0' num2str(i) '_00023_0000008550.pbm']);
end

% find image sizes
[height, width, ~] = size(silhouettes{1}); 

% Read color images
images{8} = [];
for i = 0:7
   images{i+1} = double(imread(['cam0' num2str(i) '_00023_0000008550.png']));
end


% Camera calibration parameters
rawP = [ 776.649963  -298.408539 -32.048386  993.1581875 132.852554  120.885834  -759.210876 1982.174000 0.744869  0.662592  -0.078377 4.629312012;
    431.503540  586.251892  -137.094040 1982.053375 23.799522   1.964373    -657.832764 1725.253500 -0.321776 0.869462  -0.374826 5.538025391;
    -153.607925 722.067139  -127.204468 2182.4950   141.564346  74.195686   -637.070984 1551.185125 -0.769772 0.354474  -0.530847 4.737782227;
    -823.909119 55.557896   -82.577644  2498.20825  -31.429972  42.725830   -777.534546 2083.363250 -0.484634 -0.807611 -0.335998 4.934550781;
    -715.434998 -351.073730 -147.460815 1978.534875 29.429260   -2.156084   -779.121704 2028.892750 0.030776  -0.941587 -0.335361 4.141203125;
    -417.221649 -700.318726 -27.361042  1599.565000 111.925537  -169.101776 -752.020142 1982.983750 0.542421  -0.837170 -0.070180 3.929336426;
    94.934860   -668.213623 -331.895508 769.8633125 -549.403137 -58.174614  -342.555359 1286.971000 0.196630  -0.136065 -0.970991 3.574729736;
    452.159027  -658.943909 -279.703522 883.495000  -262.442566 1.231108    -751.532349 1884.149625 0.776201  0.215114  -0.592653 4.235517090];


% Camera matrices
P{8} = [];
for i=1:8
    for j=1:3
        P{i}(j,:) = rawP(i,4*(j-1)+1:4*(j-1)+4);
    end
end

% Fundamental matrices
F{8,8} = [];
for i = 1:8
    for j = 1:8
        F{i,j} = P{j} / P{i};
        F{i,j} = F{i,j} ./ F{i,j}(3,3);
    end
end

% Camera centers
Centers = zeros(4,8);
for i=1:8
    %tempP = P(:,:,i);
    Centers(1:4,i) = null(P{i});
    Centers(1:4,i)=Centers(1:4,i)/Centers(4,i);
end

clear rawP i j

%% Part 1: Voxel Construction
% Voxel limits
% X = [-2.5 2.5];
% Y = [-3 3];
% Z = [0 2.5];
X = [-.27 .96];
Y = [-1.64 -1.09];
Z = [-.04 1.66];

% Voxel node sizes
dx = .01;
dy = .01;
dz = .01;

nx = round ((X(2) - X(1)) / dx) + 1;
ny = round ((Y(2) - Y(1)) / dy) + 1;
nz = round ((Z(2) - Z(1)) / dz) + 1;
n = nx .* ny .* nz;

voxel = zeros(n, 7);
node = 1;
for x = X(1):dx:X(2)
    for y = Y(1):dy:Y(2)
        for z = Z(1):dz:Z(2)
            voxel(node,1:3) = [x y z];
            voted = 0;
            for camera = 1:8
                p_image = P{camera} * [x y z 1]';
                p_image = p_image ./ p_image(3);
                temp = p_image(1); p_image(1) = p_image(2); p_image(2) = temp;
                if p_image(1) >= 1 && p_image(1) < height && ...
                        p_image(2) >= 1 && p_image(2) < width
                    s = floor(p_image); 
                    point_check = silhouettes{camera}(s(1):s(1)+1,s(2):s(2)+1);
                    point_check = sum(point_check(:));
                    if point_check > 0
%                         voxel(node,4:6) = images{camera}(s(1),s(2),:);
                        voted = voted + 1;
                    end
                end
            end
            if voted == 8
                voxel(node,7) = 1;
            end
            node = node + 1;
        end
    end
end

voxel(voxel(:,7)==0,:)=[];
% numel(voxel(:,1))

clear X Y Z dx dy dz nx ny nz n i j x y z ...
    s node not_empty i j p_image look_for_pixel camera voted

%% Photoconsistency check

[nodes, ~] = size(voxel);
treshold = 800;

for node = 1:nodes
    picked_SAD = inf .* ones(1,8);
    for camera1 = 1:8
        agreement = 0;
        p_image1 = P{camera1} * [voxel(node,1:3) 1]';
        p_image1 = p_image1 ./ p_image1(3);
        temp = p_image1(1); p_image1(1) = p_image1(2); p_image1(2) = temp;
        if p_image1(1) < 1 || p_image1(1) >= height || ...
                        p_image1(2) < 1 || p_image1(2) >= width
%             voxel(node,7) = 0;
        else     
%             s1 = round(p_image1);
%             R1 = images{camera1}(s1(1),s1(2),1);
%             G1 = images{camera1}(s1(1),s1(2),2);
%             B1 = images{camera1}(s1(1),s1(2),3);
            s1 = floor(p_image1);
            e1 = p_image1 - s1;
            R1 = (1-e1(1)) .* (1-e1(2)) .* images{camera1}(s1(1),s1(2),1) + ...
                (e1(1)) .* (1-e1(2)) .* images{camera1}(s1(1)+1,s1(2),1) + ...
                (1-e1(1)) .* (e1(2)) .* images{camera1}(s1(1),s1(2)+1,1) + ...
                (e1(1)) .* (e1(2)) .* images{camera1}(s1(1)+1,s1(2)+1,1);
            G1 = (1-e1(1)) .* (1-e1(2)) .* images{camera1}(s1(1),s1(2),2) + ...
                (e1(1)) .* (1-e1(2)) .* images{camera1}(s1(1)+1,s1(2),2) + ...
                (1-e1(1)) .* (e1(2)) .* images{camera1}(s1(1),s1(2)+1,2) + ...
                (e1(1)) .* (e1(2)) .* images{camera1}(s1(1)+1,s1(2)+1,2);
            B1 = (1-e1(1)) .* (1-e1(2)) .* images{camera1}(s1(1),s1(2),3) + ...
                (e1(1)) .* (1-e1(2)) .* images{camera1}(s1(1)+1,s1(2),3) + ...
                (1-e1(1)) .* (e1(2)) .* images{camera1}(s1(1),s1(2)+1,3) + ...
                (e1(1)) .* (e1(2)) .* images{camera1}(s1(1)+1,s1(2)+1,3);
            
            prev = mod(camera1-1, 8);
            if prev == 0
                prev = 8;
            end
            next = mod(camera1+1, 8);
            if next == 0
                next = 8;
            end
            
            for camera2 = [prev next]
                p_image2 = P{camera2} * [voxel(node,1:3) 1]';
                p_image2 = p_image2 ./ p_image2(3);                
                temp = p_image2(1); p_image2(1) = p_image2(2); p_image2(2) = temp;
                if p_image2(1) < 1 || p_image2(1) >= height || ...
                            p_image2(2) < 1 || p_image2(2) >= width
%                     voxel(node,7) = 0;
                else     
%                     s2 = round(p_image1);
%                     R2 = images{camera2}(s2(1),s2(2),1);
%                     G2 = images{camera2}(s2(1),s2(2),2);
%                     B2 = images{camera2}(s2(1),s2(2),3);
                    s2 = floor(p_image2);
                    e2 = p_image2 - s2;
                    R2 = (1-e2(1)) .* (1-e2(2)) .* images{camera2}(s2(1),s2(2),1) + ...
                            (e2(1)) .* (1-e2(2)) .* images{camera2}(s2(1)+1,s2(2),1) + ...
                        (1-e2(1)) .* (e2(2)) .* images{camera2}(s2(1),s2(2)+1,1) + ...
                        (e2(1)) .* (e2(2)) .* images{camera2}(s2(1)+1,s2(2)+1,1);
                    G2 = (1-e2(1)) .* (1-e2(2)) .* images{camera2}(s2(1),s2(2),2) + ...
                        (e2(1)) .* (1-e2(2)) .* images{camera2}(s2(1)+1,s2(2),2) + ...
                        (1-e2(1)) .* (e2(2)) .* images{camera2}(s2(1),s2(2)+1,2) + ...
                        (e2(1)) .* (e2(2)) .* images{camera2}(s2(1)+1,s2(2)+1,2);
                    B2 = (1-e2(1)) .* (1-e2(2)) .* images{camera2}(s2(1),s2(2),3) + ...
                        (e2(1)) .* (1-e2(2)) .* images{camera2}(s2(1)+1,s2(2),3) + ...
                        (1-e2(1)) .* (e2(2)) .* images{camera2}(s2(1),s2(2)+1,3) + ...
                        (e2(1)) .* (e2(2)) .* images{camera2}(s2(1)+1,s2(2)+1,3);

                    SAD = abs(R1-R2)+ abs(G1-G2) + abs(B1-B2);
                    if SAD < treshold
                        agreement = agreement + 1;
                        if picked_SAD (camera1) > SAD
                            picked_SAD (camera1) = SAD;
                            RGB{camera1} = [R1 G1 B1];
                        end
                    end %if
                end %if
            end %camera2
        end %if
%         if agreement == 2
%             if picked_SAD (camera1) > SAD
%                 picked_SAD (camera1) = SAD;
%                 RGB{camera1} = [R1 G1 B1];
%             end
%         end
        
    end %camera1
    
    if agreement >= 2
        m = min(picked_SAD(:));
        if m == inf 
            voxel(node,7) = 0;
        else
            camera = find(picked_SAD==m);
            voxel(node, 4:6) = uint8(RGB{camera(1)});
        end
    else
        voxel(node,7) = 0;
    end
  
    
end %node

voxel(voxel(:,7)==0,:)=[];

clear i s1 s2 e1 e2 p_image1 p_image2 R1 R2 G1 G2 B1 B2 ...
    node nodes point_check camera1 camera2 treshold ...
    RGB SAD minSAD temp 

%% Write into a ply file
[nodes, ~] = size(voxel);

fileID = fopen('pointCloud.ply','w');

fprintf (fileID, '%s\n', 'ply');
fprintf (fileID, '%s\n', 'format ascii 1.0');
fprintf (fileID, '%s %u\n', 'element vertex', nodes);
fprintf (fileID, '%s\n', 'property float x');
fprintf (fileID, '%s\n', 'property float y');
fprintf (fileID, '%s\n', 'property float z');
fprintf (fileID, '%s\n', 'property uchar red');
fprintf (fileID, '%s\n', 'property uchar green');
fprintf (fileID, '%s\n', 'property uchar blue');
fprintf (fileID, '%s\n', 'element face 0');
fprintf (fileID, '%s\n', 'end_header');
for i = 1:nodes
    fprintf (fileID, '%4.2f %4.2f %4.2f ', voxel(i,1:3));
    fprintf (fileID, '%u %u %u\n', voxel(i,4:6));
end

fclose(fileID);

clear fileID i nodes

%% Finalization
toc

clear ans





