
% This function convert a vector to a symmetrical matrix.

function A=UpMat2Mat(x)

M =  length(x);
N = (1+(1+8*M)^0.5)/2;

AUp=zeros(N,N);

k=1;

for m = 1:N
    for n = m+1 : N
        AUp(m,n) = x(k);
        k=k+1;
    end
end

A = AUp.'+AUp;

 

