function cJ=reconstructionHaar(c0, D)
    J = log2(length(D(1,:)));
    C = zeros(J, 2^J);
    C(1, :) = zeros(1,2^J);
    C(1,1) = c0;
    for j=1:J
        C(j+1, 1) = (C(j, 1) + D(j, 1))/sqrt(2);
        for k=1:2^(j-1)-1
            C(j+1,2*k) = (C(j, k) + D(j, k))/sqrt(2);
            C(j+1,2*k+1) = (C(j, k) - D(j, k))/sqrt(2);
        end
    end
    cJ = C(J,:);
end

    