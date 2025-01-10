clear all;
close all;
clc;

%% set up folder for .mat files containing variables of interest 
myFolder_MCI = ('E:\Study\Entropy\EntropyHub\ROI_data\MCI\');
filePattern_MCI = fullfile(myFolder_MCI, 'MCI_*.mat');
myFolder_NC = ('E:\Study\Entropy\EntropyHub\ROI_data\NC\');
filePattern_NC = fullfile(myFolder_NC, 'NC_*.mat');
fileList_MCI = dir(filePattern_MCI);
fileList_NC = dir(filePattern_NC);
number_MCI = length(fileList_MCI);
number_NC = length(fileList_NC);

%%   MCI
sum=zeros(116,116);
for i = 1:number_MCI
    load(['E:\Study\Entropy\EntropyHub\ROI_data\MCI\MCI_' num2str(i) '.mat']) ;
    [NRowX,NColX]=size(ROISignals);
%     entropy=zeros(NColX,NColX);
    for j=1:NColX
        sig1 = ROISignals(:,j);
        for k=1:NColX
            sig2 = ROISignals(:,k);
            s1 = (sig1-mean(sig1))/std(sig1,1);
            s2 = (sig2-mean(sig2))/std(sig2,1);
%             sig = [sig1,sig2]';
            En = entropy2(s1',s2');%交叉条件熵
%             entropy(i,j)=XCond(1,1);
            S(j,k)=En(1,1);
        end
    end
    sum=sum+S;
end 

Xentropy_MCI=sum/number_MCI;

figure(1);
imagesc(Xentropy_MCI)
colormap('jet');
title('MCI entropy estimate2');
clear i j k S sig sum

%%   NC
sum=zeros(116,116);
for i = 1:number_NC
    load(['E:\Study\Entropy\EntropyHub\ROI_data\NC\NC_' num2str(i) '.mat']) ;
    [NRowX,NColX]=size(ROISignals);
%     entropy=zeros(NColX,NColX);
    for j=1:NColX
        sig1 = ROISignals(:,j);
        for k=1:NColX
            sig2 = ROISignals(:,k);
            s1 = (sig1-mean(sig1))/std(sig1,1);
            s2 = (sig2-mean(sig2))/std(sig2,1);
%             sig = [sig1,sig2]';
            En =  entropy2(s1',s2');%交叉条件熵
%             entropy(i,j)=XCond(1,1);
            S(j,k)=En(1,1);
        end
    end
    sum=sum+S;
end 

Xentropy_NC=sum/number_NC;
figure(2);
imagesc(Xentropy_NC)
colormap('jet');
title('NC entropy estimate2');
clear i j k S sig sum