clc;clear;

light = ['CpnSet0';'CpnSet1';'CpnSet2';'CpnSet3';'CpnSet4';'CpnSet5'];
act = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008'];%9
user = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008';'0009';
        '0010';'0011';'0012';'0013';'0014';'0015';'0016';'0017';'0018';'0019'];%20

image_all = [];

for con_light=1:6
    for con_act=1:9
        for con_user=1:20
            %output_dir_O = dir(fullfile('D:\Program Files\MATLAB\R2013a\bin','faces','*_O.jpg'));
            files=dir(fullfile(['D:\icvl\CpnSet_fixedMean_0.5\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\'],'*.jpg'));
            %D:\icvl\All_scd\Set1\0000\0000
            for n=1:numel(files)
                image(:,:,n)=imread(['D:\icvl\CpnSet_fixedMean_0.5\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' files(n).name]);
            end
            image_all = cat(4,image_all,image);
            
        end
    end
end

image_all = single(image_all)/256;
save('CpnSet_fix05_plusSet1_imdb.mat','image_all');
