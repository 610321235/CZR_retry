clc;clear;
light = ['Set1';'Set2';'Set3';'Set4';'Set5';];
act = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008'];%9
user = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008';'0009';
        '0010';'0011';'0012';'0013';'0014';'0015';'0016';'0017';'0018';'0019'];%20
norm = 20;
image_plus = [];
inputpath = 'D:\icvl\All_gray_norm\Train\';
outputpath = 'D:\icvl\All_gray_bright\';
load('Set2_bright.mat');
load('Set3_bright.mat');
load('Set4_bright.mat');
load('Set5_bright.mat');

for con_light=1:1
    mkdir(outputpath,light(con_light,:));%產生資料夾
    for con_act=1:1
        mkdir([outputpath light(con_light,:)],act(con_act,:));%產生資料夾
        for con_user=1:1
            input_dir = dir(fullfile([inputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\'],'*.jpg'));
            [x, y] = size(input_dir);
            mkdir([outputpath light(con_light,:) '\' act(con_act,:)],user(con_user,:));%產生資料夾
            
            n = numel(input_dir);
            for i = 1:n
                fname = input_dir(i).name;
                obj=[inputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname];
                obj = imread(obj);
                output = obj;
%                 output = imresize(obj,[24 32]);
%                 output = rgb2gray(obj);
%                 output = histeq(obj);
%                 output = imadjust(obj,[],[],0.5);
                imwrite(output,[outputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname]);
            end
        end
    end
end