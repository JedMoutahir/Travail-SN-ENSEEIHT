function x = moyenne(img)
    X = single(img);
    R = X(:,:,1);
    V = X(:,:,2);
    B = X(:,:,3);
    X = X ./ max(1, R+V+B);
    x = [mean(mean(X(:,:,1))) ; mean(mean(X(:,:,2)))];
end