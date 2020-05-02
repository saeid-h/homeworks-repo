clear
close all
clc

tic

data = dlmread('pima-indians-diabetes.data.txt');
data = reshape(data,[],9);
active_feat = 2:4;

accuracy = zeros(1,10);
for i = 1:10
    rp = randperm(length(data));
    data=data(rp,:);
    train_data = sparse(data(:, active_feat));
    train_label = data(:,end);
    model = train(train_label, train_data,'-c 1 -v 5 -q');
    accuracy(i) = model;
end

fprintf('\n\nThe mean accuracy is %4.2f%%:\n\n\n', mean(accuracy))

toc