clear
close all
clc

%rng(1000);
tic

X = [1 1 -1 0 2;
    0 0 1 2 0;
    -1 -1 1 1 0;
    4 0 1 2 1;
    -1 1 1 1 0;
    -1 -1 -1 1 0;
    -1 1 1 2 1];

Y = [2 1 2 1 1 1 2]';

data = [Y X]; 

fprintf('\n\nThe initial weight vector:\n')
w = [3 1 1 -1 2 -7]

C1 = data(data(:,1)==1,:);
C1(:,1) = 1;
C2 = data(data(:,1)==2,:);
C2(:,1) = 1;
 
y = [C1; -C2];
 
notConverged = true;
iteration = 0;
max_iteration = 100;

while notConverged || iteration > max_iteration
    
    iteration = iteration + 1;
    fprintf('\n\nIteration %d:\n', iteration)
    notConverged = false;
    
    for i = 1:size(y,1)
        if (w*y(i,:)'<= 0)            
            notConverged = true;
            fprintf('\tThe perceptrone %d classification is wrong.\n ', i)
            fprintf('\n\tThe new weight vector is:')
            w = w + y(i,:)
        else
            fprintf('\tThe perceptrone %d classification is right.\n ', i)
        end         
    end
    
end


fprintf('\n\nThe final weight vector:\n')
        w
        
toc