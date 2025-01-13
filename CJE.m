function Y = CJE (X)

%   Input:
%   	X               - All ROI for a subject 
%
%   Output:
%       Y               - CJE connection matrix

%% Sub-N:Subject normalization
x = reshape(X,1,size(X,1)*size(X,2));
x1 = normalize(x);
X = reshape(x1,size(X,1),size(X,2));

%% Sub-Nm:Linear normalization of subject(max_min)
% x = reshape(X,1,size(X,1)*size(X,2));
% x1 = (x-min(x))/(max(x)-min(x));
% X = reshape(x1,size(X,1),size(X,2));

  for m=1:size(X,2)
    for n=1:size(X,2)
        if m == n
            Y{m,n} = 0;
        else
%% ROI-N:ROI normalization
%             X(:,m) = normalize(X(:,m));
%             X(:,n) = normalize(X(:,n));
%% ROI-NM:Linear normalization of ROI(max_min)
%             Sig=[X(:,m),X(:,n)];
%             s1=(X(:,m)-min(X(:,m)))/(max(X(:,m))-min(X(:,m)));
%             s2=(X(:,n)-min(X(:,n)))/(max(X(:,n))-min(X(:,n)));
            [~,descriptor]=histogram2(X(:,m)',X(:,n)');
            [z,~,~,~] = entropy2(X(:,m)',X(:,n)',descriptor,'biased');
            Y{m,n}=z(1,1);
        end
    end
  end
       
end


