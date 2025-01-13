clear all;
close all;

%% computing cross approximate entropy, saving, extracting and loading
batch_Save_CApE; 
batch_Extract_CApE;
load MCI_NC_CApE

%% a svm classifier with a own difined 5-fold cross validation Monte-Carlo
Fold           = 5;    % Number of folds
Mento          = 100;  % Number of Mento-Carlo
Num            = [32 32]; % Number of subject of an MCI and NC group
X              = cell2mat(X);
Data_MCI       = X(1:Num(1),    :);
Data_NC        = X(Num(1)+1:end,:);

f = waitbar(0,'Cross validation, please wait...');

%%%%%%%% 5-fold cross validation %%%
for mento = 1:Mento
  
  str=['Cross validation, please wait...',num2str(round(100*(mento-1)/Mento)),'%'];
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
  NumSub_A_t = [ IndA(27:32)
    IndA(1:6)
    IndA(7:12) 
    IndA(13:18) 
    IndA(19:24) ];

  NumSub_B_t = [IndB(27:32)
    IndB(1:6)
    IndB(7:12) 
    IndB(13:18) 
    IndB(19:24) ];

  Label_train(1:size(NumSub_A ,2), :) = {'MCI'};
  Label_train(size(NumSub_A ,2)+1:size(NumSub_A ,2)+size(NumSub_B ,2),:) = {'NC'};                      

  Label_Exp(1:size(NumSub_A_t ,2), :) = {'MCI'};
  Label_Exp(size(NumSub_A_t ,2)+1:size(NumSub_A_t ,2)+size(NumSub_B_t ,2),:) = {'NC'};                      

                      
  for   fold=1:Fold
      
      %%% Training set %%%%%%
      NumSub_MCI  = NumSub_A(fold, :);
      NumSub_NC   = NumSub_B(fold, :);
      
      %%% Testing set %%%%%%
      NumSub_MCI_t = NumSub_A_t(fold, :);
      NumSub_NC_t  = NumSub_B_t(fold, :) ;

      X_MCI  = Data_MCI(NumSub_MCI,:);
      X_NC   = Data_NC(NumSub_NC,:);
      X_MCI_t= Data_MCI(NumSub_MCI_t,:);
      X_NC_t = Data_NC(NumSub_NC_t,:);

%%% For corss validation  %%%%%%
  Am    = X_MCI  ;
  Bm    = X_NC   ;
  Am_t  = X_MCI_t;
  Bm_t  = X_NC_t ;

  Data_train = [Am; Bm];
  Data_test = [Am_t; Bm_t];

  SVMModel = fitcsvm(Data_train,Label_train,'KernelScale','auto','Standardize',true,...
    'OutlierFraction',0.05);
  label(:,fold) = predict(SVMModel,Data_test);
  Loss(fold,1)=sum(~strcmp (Label_Exp, label(:,fold)))/size(label,1);

  end
  
  %% 
  Loss_mean(mento) = mean(Loss);
  
end

%% 
close(f);
Loss_Mento = mean(Loss_mean)
