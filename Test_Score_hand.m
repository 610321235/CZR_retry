clc;clear;
setup;
rng(11);

image_true = [];
image_what = [];
All_score = [];

imdb = load('data/chars-experiment/netcnn_imdb/All_gray_brhe_br09_imrotate_imdilate_imdb.mat') ;
net = load('data/chars-experiment/netcnn_imdb/All_gray_brhe_br09_imrotate_imdilate_netcnn.mat') ;

w = 1;
len = length(imdb.images.id);
tranum = 3060;

for n = len-720+1:len
    image = imdb.images.data(:,:,n);
%     im = im2single(image);
    im = image;
	im = 256 * (im - net.imageMean);
	% Apply the CNN to the larger image
	res = vl_simplenn(net, im) ;

    getres = squeeze(res(end).x(1,1,:));
    getres_min = min(getres);
    getres = getres + abs(getres_min)*2;
    sum_g = sum(getres);
    getres_norm = getres/sum_g;
    hand_score(:,n) = getres_norm(:);

    [score,pred] = sort((getres_norm),'descend');

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

image_label = imdb.images.label(1:n);
image_true = image_true(1,tranum+1:len);
image_label = image_label(1,tranum+1:len);
image_what = image_what(1,tranum+1:len);

sum = sum(image_true,2);
pers = sum/720;

[C_360,order] = confusionmat(image_label',image_what);
line = repmat(image_true,10,1);

hand_score(:,1:720) = hand_score(:,tranum+1:len);
hand_score(:,721:len) = [];