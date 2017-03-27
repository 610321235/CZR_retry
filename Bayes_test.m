%ийдє
clear;clc;

image_true = [];
image_what = [];

% imdb_histeq = load('data/chars-experiment/netcnn_imdb/All_gray_histeqran3_imdb.mat') ;
% imdb_opfl = load('data/chars-experiment/netcnn_imdb/All_gray_opflran3_imdb.mat') ;
load('data/chars-experiment/netcnn_imdb/Train_label_1.mat');
load('data/chars-experiment/netcnn_imdb/Test_label_1.mat');
load('data/chars-experiment/netcnn_imdb/ran5.mat');
Train_score_histeq = load('data/chars-experiment/netcnn_imdb/Train_Score_histeqnoran1.mat') ;
Train_score_opfl = load('data/chars-experiment/netcnn_imdb/Train_Score_opflnoran1.mat') ;
Test_score_histeq = load('data/chars-experiment/netcnn_imdb/Test_Score_histeqnoran1.mat') ;
Test_score_opfl = load('data/chars-experiment/netcnn_imdb/Test_Score_opflnoran1.mat') ;

Train_score = cat(1,Train_score_histeq.All_score,Train_score_opfl.All_score);
Test_score = cat(1,Test_score_histeq.All_score,Test_score_opfl.All_score);

for i = 1:9  % 9
    mask = (Train_label == i);
    data = Train_score(:,mask);
    mu(i,:) = mean(data');
    Sigma(:,:,i) = cov(data');
    prob(:,i) = mvnpdf(Test_score', mu(i,:), Sigma(:,:,i));
end

% for i = 1:9  % 9
%     mask = (imdb_histeq.test.label == i);
%     data = All_score(:,mask);
%     mu(i,:) = mean(data');
%     Sigma(:,:,i) = cov(data');
%     prob(:,i) = mvnpdf(All_score', mu(i,:), Sigma(:,:,i));
% end

for n = 1:360
    [score,pred] = sort((prob(n,:)),'descend');
    
    if pred(1) == Test_label(n);
        image_true(1,n) = 1;
        image_what(1,n) = pred(1);
    else
        image_true(1,n) = 0;
        image_what(1,n) = pred(1);
    end
end

image_label = Test_label;
sum = sum(image_true,2);
[C_360,order] = confusionmat(image_label',image_what);

