function ump1 = weighted_jacobi(A, um, f, omega, m)
    % Assurez-vous que A est une matrice carrée et que um et f ont des dimensions compatibles
    [~, n] = size(A);
    if size(um, 1) ~= n || size(um, 2) ~= 1 || size(f, 1) ~= n || size(f, 2) ~= 1
        error('Les dimensions de A, um et f ne sont pas compatibles.');
    end

    D = diag(diag(A)); % Matrice diagonale de A
    L = tril(A, -1);  % Partie triangulaire inférieure de A
    U = triu(A, 1);   % Partie triangulaire supérieure de A
    
    ump1 = um; % Initialisation de u(m+1) avec um

    for i = 1:m
        % Calcule la prochaine itération de u(m+1)
        ump1 = (eye(n) - omega*inv(D)*A)*ump1 + omega*inv(D)*f;
    end
end
