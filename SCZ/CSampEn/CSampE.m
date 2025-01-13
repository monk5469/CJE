%%This function is used to process the data through different normalization
% XSampEn function refer to: EntropyHub Project

function Y = CSampE (X)
%   Input:
%   	X               - All ROI for a subject
%
%   Output:
%       Y               - Entropy connection matrix
%% Sub-N:Subject normalization
x = reshape(X,1,size(X,1)*size(X,2));
x = normalize(x);
X=reshape(x,size(X,1),size(X,2));

%% Sub-Nm:Linear normalization of subject(max_min)
% x = reshape(X,1,size(X,1)*size(X,2));
% x1 = (x-min(x))/(max(x)-min(x));
% X = reshape(x1,size(X,1),size(X,2));
for m=1:size(X,2)
    for n=m:size(X,2)
        if m == n
            Y{m,n} = 0;
        else
%% ROI-NM:Linear normalization of ROI(max_min)
%             s1=(X(:,m)-min(X(:,m)))/(max(X(:,m))-min(X(:,m)));
%             s2=(X(:,n)-min(X(:,n)))/(max(X(:,n))-min(X(:,n)));
%% ROI-N:ROI normalization
%             Sig=[normalize(X(:,m)),normalize(X(:,n))];
            Sig=[X(:,m),X(:,n)];
            z = XSampEn (Sig);
            Y{m,n}=z(1,1);
        end
    end
end

end


