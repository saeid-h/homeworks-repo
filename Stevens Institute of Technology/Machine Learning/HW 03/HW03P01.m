
clear
close all
clc

TheRoutineFor(100)
TheRoutineFor(10000)

function TheRoutineFor(n)

    data = randn(3,n);
    m = [1 2 3]';
    data1 = data + repmat(m,1,n);
    data2 = diag([10 3 1]) * data1;
    R = [0.6651 0.7427 0.0775; 0.7395 -0.6696 0.0697; 0.1037 0.0109 -0.9946];
    data3 = R * data2;

    m_data = mean(data')
    cv_data = cov(data'-repmat(m_data,n,1))

    m_data1 = mean(data1')
    cv_data1 = cov(data1'-repmat(m_data1,n,1))

    m_data2 = mean(data2')
    cv_data2 = cov(data2'-repmat(m_data2,n,1))

    m_data3 = mean(data3')
    cv_data3 = cov(data3'-repmat(m_data3,n,1))


    [coef,~,latent] = pca(data');
    [coef1,~,latent1] = pca(data1');
    [coef2,~,latent2] = pca(data2');
    [coef3,~,latent3] = pca(data3');

    figure; hold on
    plot3(data(1,:), data(2,:), data(3,:),'bo')
    plot3(data1(1,:), data1(2,:), data1(3,:),'ro')
    plot3(data2(1,:), data2(2,:), data2(3,:),'go')
    plot3(data3(1,:), data3(2,:), data3(3,:),'ko')

end
