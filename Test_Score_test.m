% Part 4.5: apply the model
% -------------------------------------------------------------------------
clear;
setup;
% % Load the CNN learned before
image_true = [];
image_what = [];
All_score = [];

net = load('data/chars-experiment/netcnn_imdb/opfl_netcnn.mat') ;
imdb = load('data/chars-experiment/netcnn_imdb/opfl_imdb.mat') ;

w = 1;
for n = 1:180
    image = imdb.test.data(:,:,:,n);
%     im = im2single(image);
    im = image;
	im = 256 * (im - net.imageMean);
	% Apply the CNN to the larger image
	res = vl_simplenn(net, im) ;

    for i = 1:size(res(end).x,2)
        [score,pred] = sort(squeeze(res(end).x(1,i,:)),'descend');
    end
	fprintf('%s: %s\n', mfilename, imdb.meta.classes(pred(1))) ;
	if str2num(imdb.meta.classes(pred(1))) == imdb.test.label(n);
        image_true(1,n) = 1;
        image_what(1,n) = str2num(imdb.meta.classes(pred(1)));
    else
        image_true(1,n) = 0;
        image_what(1,n) = str2num(imdb.meta.classes(pred(1)));
        image_wrong(1,w) = imdb.test.id(n);
        image_wrong(2,w) = imdb.test.label(n);
        image_wrong(3,w) = str2num(imdb.meta.classes(pred(1)));
        w = w+1;
    end
    All_score(:,n) = res(end).x(:,:,:);
end

save('data/chars-experiment/Test_Score_opfl.mat', 'All_score') ;


image_label = imdb.test.label(1:n);

sum = sum(image_true,2);
[C_360,order] = confusionmat(image_label',image_what);