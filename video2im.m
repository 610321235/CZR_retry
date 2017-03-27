clc;clear;

light = ['SetD'];%5
% light = ['Set6'];%5
act = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008'];%9
% act = ['0006';'0007'];%9
user = ['0000';'0001';'0002';'0003';'0004';'0005';'0006';'0007';'0008';'0009';
        '0010';'0011';'0012';'0013';'0014';'0015';'0016';'0017';'0018';'0019'];%20
fn0 = 'frame-000';
fn1 = 'frame-00';
fn2 = 'frame-0';
outputpath = 'D:\icvl\NewSetDIM\';

for con_light=1:1
   
    for con_act=1:9
           
%         for con_user=1:20
            
%             %output_dir_O = dir(fullfile('D:\Program Files\MATLAB\R2013a\bin','faces','*_O.jpg'));
            input_dir = dir(fullfile(['D:\icvl\NewSetD\' light(con_light,:) '\' act(con_act,:) '\'],'*.mp4'));
            [x, y] = size(input_dir);
            inputdir = ['D:\icvl\NewSetD\' light(con_light,:) '\' act(con_act,:) '\'] ;
            
            for n = 1 : x

                obj = VideoReader(fullfile(inputdir, input_dir(n).name));
            %     obj = VideoReader('newdatabase\user160.mp4');
                objn = obj.NumberOfFrames;
                objw = obj.Width;
                objh = obj.Height;

                mov(1:objn) = struct('cdata',zeros(objh,objw,3,'uint8'),'colormap',[]);
            %     a = size(input_dir(n).name);
            %     d = a(2)-4;
            %     f = input_dir(n).name(1:d);
            %     f = 'user160';
                for fra=1:objn
                    mov(fra).cdata = read(obj,fra);
                    output = mov(fra).cdata;

                    tempStr = strcat(num2str(fra),'.jpg');

                    imwrite(output,tempStr);
                    fnamenum = numel(num2str(fra));
                    if fnamenum == 1
                        copyfile(tempStr,[fn0 tempStr]);
                        movefile([fn0 num2str(fra) '.jpg'], ['D:\icvl\NewSetDIM\' light(con_light,:) '\' act(con_act,:) '\' user(n,:)]);
                        delete(tempStr);
                    end
                    if fnamenum == 2
                        copyfile(tempStr,[fn1 tempStr]);
                        movefile([fn1 num2str(fra) '.jpg'], ['D:\icvl\NewSetDIM\' light(con_light,:) '\' act(con_act,:) '\' user(n,:)]);
                        delete(tempStr);
                    end
                    if fnamenum == 3
                        copyfile(tempStr,[fn2 tempStr]);
                        movefile([fn2 num2str(fra) '.jpg'], ['D:\icvl\NewSetDIM\' light(con_light,:) '\' act(con_act,:) '\' user(n,:)]);
                        delete(tempStr);
                    end
%                     movefile([num2str(fra) '.jpg'], ['D:\icvl\NewDataIm_SetBC\' light(con_light,:) '\' act(con_act,:) '\' user(n,:)]);
                    %D:\icvl\NewDataIm_Set6_10\Set6\0000\0000
                end
            end
            %D:\icvl\NewDataVideo_Set6_10\Set6\0000
    end
end