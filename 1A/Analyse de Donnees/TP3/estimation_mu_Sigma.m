function [mu, sigma] = estimation_mu_Sigma(X)
    n = length(X);
    mu = 1/n * X' * ones(n,1);
    Xc = X - (mu*ones(1,n))';
    sigma = 1/n * Xc' * Xc;
end