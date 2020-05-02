clear
close all
clc

tic

AdaRun = 3;


data = dlmread('pima-indians-diabetes.data.txt');
data = reshape(data,[],9);
active_feat = 1:8;

X = data(:,active_feat);
Y = data(:,end);
Y(Y == 0) = -1;

[N, f] = size(X);

D = 1 / N * ones(N,1);

alpha = zeros(1,AdaRun);
h = zeros(N,AdaRun);

strong_features = zeros(1,AdaRun);
strong_learners = zeros(1,AdaRun);
strong_directions = zeros(1,AdaRun);

weak_learners = zeros(f,AdaRun);
weak_directions = zeros(f,AdaRun);

for r = 1:AdaRun
    
    min_error = inf;
    
    for i = 1:f
        theta = unique(X(:,i));
        weak_error = inf;

        for j = 1:numel(theta)
            
            % Positive direction
            pred_labels = 2 * (X(:,i) > theta(j)) - 1;
            err = sum((Y ~= pred_labels) .* D) ./ sum(D);
            if err < weak_error
                weak_learners(i,r) = theta(j);
                weak_directions(i,r) = 1;
                weak_error = err;
            end
            if err < min_error
                strong_features(r) = i;
                min_error = err;
                strong_directions(r) = 1;
                h(:,r) = pred_labels;
                strong_learners(r) = theta(j);
            end
            
            % Negative Direction
            pred_labels = 2 * (X(:,i) < theta(j)) - 1;
            err = sum((Y ~= pred_labels) .* D) ./ sum(D);
            if err < weak_error
                weak_learners(i,r) = theta(j);
                weak_directions(i,r) = 2;
                weak_error = err;
            end
            if err < min_error
                strong_features(r) = i;
                min_error = err;
                strong_directions(r) = 2;
                h(:,r) = pred_labels;
                strong_learners(r) = theta(j);
            end

        end
    end
    
    alpha(r) = 0.5 * log((1-min_error)/min_error);
    D = D .* exp(-alpha(r) .* Y .* h(:,r)) ...
        ./ sum(exp(-alpha(r) .* Y .* h(:,r)));
    
    H = sign(h(:,1:r) * alpha(1,1:r)');
    fprintf(['\nThe accuracy for round %d is %4.2f%% ' ...
        'with following weak learners:\n\n'], ...
        r, sum(H==Y)/N*100)
    disp(weak_learners(:,r)')
    
end

H = sign(h * alpha');
fprintf ('\n\n\nStrong features are:\n\n')
disp(strong_features)
fprintf(['The final accuracy is %4.2f%% with following ' ...
    'strong learners:\n\n'], sum(H==Y)/N*100)
disp(strong_learners)
fprintf ('The directions of strong selections are:\n')
disp(strong_directions)
fprintf (['Note: \n\t1 means that greater than theat is in class 1 and, ' ...
        '\n\t2 means that greater than theta is in class 2.\n\n\n'])


toc