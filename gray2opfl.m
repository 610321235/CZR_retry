clc;clear;

light = ['Set1';'Set2';'Set3';'Set4';'Set5';'Set6';'Set7';'Set8';'Set9';'SetA';'SetB';'SetC';];%10
% light = ['Set1';'Set2';'Set3';'Set4';'Set5';];%10
act = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008'];%9
user = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008';'0009';
        '0010';'0011';'0012';'0013';'0014';'0015';'0016';'0017';'0018';'0019'];%20
norm = 20;
inputpath = 'D:\icvl\All_gray_norm\Train\';
outputpath = 'D:\icvl\OpticFlow_inv\';

% 創建光流對象及類型轉化對象
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1);
converter = vision.ImageDataTypeConverter;

% 修改光流對象的配置
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form'; % 返回複數形式光流圖
opticalFlow.ReferenceFrameSource = 'Input port'; % 對比兩張圖片，而不是視頻流

if 1 % 使用的算法
    opticalFlow.Method = 'Lucas-Kanade';
    opticalFlow.NoiseReductionThreshold = 0.001; % 默認是0.0039
else
    opticalFlow.Method = 'Horn-Schunck';
    opticalFlow.Smoothness = 0.5; % 默認是1
end

for con_light=1:12
    mkdir(outputpath,light(con_light,:));%產生資料夾
    for con_act=1:9
        mkdir([outputpath light(con_light,:)],act(con_act,:));%產生資料夾
        for con_user=1:20
            input_dir = dir(fullfile(['D:\icvl\All_gray_norm\Train\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\'],'*.jpg'));
            [x, y] = size(input_dir);
            mkdir([outputpath light(con_light,:) '\' act(con_act,:)],user(con_user,:));%產生資料夾
            
            n = numel(input_dir);
%             n = n-1;
            w = 1;
            for i = n:-1:2
                fname1 = input_dir(i).name;
                fname2 = input_dir(i-1).name;
                obj1=['D:\icvl\All_gray_norm\Train\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname1];
                obj2=['D:\icvl\All_gray_norm\Train\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname2];
                obj1 = imread(obj1);
                obj2 = imread(obj2);
                
                % 調用光流對象計算兩張圖片的光流
                obj1_c = step(converter, obj1);
                obj2_c = step(converter, obj2);
                of = step(opticalFlow, obj1_c, obj2_c);
                absof = abs(of);
                fname_inv = input_dir(w).name;
                imwrite(absof,[outputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname_inv]);
                if i == 2
                    fname_inv = input_dir(w+1).name;
                    imwrite(absof,[outputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname_inv]);
                end
                w = w+1;
            end
        end
    end
end