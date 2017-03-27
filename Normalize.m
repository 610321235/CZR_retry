clc;clear;

%Set1~Set5
%0000~0008
%0000~0019
% light = ['Set6';'Set7';'Set8';'Set9';'SetA'];
light = ['SetD'];
act = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008'];
user = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008';'0009';
        '0010';'0011';'0012';'0013';'0014';'0015';'0016';'0017';'0018';'0019'];
norm = 20;
fn0 = 'frame-000';
fn1 = 'frame-00';
fn2 = 'frame-0';
%folder = '0012';

for con_light=1:1
    for con_act=1:9
        for con_user=1:20
            
%             %output_dir_O = dir(fullfile('D:\Program Files\MATLAB\R2013a\bin','faces','*_O.jpg'));
            files=dir(fullfile(['D:\icvl\NewSetDIM\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\'],'*.jpg'));

            n = numel(files);
            %統一可排序檔名
%             for n=1:numel(files)
%                 fname = files(n).name;
%                 fnamenum = numel(fname);
% %                 image(:,:,n)=rgb2gray(imread(['D:\icvl\AllandNew\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' files(n).name]));
%                 obj=['D:\icvl\NewDataIm_Set6_10\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname];
% %                 fname=fname(1:10); 
%                 if fnamenum == 5
%                     copyfile(obj,[fn0 fname]);
%                     movefile([fn0 fname], ['D:\icvl\NewDataIm_Set6_10\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:)]);
%                     delete(obj);
%                 end
%                 if fnamenum == 6
%                     copyfile(obj,[fn1 fname]);
%                     movefile([fn1 fname], ['D:\icvl\NewDataIm_Set6_10\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:)]);
%                     delete(obj);
%                 end
%                 if fnamenum == 7
%                     copyfile(obj,[fn2 fname]);
%                     movefile([fn2 fname], ['D:\icvl\NewDataIm_Set6_10\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:)]);
%                     delete(obj);
%                 end
%             end
            
            diff = n - norm;

            if diff == 0
            end
% 
            if diff > 0 
%                 del = fix(n/(diff+1));
                del = n/diff;
                for i = 1:del:n;
                    %刪除影像
                    x = fix(i);
                    fname = files(x).name;
                    obj=['D:\icvl\NewSetDIM\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname];
                    delete(obj);
                end
            end
% 
%             if diff < 0
%                 abs_diff=abs(diff);
%                 del = fix(n/(abs_diff+1));
%                 for i = del:del:del*abs_diff;
%                     %複製影像
%                     fname = files(i).name;
%                     obj=['D:\icvl\All\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname];
%                     fname=fname(1:10); 
%                     copyfile(obj,[fname fn '.jpg']);
%                     movefile([fname fn '.jpg'], ['D:\icvl\All\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:)]);
%                 end
%             end
            
            %縮小尺寸
            files=dir(fullfile(['D:\icvl\NewSetDIM\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\'],'*.jpg'));
            for i = 1:1:norm;
                files=dir(fullfile(['D:\icvl\NewSetDIM\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\'],'*.jpg'));
            	fname = files(i).name;
            	obj=['D:\icvl\NewSetDIM\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:) '\' fname];
            	reimg = imresize(imread(obj),[32 32]);
                imwrite(reimg,fname);
                movefile(fname, ['D:\icvl\NewSetDIM\' light(con_light,:) '\' act(con_act,:) '\' user(con_user,:)])
            end
        end
    end
end