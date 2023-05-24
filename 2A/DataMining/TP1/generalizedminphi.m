function [Isol] = generalizedminphi(Ibar, Q)
    chi = phi(round(Ibar), Ibar, Q);
    I = zeros(size(Ibar));
    Isol = reccsol(R, Ibar, I, chi);
end