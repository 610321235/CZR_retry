clc;clear;
light = ['Set1';'Set2';'Set3';'Set4';'Set5'];
act = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008'];%9
user = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008';'0009';
        '0010';'0011';'0012';'0013';'0014';'0015';'0016';'0017';'0018';'0019'];%20
N = 20;
w = 1;
pix = -30;
image_plus = [];
inputpath = 'D:\icvl\All_Set_1\';
outputpath = 'D:\icvl\All_Set_1_32_32_imdilate_-30\';

for con_light=1:5
    mkdir(outputpath,light(con_light,:));%產生資料夾
    for con_act=1:9
        mkdir([outputpath light(con_light,:)],act(con_act,:));%產生資料夾
        for con_user=1:20
            input_dir = dir(fullfile([inputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\'],'*.jpg'));
            [x, y] = size(input_dir);
            mkdir([outputpath light(con_light,:) '\' act(con_act,:)],user(con_user,:));%產生資料夾
            
            n = numel(input_dir);
            for i = 1:n
                fname = input_dir(i).name; %im2gray
                obj=[inputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname];
                obj = imread(obj);
                output = obj;
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 平移
                im = rgb2gray(output);
                se = translate(strel(1),[0 pix]);
                im_t = imdilate(im,se);

                if pix > 0
                    im_b1 = im(:,1);
                    im_b2 = im(:,2);
                    im_b1 = mean(im_b1);
                    im_b2 = mean(im_b2);
                    im_b = im_b2 - im_b1;
                    w_pix = 1;
                    for i_pix = pix:-1:1
                        im_t(:,i_pix) = im_b1 - im_b*w*0.5;
                        w_pix = w_pix + 1;
                    end
                else
                    im_b1 = im(:,320);
                    im_b2 = im(:,319);
                    im_b1 = mean(im_b1);
                    im_b2 = mean(im_b2);
                    im_b = im_b2 - im_b1;
                    w = 1;
                    for i_pix = 321+pix:1:320
                        im_t(:,i_pix) = im_b1 - im_b*w*0.5;
                        w = w+1;
                    end
                end

                output = imresize(im_t,[32 32]);
                
                  %%%%%%%%%%%%%%%%%%%%%%%%%%%% 旋轉
%                 output = rgb2gray(output); 
%                 [sx,sy] = size(output);
%                 output = imrotate(output,-10,'crop');
% 
%                 point1 = output(19,49);
%                 point2 = output(34,307);
%                 point3 = output(206,14);
%                 point4 = output(222,272);
% 
%                 for m = 1:sx
%                     for n = 1:sy
%                         if output(m,n)==0 && m<120 && n<160
%                             output(m,n) = point1;
%                         end
%                         if output(m,n)==0 && m>120 && n<160
%                             output(m,n) = point3;
%                         end
%                         if output(m,n)==0 && m<120 && n>160
%                             output(m,n) = point2;
%                         end
%                         if output(m,n)==0 && m>120 && n>160
%                             output(m,n) = point4;
%                         end
%                     end
%                 end
%                 output = imresize(output,[32 32]);
                
                imwrite(output,[outputpath light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname]);
            end
            w = w + 1;
        end
    end
end