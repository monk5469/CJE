%% select matrix off-diagonal elements

function y=Mat(A)
A=cell2mat(A);
a=A-diag(diag(A));
b=a';
y1=b(:);
y1(find(y1==0))=[];
y=y1';

end