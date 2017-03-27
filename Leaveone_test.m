function Leaveone_test(varargin)
% EXERCISE4   Part 4 of the VGG CNN practical

setup ;

% -------------------------------------------------------------------------
% Part 4.1: prepare the data
% -------------------------------------------------------------------------

% Load character dataset
imdb = load('data/chars-experiment/netcnn_imdb/imdb.mat') ;
% imdb = load('data/chars-experiment/netcnn_imdb/CpnSet_fix05_plusSet1_imdb.mat') ;
% MaskSet = load('MaskSet_All_imdb.mat') ;
% CpnSet = load('CpnSet_fix05_plusSet1_imdb.mat') ;

imdb.images.set = [];
imdb.images.set(1:180) = 1;
imdb.images.set(181:900) = 2;

% imdb.images.data = [];
% imdb.images.data = image_all;

save('data/chars-experiment/imdb.mat', '-struct', 'imdb') ;

% -------------------------------------------------------------------------
% Part 4.2: initialize a CNN architecture
% -------------------------------------------------------------------------

net = initializeCharacterCNN() ;
%����8�hCNN___cov_pool_cov_pool_cov_relu_cov26_softmaxloss

% -------------------------------------------------------------------------
% Part 4.3: train and evaluate the CNN
% -------------------------------------------------------------------------

trainOpts.batchSize = 100 ; %�@����100��data
trainOpts.numEpochs = 40 ; %data\chars-experiment��net-epoch�ɮ׼ƥ� �ɮפw�s�b�h���ݦA�V�m�L
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
net.layers(end) = [] ;      %softmaxloss�h��
net.imageMean = imageMean ; %imageMean�O�s�����٭n��

% save('data/chars-experiment/ran3.mat', 'ran') ;
save('data/chars-experiment/imdb_netcnn.mat', '-struct', 'net') ;

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
% im = imdb.images.data(:,:,batch) ;%�C����100��data��id%%%%%%%%%%%%%%%%%%%
im = imdb.images.data(:,:,:,batch) ;
% im = 256 * reshape(im, 32, 32, 3, []) ;%��3 ...%%%%%%%%%%%%%%%%%%%%%%%%%%
im = 256 * reshape(im, 32, 32, 20, []) ;
labels = imdb.images.label(1,batch) ;