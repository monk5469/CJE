function Y = CSampE (X)
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
    for n=m:size(X,2)
        if m == n
            Y{m,n} = 0;
        else

            %             X(:,m) = normalize(X(:,m));
            %             X(:,n) = normalize(X(:,n));
            X(:,m) = (X(:,m)-mean(X(:,m)))/std(X(:,m));
            X(:,n) = (X(:,n)-mean(X(:,n)))/std(X(:,n));
            Sig=[X(:,m),X(:,n)];
            z = XSampEn (Sig);
            Y{m,n}=z(1,1);
        end
    end
end

end


