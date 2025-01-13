%% 
% This function returns an N*1 vector, which extracts the lower-triangle 
% elements of a matrix. 

function y=LowMat(A)

low= tril(A,-1);
a=low';
low=a(:);
low(Find(low==0))=[];
y=low';

end 
