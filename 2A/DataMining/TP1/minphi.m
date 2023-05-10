function [Isol] = minphi(Ibar, Q)
    I = zeros(size(Ibar));
    Isol = I;
    R = chol(Q);
    chi = phi(round(Ibar), Ibar, Q);

    g3 = ceil((-sqrt(chi)/R(3,3)) + Ibar(3));
    d3 = floor((sqrt(chi)/R(3,3)) + Ibar(3));
    minimum = chi;
    for i3 = g3:d3
        exist3 = (R(3, 3)*(i3 - Ibar(3)))^2;
        if chi > exist3
            g2 = ceil(-sqrt(chi-(R(3, 3)*(i3 - Ibar(3)))^2)/R(2, 2) + Ibar(2) - R(2, 3)*(i3 - Ibar(3))/R(2, 2));
            d2 = floor(sqrt(chi-(R(3, 3)*(i3 - Ibar(3)))^2)/R(2, 2) + Ibar(2) - R(2, 3)*(i3 - Ibar(3))/R(2, 2));
            for i2 = g2:d2
                exist2 = exist3 + (R(2, 2)*(i2 - Ibar(2)) + R(2, 3)*(i3 - Ibar(3)))^2;
                if chi > exist2
                    g1 = ceil(((-sqrt(chi-exist2))-R(1,2)*(i2-Ibar(2))-R(1,3)*(i3-Ibar(3)))/R(1,1) + Ibar(1));
                    d1 = floor(((sqrt(chi-exist2))-R(1,2)*(i2-Ibar(2))-R(1,3)*(i3-Ibar(3)))/R(1,1) + Ibar(1));
                    for i1 = g1:d1
                        I = [i1;i2;i3];
                        minold = minimum;
                        minimum = min(minimum, phi(I,Ibar,Q));
                        chi = minimum;
                        if minold ~= minimum
                            Isol = I;
                        end
                    end
                end
            end
        end
    end
end