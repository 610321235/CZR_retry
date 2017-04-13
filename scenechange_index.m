clc;clear;

%�p����y�ܤƶq
load('imdb_nosc.mat');
% input
for i = 1:900
    image = image_all{i};
    for j = 1:length(image_all{i})
        im = image(:,:,j);
        opticFlow = opticalFlowHS;
        flow = estimateFlow(opticFlow,im);
        variation = sum(sum(abs(flow.Vx))) + sum(sum(abs(flow.Vy)));    %���yxy��V�`�X
%         of_variation{i,j}=variation;
        of_variation(i,j) = variation;
    end
end

%���X�ƧǫeN�����ޭ�
N = 20;
for i = 1:900
    im_var = of_variation(i,:);
    im_var(find(im_var == 0)) = [];
    [var,index] = sort(im_var,'descend');
    of_var_topN(i,:) = index(1,1:N);
end