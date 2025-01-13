clear all;
close all;

%% computing cross-fuzzy entropy, saving, extracting and loading
% batch_Save_CFuzzE;
% batch_Extract_CFuzzE;
load ASD_NC_CFuzzE

%% a svm classifier with a own difined 5-fold cross validation Monte-Carlo

Fold           = 5;    % Number of folds
Mento          = 100;  % Number of Mento-Carlo
Num        =  [48 50]; % Number of subject of an ASD and NC group

X   = cell2mat(X);


Data_ASD       = X(1:Num(1),    :);
Data_NC        = X(Num(1)+1:end,:);

f = waitbar(0,'Cross validation, please wait...');


%%%%%%%% 5-fold cross validation %%%
for mento = 1:Mento
  
  str=['Cross validation, please wait...',num2str(round(100*(mento-1)/Mento)),'%'];
  waitbar((mento-1)/Mento,f,str);
  
  IndA = randperm(48);
  IndB = randperm(50);

%%% Training set %%%%%%
  NumSub_A = [IndA(1:40)
    IndA(9:48)
    IndA(1:10) IndA(19:48)
    IndA(1:20) IndA(29:48)
    IndA(1:30) IndA(39:48)];

  NumSub_B = [IndB(1:40)
    IndB(11:50)
    IndB(1:10) IndB(21:50)
    IndB(1:20) IndB(31:50)
    IndB(1:30) IndB(41:50)];
                    
  %%% Testing set %%%%%%
  NumSub_A_t = [ IndA(41:48)
    IndA(1:8)
    IndA(11:18) 
    IndA(21:28) 
    IndA(31:38) ];

  NumSub_B_t = [IndB(41:50)
    IndB(1:10)
    IndB(11:20) 
    IndB(21:30) 
    IndB(31:40) ];

  Label_train(1:size(NumSub_A ,2), :) = {'ASD'};
  Label_train(size(NumSub_A ,2)+1:size(NumSub_A ,2)+size(NumSub_B ,2),:) = {'NC'};                      

  Label_Exp(1:size(NumSub_A_t ,2), :) = {'ASD'};
  Label_Exp(size(NumSub_A_t ,2)+1:size(NumSub_A_t ,2)+size(NumSub_B_t ,2),:) = {'NC'};                      

                      
  for   fold=1:Fold
      
      %%% Training set %%%%%%
      NumSub_ASD  = NumSub_A(fold, :);
      NumSub_NC   = NumSub_B(fold, :);
      
      %%% Testing set %%%%%%
      NumSub_ASD_t = NumSub_A_t(fold, :);
      NumSub_NC_t  = NumSub_B_t(fold, :) ;

      X_ASD  = Data_ASD(NumSub_ASD,:);
      X_NC   = Data_NC(NumSub_NC,:);
      X_ASD_t= Data_ASD(NumSub_ASD_t,:);
      X_NC_t = Data_NC(NumSub_NC_t,:);

%%% For corss validation  %%%%%%
  Am    = X_ASD  ;
  Bm    = X_NC   ;
  Am_t  = X_ASD_t;
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
