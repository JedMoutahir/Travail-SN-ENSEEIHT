function I2hh = interpol(N)

    I2hh = zeros(N - 1, N / 2 - 1);

    for i = 1:N/2-1
        I2hh(2*i-1, i) = 1;
        I2hh(2*i, i) = 2;
        I2hh(2*i+1, i) = 1;
    end

    I2hh = 0.5*I2hh;
end