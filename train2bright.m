clc;clear;
light = ['Set1';'Set2';'Set3';'Set4';'Set5';'Set6';'Set7';'Set8';'Set9';];
% light = ['Set1'];
act = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008'];%9
user = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008';'0009';
        '0010';'0011';'0012';'0013';'0014';'0015';'0016';'0017';'0018';'0019'];%20
norm = 20;
image_plus = [];
inputpath = 'D:\icvl\All_gray_bright8\';
outputpath = 'D:\icvl\All_gray_bright8_imrotate_inv\';

% bright = load('bright2.mat');
% bright = bright.im;
% bright = imrotate(bright,15);
% bright = imrotate(bright,90);
% bright = imrotate(bright,90);
for con_light=1:9
    mkdir(outputpath,light(con_light,:));%產生資料夾
    for con_act=1:9
        mkdir([outputpath light(con_light,:)],act(con_act,:));%產生資料夾
        for con_user=1:20
            input_dir = dir(fullfile([inputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\'],'*.jpg'));
            [x, y] = size(input_dir);
            mkdir([outputpath light(con_light,:) '\' act(con_act,:)],user(con_user,:));%產生資料夾
            
            n = numel(input_dir);
            for i = 1:n
                fname = input_dir(i).name;
                obj=[inputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname];
                obj = imread(obj);
                output = obj;
                output = imrotate(output,-15);
                output = imresize(output,[32 32]);
%                 m = mean(mean(obj));
                imwrite(output,[outputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname]);
            end
        end
    end
end