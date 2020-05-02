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
FLD_accuracy = zeros(1,10);


% pick the new features
active_feat = 1:8;

% Maximum likelihood method 
for i = 1:10
    
    % Random selection 
    rp = randperm(length(data));
    data=data(rp,:);
      
    train_data = data(1:floor(length(data) * split_train_set),:);
    test_data = data(floor(length(data) * split_train_set)+1:end,:);
    
    
    % Maximum likelihood method 
    [correct, wrong] = ...
        MaximumLikelihood (train_data, test_data, active_feat);
    ML_accuracy(i) = correct / (correct+wrong);
    
    
    % Fisher Linear Discriminant
    [correct, wrong] = ...
        FisherLinearDiscreminant (train_data, test_data, active_feat);
    FLD_accuracy(i) = correct / (correct+wrong);
    
end

ML_mean = mean(ML_accuracy)
ML_SD = std(ML_accuracy)

FLD_mean = mean(FLD_accuracy)
FLD_SD = std(FLD_accuracy)


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









function [correct, wrong] = FisherLinearDiscreminant (train_data, test_data, active_feat)

    % training
    X0 = train_data(train_data(:,end)==0,active_feat);
    X1 = train_data(train_data(:,end)==1,active_feat);
    
    n1 = length(X0);
    n2 = length(X1);

    mu0 = mean(X0);
    mu1 = mean(X1);

    S0 = (n1-1) * cov(X0);
    S1 = (n2-1) * cov(X1);

    Sw = S0 + S1;
    %SB = n1 * cov(mu1) + n2 * cov(mu2);

    V = Sw \ (mu0 - mu1)';
    

    % testing
    
    mean_0 = mean(X0*V);
    mean_1 = mean(X1*V);
    covar_0 = cov(X0*V);
    covar_1 = cov(X1*V);
    
    
    prior0tmp = length(X0);
    prior1tmp = length(X1);

    prior_0 = prior0tmp./(prior0tmp+prior1tmp);
    prior_1 = prior1tmp./(prior0tmp+prior1tmp);
    
    X = test_data(:,active_feat)*V;

    d = length(active_feat);
    lklhood_0 = exp(-0.5.*(X'-mean_0)' * inv(covar_0) ...
        * (X'-mean_0))' ./ ((2.*pi).^(d/2).*det(covar_0)^0.5); %...
    lklhood_0 = diag(lklhood_0);
    lklhood_1 = exp(-0.5.*(X'-mean_1)' * inv(covar_1) ...
        * (X'-mean_1))' ./ ((2.*pi).^(d/2).*det(covar_1)^0.5); %...
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



