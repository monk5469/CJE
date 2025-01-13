function Y = CPermE (X)
%% 
% YM            - a cell-type value, M*M timeseries cross-spectrum 
%                 information
% X             - an M*M timeseries matrix
%% 
% x = reshape(X,1,size(X,1)*size(X,2));
% x = normalize(x);
% X = reshape(x,size(X,1),size(X,2));

%%max_min
% x = reshape(X,1,size(X,1)*size(X,2));
% x1 = (x-min(x))/(max(x)-min(x));
% X = reshape(x1,size(X,1),size(X,2));
  for m=1:size(X,2)
    for n=1:size(X,2)
        if m == n
            Y{m,n} = 0;
        else
%             X(:,m) = normalize(X(:,m));
%             X(:,n) = normalize(X(:,n));
            s1=(X(:,m)-min(X(:,m)))/(max(X(:,m))-min(X(:,m)));
            s2=(X(:,n)-min(X(:,n)))/(max(X(:,n))-min(X(:,n)));
            Sig=[s1,s2];
            z = XPermEn (Sig);
            Y{m,n}=z(1,1);
        end
    end
  end
       
end


