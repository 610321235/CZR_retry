clc;clear;

imdb = load('data\chars-experiment\netcnn_imdb\CpnSet_fix05_plusSet1_imdb.mat');      %database
net = load('data\chars-experiment\netcnn_imdb\CpnSet_fix05_plusSet1_netcnn.mat');%CNN訓練完的model

num = 1080; %總資料筆數

%% 第一層conv 輸出 &pool
for i = 1:num
    im = imdb.images.data(:,:,:,i);  %讀圖  20張做一次conv
    f = net.layers{1,1}.filters;     %取filter 堆疊
    b = net.layers{1,1}.biases;      %取biases 堆疊
    c = vl_nnconv(im,f,b);           %卷積
    cnn_layer_1_output.data{i} = c;  %將第一層卷積的結果儲存
    cnn_layer_1_output.label = imdb.images.label(1:1080);
    cnn_layer_1_pool{i} = vl_nnpool(c, [2 2], 'pad', 0, 'stride', 2, 'method', 'max') ; %pooling 下次抽取conv輸出用
end

%% 第三層conv 輸出 &pool
for i = 1:num
    temp = cnn_layer_1_pool{i};      %讀取第一層conv-pool輸出結果 
    f = net.layers{1,3}.filters;     %取filter 堆疊
    b = net.layers{1,3}.biases;      %取biases 堆疊
    c = vl_nnconv(temp,f,b);         %卷積
    cnn_layer_3_output.data{i} = c;  %將第三層卷積的結果儲存
    cnn_layer_3_output.label = imdb.images.label(1:1080);
    cnn_layer_3_pool{i} = vl_nnpool(c, [2 2], 'pad', 0, 'stride', 2, 'method', 'max') ; %pooling 下次抽取conv輸出用
end

%% 第五層conv
for i = 1:num
    temp = cnn_layer_3_pool{i};      %讀取第一層conv-pool輸出結果 
    f = net.layers{1,5}.filters;     %取layer5-filter 堆疊
    b = net.layers{1,5}.biases;      %取layer5-biases 堆疊
    c = vl_nnconv(temp,f,b);         %卷積
    cnn_layer_5_output.data{i} = c;  %將第五層卷積的結果儲存
    cnn_layer_5_output.label = imdb.images.label(1:1080);
end
% 
% cnn_layer_1_output.label = imdb.images.label; 
% 
% for i = 1:9   %分組(N=1:9)做準備 找出label=N的位置
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