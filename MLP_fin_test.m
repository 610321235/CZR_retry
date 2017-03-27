clc;clear;

% for count = 1:10

%Ū���V�m�ƾ� %Ū�����ռƾ�
train_score_histeq = load('data/chars-experiment/netcnn_imdb/Train_Score_histeq_leaveone1.mat') ;
train_score_opfl = load('data/chars-experiment/netcnn_imdb/Train_Score_opfl_leaveone1.mat') ;
test_score_histeq = load('data/chars-experiment/netcnn_imdb/Test_Score_histeq_leaveone1.mat') ;
test_score_opfl = load('data/chars-experiment/netcnn_imdb/Test_Score_opfl_leaveone1.mat') ;
train_class = load('data/chars-experiment/netcnn_imdb/Train_label_1.mat') ;
test_class = load('data/chars-experiment/netcnn_imdb/Test_label_1.mat') ;

All_score_train = cat(1,train_score_histeq.All_score,train_score_opfl.All_score);
All_score_test = cat(1,test_score_histeq.All_score,test_score_opfl.All_score);
% train_class = train_class.Train_label_ran';
% test_class = test_class.Test_label_ran';
train_class = train_class.Train_label(1:180)';
test_class = test_class.Test_label(1:180)';

%�S�x���k�@�� %premnmx���k�@�ƨ�[-1,1]
[input,minI,maxI] = premnmx(All_score_train);
input = double(input);

%�c�y��X�x�}
s = length(train_class) ;
output = zeros(s,9) ;
for i = 1:s 
   output(i,train_class(i)) = 1;
end

%�Ыد��g�����@minmax����J���̤p&�̤j�� {}���E����� traingdx���V�m���
% net = newff(minmax(input) , [10 9] , {'logsig'  'purelin'} , 'traingdx' ) ; 
net = newff(minmax(input) , 9 , {'logsig'} , 'traingdx' ) ; 


%�]�m�V�m�Ѽ�
net.trainparam.show = 50 ;      %��ܤ������G���g��
net.trainparam.epochs = 1000 ;   
net.trainparam.goal = 0.0001 ;    %�V�m���ؼл~�t
net.trainParam.lr = 0.001 ;      %�ǲ߲v

% net.IW = net2.IW;
% net.LW = net2.LW;
% net.b = net2.b;

%�}�l�V�m
net = train( net, input , output' ) ;

%���ռƾڳW�@��
testInput = tramnmx ( All_score_test , minI, maxI ) ;

%��u
Y = sim( net, testInput ) ;

%�έp�ѧO���T�v
[s1 , s2] = size(Y);
hitNum = 0;
class_what = zeros(1,s2);
class_true = zeros(1,s2);
for i = 1 : s2
    [m , Index] = max(Y(:,i)) ;
    class_what(1,i) = Index;
    if(Index  == test_class(i)) 
        hitNum = hitNum + 1 ; 
        class_true(1,i) = 1;
    end
end
sprintf('���Ѳv�O %3.3f%%',100 * hitNum / s2 )

% percent(count,1) = 100 * hitNum / s2;
% end
[C,order] = confusionmat(test_class, class_what);