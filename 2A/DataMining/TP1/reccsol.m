function [Isol, min] = reccsol(iteration, chi, g, d, val, I, Ibar, Q, R)
    min = chi;
    Isol = I;
    if(iteration < 1)
        phinv = phi(I,Ibar, Q);
        if (phinv < chi)
            min = chi;
            Isol = I;
        end
    else
        for i=g:d
            I(iteration) = i;
            vali = val + sum(R(iteration, iteration:end) * I(iteration:end) - Ibar(iteration:end))^2;
            if vali < chi
                gi = ceil((-sqrt(chi - vali)) / R(iteration, iteration) + Ibar(iteration));
                di = floor((sqrt(chi - vali)) / R(iteration, iteration) + Ibar(iteration));
                iteration = iteration - 1;
                [Icalc, mincalc] = calcI(iteration, chi, gi, di, vali, I, Ibar, Q, R);
                if mincalc < min
                    min = mincalc;
                    chi = min;
                    Isol = Icalc;
                end
            end
        end
    end
end 