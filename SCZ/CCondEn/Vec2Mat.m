%% 
% This function returns an M*M matrix, which extracts a N-dimension vector,
% where N = M*(M-1)/2. 

% Written by Haifeng Wu, Yunnan Minzu University, Jan 2022.


%% 
function Y = Vec2Mat(y)
N = length(y);
M = (1+sqrt(1+8*N))/2;
k=1;
A=zeros(M,M);
 for m = 1:M
       for n = m+1 : M
           A(m,n) = y(k);
           k=k+1;
       end
 end

Vm = mean (y);
Y = A+A.'+diag(Vm*ones(M,1));


end
    
  

