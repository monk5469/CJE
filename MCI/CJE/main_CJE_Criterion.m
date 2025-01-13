clear all;
close all;

%% computing cross joint entropy, saving, extracting and loading
batch_Save_CJE; 
batch_Extract_CJE;
load MCI_NC_CJE

%% a svm classifier with a own difined 5-fold cross validation Monte-Carlo
Fold           = 5;    % Number of folds
Mento          = 100;  % Number of Mento-Carlo
Num            = [32 32]; % Number of subject of an MCI and NC group
X              = cell2mat(X);
Data_MCI       = X(1:Num(1),    :);
Data_NC        = X(Num(1)+1:end,:);

f = waitbar(0,'Please wait...');


%%%%%%%% 5-fold cross validation %%%
for mento = 1:Mento
  
  str=['Please wait...',num2str(100*(mento-1)/Mento),'%'];
  waitbar((mento-1)/Mento,f,str);
  
  IndA = randperm(32);
  IndB = randperm(32);

%%% Training set %%%%%%
  NumSub_A = [IndA(1:26)
    IndA(7:32)
    IndA(1:6) IndA(13:32)
    IndA(1:12) IndA(19:32)
    IndA(1:18) IndA(25:32)];

  NumSub_B = [IndB(1:26)
    IndB(7:32)
    IndB(1:6) IndB(13:32)
    IndB(1:12) IndB(19:32)
    IndB(1:18) IndB(25:32)];
                    
  %%% Testing set %%%%%%
  NumSub_A_t = [IndA(27:32)
    IndA(1:6)
    IndA(7:12) 
    IndA(13:18) 
    IndA(19:24) ];

  NumSub_B_t = [IndB(27:32)
    IndB(1:6)
    IndB(7:12) 
    IndB(13:18) 
    IndB(19:24) ];

                
  for   fold=1:Fold
      
      %%% Training set %%%%%%
      NumSub_MCI = NumSub_A(fold, :);
      NumSub_NC   = NumSub_B(fold, :);
      
      %%% Testing set %%%%%%
      NumSub_MCI_t = NumSub_A_t(fold, :);
      NumSub_NC_t = NumSub_B_t(fold, :) ;
        
      train_data=[MCI_data(NumSub_MCI,:);NC_data(NumSub_NC,:)];
      train_label=[MCI_label(NumSub_MCI,:);NC_label(NumSub_NC,:)];

      test_data=[MCI_data(NumSub_MCI_t,:);NC_data(NumSub_NC_t,:)];
      test_label=[MCI_label(NumSub_MCI_t,:);NC_label(NumSub_NC_t,:)];

      %%% relieff %%%%%%
%       [idx,weights]= relieff (train_data,train_label,10);
% %       bar(weights(idx))
% %       xlabel('Predictor rank')
% %       ylabel('Predictor importance weight')
%       [m,n]=find(weights>0);
%       Pos=idx(1:length(n));
% 
%       Data_train=ExtractPoints(train_data,Pos);
%       Data_test=  ExtractPoints(test_data,Pos);

  SVMModel = fitcsvm(train_data,train_label,'KernelScale','auto','Standardize',true,...
    'OutlierFraction',0.05);
  label(:,fold) = predict(SVMModel,test_data);
  Loss(fold,1)=sum(~strcmp (test_label, label(:,fold)))/size(label,1);

  end
  Loss_mean(mento) = mean(Loss);
  
end
close(f);
Loss_Mento = mean(Loss_mean)
