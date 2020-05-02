clear
close all
clc

%rng(1000);
tic

data = dlmread('pima-indians-diabetes.data.txt');
data = reshape(data,[],9);

% parameters
split_train_set = 0.5;
ML_accuracy = zeros(1,10);

% pick the new features
active_feat = 1:3;

% Maximum likelihood method 
for i = 1:10
    
    % Random selection 
    rp = randperm(length(data));
    data=data(rp,:);
      
    train_data = data(1:floor(length(data) * split_train_set),:);
    test_data = data(floor(length(data) * split_train_set)+1:end,:);
    
    
    % PCA transformation for training set
    X = train_data(:,1:end-1);
    m = mean(X);
%     cv = cov(X -repmat(m,length(X),1));
    cv = (X -repmat(m,length(X),1))' * (X -repmat(m,length(X),1));
    [V,D] = eig(cv);
    [B,I] = sort(diag(D),'descend');
    pcaVectors = V(:,I(1:8));
    %pcaVectors = pca(train_data(:,1:end-1));
    train_data = [train_data(:,1:end-1) * pcaVectors(:,1:3) ...
        train_data(:,end)];
    
     % PCA transformation for test set
    test_data = [test_data(:,1:end-1) * pcaVectors(:,1:3) ...
        test_data(:,end)];
    
    
    % Maximum likelihood method 
    [correct, wrong] = ...
        MaximumLikelihood (train_data, test_data, active_feat);
    ML_accuracy(i) = correct / (correct+wrong);
    
end

ML_mean = mean(ML_accuracy)
ML_SD = std(ML_accuracy)


toc




function [correct, wrong] = MaximumLikelihood (train_data, test_data, active_feat)

    % training
    mean_0 = mean(train_data(train_data(:,end)==0,active_feat))';
    mean_1 = mean(train_data(train_data(:,end)==1,active_feat))';
    covar_0 = cov(train_data(train_data(:,end)==0,active_feat));
    covar_1 = cov(train_data(train_data(:,end)==1,active_feat));
    prior0tmp = length(train_data(train_data(:,end)==0));
    prior1tmp = length(train_data(train_data(:,end)==1));
    prior_0 = prior0tmp./(prior0tmp+prior1tmp);
    prior_1 = prior1tmp./(prior0tmp+prior1tmp);

    % testing
    d = length(active_feat);
    lklhood_0 = exp(-0.5.*(test_data(:,active_feat)'-mean_0)' * inv(covar_0) ...
        * (test_data(:,active_feat)'-mean_0))' ...
        ./ ((2.*pi).^(d/2).*det(covar_0)^0.5); %...
    lklhood_0 = diag(lklhood_0);
    lklhood_1 = exp(-0.5.*(test_data(:,active_feat)'-mean_1)' * inv(covar_1) ...
        * (test_data(:,active_feat)'-mean_1))' ...
        ./ ((2.*pi).^(d/2).*det(covar_1)^0.5); %...
    lklhood_1 = diag(lklhood_1);
    
    post_0 = prod(lklhood_0.*prior_0, 2);
    post_1 = prod(lklhood_1.*prior_1, 2);

    correct = sum((post_0(test_data(:,end) == 0) > post_1(test_data(:,end) == 0)));
    wrong = sum(~(post_0(test_data(:,end) == 0) > post_1(test_data(:,end) == 0)));

    correct = correct + ...
        sum((post_1(test_data(:,end) == 1) >= post_0(test_data(:,end) == 1)));
    wrong = wrong + ...
        sum(~(post_1(test_data(:,end) == 1) >= post_0(test_data(:,end) == 1)));

end
