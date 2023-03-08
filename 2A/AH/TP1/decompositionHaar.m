function [c0, Dtilde]=decompositionHaar(cJ)
    eps = 10^(-6);
    J = log2(length(cJ));
    D = zeros(J, 2^J);
    C = zeros(J, 2^J);
    C(J,:) = cJ;
    for j=J-1:-1:1
        for k=1:1:2^(j-1)
            C(j,k) = (C(j+1,2*k) + C(j+1,2*k+1))/sqrt(2);
            D(j,k) = (C(j+1,2*k) - C(j+1,2*k+1))/sqrt(2);
        end
    end
    Dtilde = D .* (abs(D) >= eps);
    c0 = C(1,1);
end

    