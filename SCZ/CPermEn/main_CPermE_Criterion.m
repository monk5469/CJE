clear all;
close all;

%% computing cross-permutation entropy, saving, extracting and loading
batch_Save_CPermE;
batch_Extract_CPermE;
load SCZ_NC_CPermE_Brain


%% a svm classifier with a own difined 5-fold cross validation Monte-Carlo

Fold           = 5;    % Number of folds
Mento          = 100;  % Number of Mento-Carlo
Num        =  [71 74]; % Number of subject of an SCZ and NC group

X   = cell2mat(X);


Data_SCZ       = X(1:Num(1),    :);
Data_NC        = X(Num(1)+1:end,:);

f = waitbar(0,'Cross validation, please wait...');


%%%%%%%% 5-fold cross validation %%%
for mento = 1:Mento

    str=['Cross validation, please wait...',num2str(round(100*(mento-1)/Mento)),'%'];
    waitbar((mento-1)/Mento,f,str);

    IndA = randperm(71);
    IndB = randperm(74);

    %%% Training set %%%%%%
    NumSub_A = [IndA(1:57)
        IndA(15:71)
        IndA(1:14) IndA(29:71)
        IndA(1:28) IndA(43:71)
        IndA(1:42) IndA(57:71)];

    NumSub_B = [IndB(1:60)
        IndB(15:74)
        IndB(1:14) IndB(29:74)
        IndB(1:28) IndB(43:74)
        IndB(1:42) IndB(57:74)];

    %%% Testing set %%%%%%
    NumSub_A_t = [ IndA(58:71)
        IndA(1:14)
        IndA(15:28)
        IndA(29:42)
        IndA(43:56) ];

    NumSub_B_t = [IndB(61:74)
        IndB(1:14)
        IndB(15:28)
        IndB(29:42)
        IndB(43:56) ];

    Label_train(1:size(NumSub_A ,2), :) = {'SCZ'};
    Label_train(size(NumSub_A ,2)+1:size(NumSub_A ,2)+size(NumSub_B ,2),:) = {'NC'};

    Label_Exp(1:size(NumSub_A_t ,2), :) = {'SCZ'};
    Label_Exp(size(NumSub_A_t ,2)+1:size(NumSub_A_t ,2)+size(NumSub_B_t ,2),:) = {'NC'};


    for   fold=1:Fold

        %%% Training set %%%%%%
        NumSub_SCZ  = NumSub_A(fold, :);
        NumSub_NC   = NumSub_B(fold, :);

        %%% Testing set %%%%%%
        NumSub_SCZ_t = NumSub_A_t(fold, :);
        NumSub_NC_t  = NumSub_B_t(fold, :) ;

        X_SCZ  = Data_SCZ(NumSub_SCZ,:);
        X_NC   = Data_NC(NumSub_NC,:);
        X_SCZ_t= Data_SCZ(NumSub_SCZ_t,:);
        X_NC_t = Data_NC(NumSub_NC_t,:);

        %%% For corss validation  %%%%%%
        Am    = X_SCZ  ;
        Bm    = X_NC   ;
        Am_t  = X_SCZ_t;
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
