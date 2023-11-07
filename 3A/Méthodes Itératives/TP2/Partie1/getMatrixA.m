function A = getMatrixA(N)
    A = zeros(N-1, N-1);
    A = A + diag(2*ones(1, N-1)) - diag(ones(1, N-2), 1) - diag(ones(1, N-2), -1);
end