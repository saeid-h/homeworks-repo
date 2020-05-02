% rng(1000);
tic

data = dlmread('pima-indians-diabetes.data.txt');
data = reshape(data,[],9);

% parameters
split_train_set = 0.5;


% pick a feature
active_feat = 2:4;

K = [1 5 11];
ML_accuracy = zeros(1,10);
NB_accuracy = zeros(1,10);
KNN_accuracy = zeros(length(K),10);
CPW_accuracy = zeros(1,10);

for i = 1:10
    
    % Random selection - Problem 1, Part 1
    rp = randperm(length(data));
    data=data(rp,:);
    train_data = data(1:floor(length(data) * split_train_set),:);
    test_data = data(floor(length(data) * split_train_set)+1:end,:);

    [coef,~,latent] = pca(data');
    
    % Maximum likelihood method - Problem 1, Part 2
    [correct, wrong] = ...
        MaximumLikelihood (train_data, test_data, active_feat);
    ML_accuracy(i) = correct / (correct+wrong);
    
    % Naive Bayes method - Problem 2
    [correct, wrong] = ...
        NaiveBayes (train_data, test_data, active_feat);
    NB_accuracy(i) = correct / (correct+wrong);
    
    % KNN method - Problem 3
    c = 1;
    for k = K
        [correct, wrong] = KNN (train_data, test_data, active_feat, k);
        KNN_accuracy(c,i) = correct / (correct+wrong);
        c = c + 1;
    end
    
    % Cube Parzen Window method - Problem 4
    [correct, wrong] = ...
        CubeParzenWindow (train_data, test_data, active_feat, 20);
    CPW_accuracy(i) = correct / (correct+wrong);
    
end

ML_mean = mean(ML_accuracy)
ML_SD = std(ML_accuracy)

NB_mean = mean(NB_accuracy)
NB_SD = std(NB_accuracy)

KNN_mean = mean(KNN_accuracy,2)
KNN_SD = std(KNN_accuracy,0,2)

CPW_mean = mean(CPW_accuracy,2)
CPW_SD = std(CPW_accuracy,0,2)


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






function [correct, wrong] = NaiveBayes (train_data, test_data, active_feat)

    % training
    prior0tmp = length(train_data(train_data(:,end)==0));
    prior1tmp = length(train_data(train_data(:,end)==1));
    prior_0 = prior0tmp./(prior0tmp+prior1tmp);
    prior_1 = prior1tmp./(prior0tmp+prior1tmp);
    
    
    % testing
    post_0 = prior_0 .* ones(size(test_data,1),1);
    post_1 = prior_1 .* ones(size(test_data,1),1);
    for i = active_feat
        for j = 1:size(test_data,1)
            post_0(j) = post_0(j) .* ...
                sum(and(train_data(:,i) == test_data(j,i), ...
                (train_data(:,end) == 0))) ...
                ./ prior0tmp;
            
            post_1(j) = post_1(j) .* ...
                sum(and(train_data(:,i) == test_data(j,i), ...
                (train_data(:,end) == 1))) ...
                ./ prior1tmp;
        end
    end
    
    correct = sum((post_0(test_data(:,end) == 0) > post_1(test_data(:,end) == 0)));
    wrong = sum(~(post_0(test_data(:,end) == 0) > post_1(test_data(:,end) == 0)));

    correct = correct + ...
        sum((post_1(test_data(:,end) == 1) >= post_0(test_data(:,end) == 1)));
    wrong = wrong + ...
        sum(~(post_1(test_data(:,end) == 1) >= post_0(test_data(:,end) == 1)));

end





function [correct, wrong] = KNN (train_data, test_data, active_feat, k)

    % training
    Mdl = KDTreeSearcher(train_data(:,active_feat));
    
    
    % testing
    IdxKDT = knnsearch(Mdl,test_data(:,active_feat),'K',k,'IncludeTies',true);
    
    correct = 0;
    wrong = 0;
    
    for i = 1:numel(IdxKDT)
        if (sum(train_data([IdxKDT{i}],end)) / k > 0.5)
            if test_data(i,end) == 1
                correct = correct + 1;
            else 
                wrong = wrong + 1;
            end
        else
            if test_data(i,end) == 0
                correct = correct + 1;
            else 
                wrong = wrong + 1;
            end
        end
    end
    
end




function [correct, wrong] = ...
    CubeParzenWindow (train_data, test_data, active_feat, range)

    
    neighbours = rangesearch(train_data(:,active_feat), ...
        test_data(:,active_feat), range/2);
    
    correct = 0;
    wrong = 0;
    
    for i = 1:numel(neighbours)
        n = length(neighbours{i});
        if n ~= 0
            p = sum(train_data(neighbours{i},end)) / n;
        else
            p = 0;
        end
        
        if p > 0.5
            if test_data(i,end) == 1
                correct = correct + 1;
            else 
                wrong = wrong + 1;
            end
        else
            if test_data(i,end) == 0
                correct = correct + 1;
            else 
                wrong = wrong + 1;
            end
        end
    end

end



