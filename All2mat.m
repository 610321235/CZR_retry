clc;clear;

light = ['Set1';'Set2';'Set3';'Set4';'Set5'];
act = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008'];%9
user = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008';'0009';
        '0010';'0011';'0012';'0013';'0014';'0015';'0016';'0017';'0018';'0019'];%20

image_all = [];
inputpath = 'D:\icvl\All_gray_60_32_32\';

for con_light=1:5
    for con_act=1:9
        for con_user=1:20
            files=dir(fullfile([inputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\'],'*.jpg'));
            image = [];
            for n=1:numel(files)
                image(:,:,n)=imread([inputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' files(n).name]);
            end
%             image_all = cat(4,image_all,image);
            image = single(image)/256;
            image_all{(con_light-1)*180 + (con_act-1)*20 + con_user} = image;
        end
    end
end

% image_all = single(image_all)/256;
save('imdb_norm60.mat','image_all');
