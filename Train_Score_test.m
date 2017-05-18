% Part 4.5: apply the model
% -------------------------------------------------------------------------
clc;clear;
setup;
rng(11);
% % Load the CNN learned before
image_true = [];
image_what = [];
All_score = [];

imdb = load('data/chars-experiment/netcnn_imdb/opfl_20_imdb.mat') ;
net = load('data/chars-experiment/netcnn_imdb/opfl_20_netcnn.mat') ;

load('hand_score_910_2.mat');

w = 1;
len = length(imdb.images.id);
tranum = 180;

for n = tranum+1:len
    image = imdb.images.data(:,:,:,n);
%     im = im2single(image);
    im = image;
	im = 256 * (im - net.imageMean);
	% Apply the CNN to the larger image
	res = vl_simplenn(net, im) ;

    getres = squeeze(res(end).x(1,1,:));
    getres_min = min(getres);
    getres = getres + abs(getres_min);
    sum_g = sum(getres);
    getres_norm = getres/sum_g;
    plus_score = [];
    h = 0;
    plus_score(1:3,1) =  getres_norm(1:3) * (hand_score(1,n-tranum)+h);
    plus_score(4:6,1) =  getres_norm(4:6) * (hand_score(2,n-tranum)+h);
    plus_score(7:9,1) =  getres_norm(7:9) * (hand_score(3,n-tranum)+h);

    [score,pred] = sort((plus_score),'descend');

%     weight_g = 1;
%     weight_m = 1;
    
%     switch test_hand_label(n)
%         case {1}
%             getres(1:3) = getres(1:3)*weight_g;
%             getres(4:9) = getres(4:9)*weight_m;
%         case {2}
%             getres(4:6) = getres(4:6)*weight_g;
%             getres(1:3) = getres(1:3)*weight_m;
%             getres(7:9) = getres(7:9)*weight_m;
%         case {3}
%             getres(7:9) = getres(7:9)*weight_g;
%             getres(1:6) = getres(1:6)*weight_m;
%     end

%     switch test_hand_label(n)
%         case {1}
%             getres(4:9) = 0;
%         case {2}
%             getres(1:3) = 0;
%             getres(7:9) = 0;
%         case {3}
%             getres(1:6) = 0;
%     end

	fprintf('%s: %s\n', mfilename, imdb.meta.classes(pred(1))) ;
	if str2num(imdb.meta.classes(pred(1))) == imdb.images.label(n);
        image_true(1,n) = 1;
        image_what(1,n) = str2num(imdb.meta.classes(pred(1)));
    else
        image_true(1,n) = 0;
        image_what(1,n) = str2num(imdb.meta.classes(pred(1)));
        image_wrong(1,w) = imdb.images.id(n);
        image_wrong(2,w) = imdb.images.label(n);
        image_wrong(3,w) = str2num(imdb.meta.classes(pred(1)));
        w = w+1;
    end
    All_score(:,n) = res(end).x(:,:,:);
end

% save('data/chars-experiment/Score_opfl_20.mat', 'All_score') ;

image_label = imdb.images.label(1:n);
image_true = image_true(1,tranum+1:len);
image_label = image_label(1,tranum+1:len);
image_what = image_what(1,tranum+1:len);

sum = sum(image_true,2);
pers = sum/720;

[C_360,order] = confusionmat(image_label',image_what);
line = repmat(image_true,10,1);
