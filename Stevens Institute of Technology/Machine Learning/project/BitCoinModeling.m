
clear 
close all
clc

tic

BitCoinData = readtable ('bitcoin_dataset.csv');
% M = csvread('bitcoin_dataset.csv');

X = table2array(BitCoinData(:,3:24));
Y = table2array(BitCoinData(:,2));
R = log(Y);
R(1:175) = [];
XX = X(176:end,:);
RD = diff(R);


%nnstart

S = 5;
RR = RD - lagmatrix(RD,S);
RR(1:S) = [];
autocorr(RD)


% model_1 = arima(1,1,0);
% model_2 = arima(0,1,1);
model_3 = arima(1,1,1);
% model_3.Variance = garch(1,1);
% model_4 = arima(0,1,0);

% EstMdl_1 = estimate (model_1, R);
% EstMdl_2 = estimate (model_2, R);
EstMdl_3 = estimate (model_3, R);
% EstMdl_4 = estimate (model_4, R);

n = 10;
rng default % For reproducibility
[y, e] = simulate(EstMdl_3,n,'NumPaths',500);

figure
subplot(2,1,1);
plot(y)
title('Simulated Response')

subplot(2,1,2);
plot(e)
title('Simulated Innovations')

lower = prctile(y,2.5,2);
middle = median(y,2);
upper = prctile(y,97.5,2);

figure
plot(1:n,lower,'r:',1:n,middle,'k',...
			1:n,upper,'r:')
legend('95% Interval','Median')


toc
