close all
clear all

mkdir('CJE_data');
Num        =  [48 50];
Group     =   {'ASD' 'NC'};

f = waitbar(0,'Saving data, please wait...');

for g  = 1 : length(Group)

    for nSub = 1 : Num(g)
        ntmp = ( (g-1)*Num(1)+nSub ) / sum(Num) ;
        str=['Saving data, please wait...',num2str( round (100* ntmp) ),'%'];
        waitbar( ntmp, f, str);

        if strcmp(Group(g),'ASD')
            load([ 'ROI_data\ASD\ROISignals_Sub0', num2str(nSub), '.mat']);
            ROI_tmp=ROISignals;
            tic
            RHO = CJE(ROI_tmp);
            t(nSub,:)=toc;
            save([ 'CJE_data\ASD_', num2str(nSub), '.mat'],'RHO');
        elseif strcmp(Group(g),'NC')
            load([ 'ROI_data\NC\ROISignals_Sub0', num2str(nSub), '.mat']);
            ROI_tmp=ROISignals;
            tic
            RHO = CJE(ROI_tmp);
            t(Num(1)+nSub,:)=toc;
            save([ 'CJE_data\NC_', num2str(nSub), '.mat'],'RHO');
        end

    end
end
t_mean = mean(t);
close(f);
