% This function mainly calculates the CApEn of the subject and saves it.
% CApEn calculates the cross-approximate entropy.

close all
clear all

Mento = 10;
% for mento = 1:Mento
mkdir('CApE_data');
Num        =  [71 74];
Group     =   {'SCZ' 'NC'};

f = waitbar(0,'Saving data, please wait...');
% mypar=parpool;
for g  = 1 : length(Group)

    for nSub = 1 : Num(g)
        ntmp = ( (g-1)*Num(1)+nSub ) / sum(Num) ;
        str=['Saving data, please wait...',num2str( round (100* ntmp) ),'%'];
        waitbar( ntmp, f, str);

        if strcmp(Group(g),'SCZ')
            load([ 'ROI_data\SCZ\ROISignals_Sub_0', num2str(nSub), '.mat']);
            ROI_tmp=ROISignals;
            tic
            RHO = CApE(ROI_tmp);
            t(nSub,:)=toc;
            save([ 'CApE_data\SCZ_CApE_', num2str(nSub), '.mat'],'RHO');
        elseif strcmp(Group(g),'NC')
            load([ 'ROI_data\NC\ROISignals_Sub_0', num2str(nSub), '.mat']);
            ROI_tmp=ROISignals;
            tic
            RHO = CApE(ROI_tmp);
            t(Num(1)+nSub,:)=toc;
            save([ 'CApE_data\NC_CApE_', num2str(nSub), '.mat'],'RHO');
        end

    end
end
% delete(mypar);
t_mean = mean(t);
tt = mean(t_mean);
close(f);

% end
