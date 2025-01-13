% This function is mainly to extract the CPermE connectivity matrix of 
% the all data, and save.

clear all
close all

Num       =  [71 74];
Group     =   {'SCZ' 'NC'};
k=1;

f = waitbar(0,'Extracting features, please wait...');

for g  = 1 : length(Group)

    for nSub = 1 : Num(g)
        ntmp = ( (g-1)*Num(1)+nSub ) / sum(Num) ;
        str=['Extracting features, please wait...',num2str( round (100* ntmp) ),'%'];
        waitbar( ntmp, f, str);

        if strcmp(Group(g),'SCZ')
            load([ 'CPermE_data\SCZ_CPermE_', num2str(nSub), '.mat']);
            tmp = Mat (RHO);
            tmp=num2cell(tmp);
            for num = 1: length(tmp)
                X { k,  num } = tmp {num};
            end
            Y  {k, 1}  = 'SCZ';
            k=k+1;
        elseif strcmp(Group(g),'NC')
            load([ 'CPermE_data\NC_CPermE_', num2str(nSub), '.mat']);
            tmp = Mat (RHO);
            tmp=num2cell(tmp);
            for num = 1: length(tmp)
                X { k,  num } = tmp {num};
            end
            Y  {k, 1}  = 'NC';
            k=k+1;
        end

    end

end

save('SCZ_NC_CPermE_Brain.mat','X','Y');
close(f);