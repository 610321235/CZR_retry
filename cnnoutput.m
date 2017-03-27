clc;clear;

imdb = load('data\chars-experiment\netcnn_imdb\CpnSet_fix05_plusSet1_imdb.mat');      %database
net = load('data\chars-experiment\netcnn_imdb\CpnSet_fix05_plusSet1_netcnn.mat');%CNN�V�m����model

num = 1080; %�`��Ƶ���

%% �Ĥ@�hconv ��X &pool
for i = 1:num
    im = imdb.images.data(:,:,:,i);  %Ū��  20�i���@��conv
    f = net.layers{1,1}.filters;     %��filter ���|
    b = net.layers{1,1}.biases;      %��biases ���|
    c = vl_nnconv(im,f,b);           %���n
    cnn_layer_1_output.data{i} = c;  %�N�Ĥ@�h���n�����G�x�s
    cnn_layer_1_output.label = imdb.images.label(1:1080);
    cnn_layer_1_pool{i} = vl_nnpool(c, [2 2], 'pad', 0, 'stride', 2, 'method', 'max') ; %pooling �U�����conv��X��
end

%% �ĤT�hconv ��X &pool
for i = 1:num
    temp = cnn_layer_1_pool{i};      %Ū���Ĥ@�hconv-pool��X���G 
    f = net.layers{1,3}.filters;     %��filter ���|
    b = net.layers{1,3}.biases;      %��biases ���|
    c = vl_nnconv(temp,f,b);         %���n
    cnn_layer_3_output.data{i} = c;  %�N�ĤT�h���n�����G�x�s
    cnn_layer_3_output.label = imdb.images.label(1:1080);
    cnn_layer_3_pool{i} = vl_nnpool(c, [2 2], 'pad', 0, 'stride', 2, 'method', 'max') ; %pooling �U�����conv��X��
end

%% �Ĥ��hconv
for i = 1:num
    temp = cnn_layer_3_pool{i};      %Ū���Ĥ@�hconv-pool��X���G 
    f = net.layers{1,5}.filters;     %��layer5-filter ���|
    b = net.layers{1,5}.biases;      %��layer5-biases ���|
    c = vl_nnconv(temp,f,b);         %���n
    cnn_layer_5_output.data{i} = c;  %�N�Ĥ��h���n�����G�x�s
    cnn_layer_5_output.label = imdb.images.label(1:1080);
end
% 
% cnn_layer_1_output.label = imdb.images.label; 
% 
% for i = 1:9   %����(N=1:9)���ǳ� ��Xlabel=N����m
%     class{i} = find(imdb.images.label == i);
% end
% 
% %% classification 
% for i = 1:length(class)
%     for j = 1:length(class{1,i})
%     cnn_layer_1_output_class{i,j} = cnn_layer_1_output.data{class{1,i}(j)};
%     end
% end
% 
% for i = 1:length(class)
%     for j = 1:length(class{1,i})
%     cnn_layer_3_output_class{i,j} = cnn_layer_3_output.data{class{1,i}(j)};
%     end
% end
% 
% for i = 1:length(class)
%     for j = 1:length(class{1,i})
%     cnn_layer_5_output_class{i,j} = cnn_layer_5_output.data{class{1,i}(j)};
%     end
% end