%% 
% This function returns an N*1 vector or cell, which extracts the up-triangle 
% elements of a matrix or a cell. 

% Written by Haifeng Wu, Yunnan Minzu University, Jan 2022.


%% 
function y=UpMat(A)


k=1;
if strcmp(class(A),'cell')
    for m = 1:size(A,1)
       for n = m+1 : size(A,2)
        y{k,1} = A{m,n};
        k=k+1;
       end
    end
elseif strcmp(class(A),'double')
    for m = 1:size(A,1)
       for n = m+1 : size(A,2)
        y(k,1) = A(m,n);
        k=k+1;
       end
    end
end


end
    
  

