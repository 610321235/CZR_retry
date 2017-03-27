clc;clear;

light = ['Set1';'Set2';'Set3';'Set4';'Set5';'Set6';'Set7';'Set8';'Set9';'SetA';'SetB';'SetC';];%10
% light = ['Set1';'Set2';'Set3';'Set4';'Set5';];%10
act = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008'];%9
user = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008';'0009';
        '0010';'0011';'0012';'0013';'0014';'0015';'0016';'0017';'0018';'0019'];%20
norm = 20;
inputpath = 'D:\icvl\All_gray_norm\Train\';
outputpath = 'D:\icvl\OpticFlow_inv\';

% �Ыإ��y��H��������ƹ�H
opticalFlow = vision.OpticalFlow('ReferenceFrameDelay', 1);
converter = vision.ImageDataTypeConverter;

% �ק���y��H���t�m
opticalFlow.OutputValue = 'Horizontal and vertical components in complex form'; % ��^�ƼƧΦ����y��
opticalFlow.ReferenceFrameSource = 'Input port'; % ����i�Ϥ��A�Ӥ��O���W�y

if 1 % �ϥΪ���k
    opticalFlow.Method = 'Lucas-Kanade';
    opticalFlow.NoiseReductionThreshold = 0.001; % �q�{�O0.0039
else
    opticalFlow.Method = 'Horn-Schunck';
    opticalFlow.Smoothness = 0.5; % �q�{�O1
end

for con_light=1:12
    mkdir(outputpath,light(con_light,:));%���͸�Ƨ�
    for con_act=1:9
        mkdir([outputpath light(con_light,:)],act(con_act,:));%���͸�Ƨ�
        for con_user=1:20
            input_dir = dir(fullfile(['D:\icvl\All_gray_norm\Train\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\'],'*.jpg'));
            [x, y] = size(input_dir);
            mkdir([outputpath light(con_light,:) '\' act(con_act,:)],user(con_user,:));%���͸�Ƨ�
            
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
                
                % �եΥ��y��H�p���i�Ϥ������y
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