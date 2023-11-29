% Verifie que toutes les matrices sont symetriques definies positives

load mat0.mat

[~, flag] = chol(A);
flag

load mat1.mat

[~, flag] = chol(A);
flag

load mat2.mat

[~, flag] = chol(A);
flag

load mat3.mat

[~, flag] = chol(A);
flag

% All 0 --> OK