clear
close all
clc

rng(1000);
tic

D1 = {[-2 1], [-5 -4], [-3 1], [0 -3], [-8 -1]};
D2 = {[2 5], [1 0], [5 -1], [-1 -3], [6 1]};

n1 = length(D1);
n2 = length(D2);

X1 = zeros(n1,2);
X2 = zeros(n2,2);

for i = 1:n1
    X1(i,:) = D1{i};
end

for i = 1:n2
    X2(i,:) = D2{i};
end

fprintf('Class 1 means is: ')
mu1 = mean(X1)
fprintf('Class 2 means is: ')
mu2 = mean(X2)

S1 = (n1-1) * cov(X1);
S2 = (n2-1) * cov(X2);

fprintf('\n\nWithin-class scatter is: ')
Sw = S1 + S2

fprintf('\n\nBetween-class scatter is: ')
mu = mean([X1;X2]);
SB = n1 * (mu1 - mu)' * (mu1 - mu) + n2 * (mu2 - mu)' * (mu2 - mu)


fprintf('\n\nThe optimal line direction is: ')
V = Sw \ (mu1 - mu2)'

if sum(X1*V) < 0
    fprintf('\n\nThe first set class discriminats should be negative: ')
    X1*V
    fprintf('\n\nThe second set class discriminats should be positive: ')
    X2*V
else
    fprintf('\n\nThe first set class discriminats should be positive: ')
    X1*V
    fprintf('\n\nThe second set class discriminats should be negative: ')
    X2*V
end


% This part is just for illustration and was not asked in problem statement
V = V / norm(V) * 10;

plot([-10 10], [-V(1)/V(2)*(-10) -V(1)/V(2)*(10)], 'k')
plot([-V(1)+mu(1) V(1)+mu(1)], [-V(2)+mu(2) V(2)+mu(2)], 'k')

hold on
plot(X1(:,1), X1(:,2),'ro')
plot(X2(:,1), X2(:,2),'bo')

for i = 1:length(X1)
    plot([X1(i,1) (X1(i,:)-mu(1))*V/norm(V)^2*V(1)+mu(1)], ...
        [X1(i,2) (X1(i,:)-mu(2))*V/norm(V)^2*V(2)+mu(2)], 'r--')
end

for i = 1:length(X2)
    plot([X2(i,1) (X2(i,:)-mu(1))*V/norm(V)^2*V(1)+mu(1)], ...
        [X2(i,2) (X2(i,:)-mu(2))*V/norm(V)^2*V(2)+mu(2)], 'b--')
end

c1 = mean(X1*V);
c2 = mean(X2*V);
plot(c1/norm(V)^2*V(1)+mu(1), c1/norm(V)^2*V(2)+mu(2), ...
    'r.','MarkerSize',25)
plot(c2/norm(V)^2*V(1)+mu(1), c2/norm(V)^2*V(2)+mu(2), ...
    'b.', 'MarkerSize',20)


toc

