function Leaveone_test(varargin)
% EXERCISE4   Part 4 of the VGG CNN practical

setup ;

% -------------------------------------------------------------------------
% Part 4.1: prepare the data
% -------------------------------------------------------------------------

% Load character dataset
imdb = load('data/chars-experiment/netcnn_imdb/imdb.mat') ;
imdata = load('Opfl_imrotate_15_imdb.mat') ;
len = length(imdata.image_all);
relen = len/180;

imdb.images.id = [];
imdb.images.id = 1:len;

lab = imdb.images.label(1:180);
imdb.images.label = [];
imdb.images.label = repmat(lab,1,relen);


imdb.images.set = [];
imdb.images.set(1:540) = 1;
imdb.images.set(541:1260) = 2;

imdb.images.data = [];
imdb.images.data = imdata.image_all;

save('data/chars-experiment/opfl_imrotate_15_leave_imdb.mat', '-struct', 'imdb') ;

% -------------------------------------------------------------------------
% Part 4.2: initialize a CNN architecture
% -------------------------------------------------------------------------

net = initializeCharacterCNN() ;
%產生8層CNN___cov_pool_cov_pool_cov_relu_cov26_softmaxloss

% -------------------------------------------------------------------------
% Part 4.3: train and evaluate the CNN
% -------------------------------------------------------------------------

trainOpts.batchSize = 100 ; %一次抓100筆data
trainOpts.numEpochs = 40 ; %data\chars-experiment的net-epoch檔案數目 檔案已存在則不需再訓練過
trainOpts.continue = true ;
trainOpts.useGpu = false ;
trainOpts.learningRate = 0.001 ;
trainOpts.expDir = 'data/chars-experiment' ;
trainOpts = vl_argparse(trainOpts, varargin);

%%%%%
imageMean = mean(imdb.images.data(:)) ;
imdb.images.data = imdb.images.data - imageMean ;

% Convert to a GPU array if needed
if trainOpts.useGpu
  imdb.images.data = gpuArray(imdb.images.data) ;
end

% Call training function in MatConvNet
[net,info] = cnn_train(net, imdb, @getBatch, trainOpts) ;
%                                (imdb,batch)

% Move the CNN back to the CPU if it was trained on the GPU
if trainOpts.useGpu
  net = vl_simplenn_move(net, 'cpu') ;
end

% Save the result for later use
net.layers(end) = [] ;      %softmaxloss去除
net.imageMean = imageMean ; %imageMean保存之後還要用

% save('data/chars-experiment/ran3.mat', 'ran') ;
save('data/chars-experiment/opfl_imrotate_15_leave_imdb_netcnn.mat', '-struct', 'net') ;

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
% im = imdb.images.data(:,:,batch) ;%每次抓100筆data的id%%%%%%%%%%%%%%%%%%%
im = imdb.images.data(:,:,:,batch) ;
% im = 256 * reshape(im, 32, 32, 3, []) ;%改3 ...%%%%%%%%%%%%%%%%%%%%%%%%%%
im = 256 * reshape(im, 32, 32, 20, []) ;
labels = imdb.images.label(1,batch) ;