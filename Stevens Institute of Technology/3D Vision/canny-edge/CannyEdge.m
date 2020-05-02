

tic


%% Initialization Section

clear
clc
close all

object{1}.filename = 'kangaroo.pgm';
object{2}.filename = 'plane.pgm';
object{3}.filename = 'red.pgm';

for i = 1:3
    object{i}.image = imread (object{i}.filename);
end

sobel_filter_x = [1 2 1]' * [-1 0 1];
sobel_filter_y = [1 0 -1]' * [1 2 1];


%% Problem 1 - Part 1

figure; k = 1;

for i = 1:3
    im = object{i}.image;
    for sigma = [1 3 5 7]
        window_size = 6*sigma + 1;
        GF = gausianFilter (window_size, sigma);
        imG = applyFilter (im, GF);
        subplot (3,4,k);
        imshow(imG,[]);
        title (['win = ' num2str(window_size) ...
            '      ,σ = ' num2str(sigma)]);
        k = k + 1;
    end
end



object{1}.sigma = 1;
object{2}.sigma = 1;
object{3}.sigma = 1;

object{1}.w = 6 * object{1}.sigma + 1;
object{2}.w = 6 * object{2}.sigma + 1;
object{3}.w = 6 * object{2}.sigma + 1;



%% Problem 1 - Part 2

object{1}.high_treshhold = 0.124;
object{2}.high_treshhold = 0.024;
object{3}.high_treshhold = 0.113;

object{1}.low_treshhold = 0.4 * object{1}.high_treshhold;
object{2}.low_treshhold = 0.4 * object{2}.high_treshhold;
object{3}.low_treshhold = 0.4 * object{3}.high_treshhold;

figure;

for n = 1:3
    
    GF = gausianFilter (object{n}.w, object{n}.sigma);
    Sx = convFilters (sobel_filter_x, GF);
    Gx = applyFilter (object{n}.image, Sx);
    Sy = convFilters (sobel_filter_y, GF);
    Gy = applyFilter (object{n}.image, Sy);
    G = hypot (Gx, Gy);
    G = G ./ max(G(:));
    object{n}.G = G;
%     prctile (G(:),70)
    GL = G;
    GL (or (GL < object{n}.low_treshhold, GL >= object{n}.high_treshhold)) = 0;
    object{n}.G_low = GL;
    G (G < object{n}.high_treshhold) = 0;
    object{n}.G_high = G;
    object{n}.Ga = atan2 (Gx, Gy);
    subplot (1,3,n);
    imshow (object{n}.G_high, []);
    
end

% figure;  imshow(object{3}.Ga,[]);




%%

figure;

for n = 1:3
    
    image = object{n}.image;
    [H, W] = size (image);
    G = object{n}.G_high;
    Ga = object{n}.Ga ./ pi * 8;
    canny = zeros (H, W);
    
    for i = 2:H-1
        for j = 2:W-1
            
            if or( and(Ga(i,j)>=-5, Ga(i,j)<-3), and(Ga(i,j)>=3, Ga(i,j)<5))
                if and(and(G(i,j)>=G(i-1,j), G(i,j)>=G(i+1,j)), G(i,j) ~=0)
                    canny(i,j) = 1;
                end
                
            elseif or( and(Ga(i,j)>=-1, Ga(i,j)<1), or(Ga(i,j)>=7, Ga(i,j)<-7))
                if and(and(G(i,j)>=G(i,j-1), G(i,j)>=G(i,j+1)), G(i,j) ~=0)
                    canny(i,j) = 1;
                end
                
            elseif or( and(Ga(i,j)>=-7, Ga(i,j)<-5), and(Ga(i,j)>=1, Ga(i,j)<3))
                if and(and(G(i,j)>=G(i-1,j+1), G(i,j)>=G(i+1,j-1)), G(i,j) ~=0)
                    canny(i,j) = 1;
                end
                
                
            elseif or( and(Ga(i,j)>=-3, Ga(i,j)<-1), and(Ga(i,j)>=5, Ga(i,j)<7))
                if and(and(G(i,j)>=G(i-1,j-1), G(i,j)>=G(i+1,j+1)), G(i,j) ~=0)
                    canny(i,j) = 1;
                end
                
            end
        end
    end
    
    object{n}.canny = canny;
    subplot (2,3,n);
    imshow(canny);
    subplot (2,3,n+3);
    imshow(edge(image,'canny'))
end




toc






%% Function Section


% This function produces gaussian filter in given size and sigma
% It's zero mean gaussian distribution
function GF = gausianFilter (window_size_, sigma_)
    
    if nargin < 2
        sigma_ = 1;
    end
    
    half_size_ = floor (window_size_./2);
    
    GF = zeros (window_size_); 
    for i = 1:window_size_
        for j = 1:window_size_
            GF(i,j) = exp (-((i-half_size_-1).^2+(j-half_size_-1).^2)./(2.*sigma_.^2)) ...
                ./ (2 .* pi .* sigma_.^2);
        end
    end

    GF = GF ./ sum(GF(:));
end





% This fucntion add edges to the image
% Input arguments are image, edge size, and edge type
% Edge types are black, cirdular, replicate, and symmetric
% Default edge is symmetric

function converted_image = addEdges (image, size_, type)

    if nargin < 3
        type = 'symmetric';
    end
    
    h = floor (size_./2);
    if size(h,2) == 1
        h(2) = h(1);
    end
    [H, W] = size (image);
    
    converted_image = zeros (H+2.*h(1), W+2.*h(2));
    converted_image (h(1)+1:H+h(1),h(2)+1:W+h(2)) = image;
    
    switch lower(type)
        case 'symmetric'
            converted_image (1:h(1),:) = ...
                flipud(converted_image(h(1)+1:2*h(1),:));
            converted_image (H+h(1):H+2*h(1),:) = ...
                flipud(converted_image(H-1:H+h(1)-1,:));
            converted_image (:,1:h(2)) = ...
                fliplr(converted_image(:,h(2)+1:2*h(2)));
            converted_image (:,W+h(2):W+2*h(2)) = ...
                fliplr(converted_image(:,W-1:W+h(2)-1));

        case 'circular'
            converted_image (1:h(1),:) = ...
                converted_image(H+1:H+h(1),:);
            converted_image (H+h(1)+1:H+2*h(1),:) = ...
                converted_image(h(1)+1:2*h(1),:);
            converted_image (:,1:h(2)) = ...
                converted_image(:,W+1:W+h(2));
            converted_image (:,W+h(2)+1:W+2*h(2)) = ...
                converted_image(:,h(2)+1:2*h(2));
        
        case 'replicate'
            converted_image (1:h(1),:) = ...
                converted_image(h(1)+1:2*h(1),:);
            converted_image (H+h(1)+1:H+2*h(1),:) = ...
                converted_image(H+1:H+h(1),:);
            converted_image (:,1:h(2)) = ...
                converted_image(:,h(2)+1:2*h(2));
            converted_image (:,W+h(2)+1:W+2*h(2)) = ...
                converted_image(:,W+1:W+h(2));
    end

end








function converted_image = removeEdges (image, size_)
    
    h = floor (size_./2); 
    if size(h,2) == 1
        h(2) = h(1);
    end
    
    converted_image = image;
    
    converted_image (1:h(1),:) = [];
    converted_image (:,1:h(2)) = [];
    converted_image (end-h(1)+1:end,:) = [];
    converted_image (:,end-h(2)+1:end) = [];

end









function converted_iamge = applyFilter(image, filter, type)

    if nargin < 3
        type = 'symmetric';
    end
    
    filter_size = size (filter);
    bigger_image = double(addEdges (image, filter_size, type));
    
    [H, W] = size (image);
    [h, w] = size (filter);
    h = floor(h/2); 
    w = floor(w/2);
    
    converted_iamge = double(image);
    
    for i = 1:H
        for j = 1:W
            temp = filter .* bigger_image(i:i+2*h, j:j+2*w);
            converted_iamge (i,j) = sum(temp(:));
        end
    end
    
end








function CF = convFilters (F1, F2)

    [H1, W1] = size(F1);
    [H2, W2] = size(F2);
    
    H = max(H1, H2);
    W = max(W1, W2);
    
    F11 = [zeros((H-H1)/2, W1); F1;zeros((H-H1)/2, W1)];
    F22 = [zeros((H-H2)/2, W2); F2;zeros((H-H2)/2, W2)];
    
    [H1, W1] = size(F11);
    [H2, W2] = size(F22);
    
    H = max(H1, H2);
    W = max(W1, W2);
    
    F11 = [zeros(H1, (W-W1)/2) F11 zeros(H1, (W-W1)/2)];
    F22 = [zeros(H2, (W-W2)/2) F22 zeros(H2, (W-W2)/2)];
    
    CF = applyFilter (F11, F2, 'black');
    
end





