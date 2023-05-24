function [clusters] = classification_spectrale(S, k, sigma)
    [n,~] = size(S);
    A = zeros(n,n);
    for i = 1:n
        for j = i+1:n
            A(i,j) = exp(-(norm(S(i,:) - S(j,:))^2)/(2*sigma^2));
            A(j,i) = A(i,j);
        end
    end
    Dr = diag(1./sqrt(sum(A)));
    L = Dr*A*Dr;
    [vecp, valp] = eigs(L,k);
    [~, ind] = sort(diag(valp),'descend');
    X = vecp(:,ind);
    Y = zeros(n,k);
    for i = 1:n
        somme = sqrt(sum(X(i,:).^2));
        Y(i,:) = X(i,:)/somme;
    end 
    clusters = kmeans(Y,k);
end