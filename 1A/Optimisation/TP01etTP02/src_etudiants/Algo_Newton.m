function [beta, norm_grad_f_beta, f_beta, norm_delta, nb_it, exitflag] ...
          = Algo_Newton(Hess_f_C14, beta0, option)
%************************************************************
% Fichier  ~gergaud/ENS/Optim1a/TP-optim-20-21/Newton_ref.m *
% Novembre 2020                                             *
% Université de Toulouse, INP-ENSEEIHT                      *
%************************************************************
%
% Newton r�sout par l'algorithme de Newton les problemes aux moindres carres
% Min 0.5||r(beta)||^2
% beta \in R^p
%
% Parametres en entrees
% --------------------
% Hess_f_C14 : fonction qui code la hessiennne de f
%              Hess_f_C14 : R^p --> matrice (p,p)
%              (la fonction retourne aussi le residu et la jacobienne)
% beta0  : point de départ
%          real(p)
% option(1) : Tol_abs, tolérance absolue
%             real
% option(2) : Tol_rel, tolérance relative
%             real
% option(3) : nitimax, nombre d'itérations maximum
%             integer
%
% Parametres en sortie
% --------------------
% beta      : beta
%             real(p)
% norm_gradf_beta : ||gradient f(beta)||
%                   real
% f_beta    : f(beta)
%             real
% res       : r(beta)
%             real(n)
% norm_delta : ||delta||
%              real
% nbit       : nombre d'itérations
%              integer
% exitflag   : indicateur de sortie
%              integer entre 1 et 4
% exitflag = 1 : ||gradient f(beta)|| < max(Tol_rel||gradient f(beta0)||,Tol_abs)
% exitflag = 2 : |f(beta^{k+1})-f(beta^k)| < max(Tol_rel|f(beta^k)|,Tol_abs)
% exitflag = 3 : ||delta)|| < max(Tol_rel delta^k),Tol_abs)
% exitflag = 4 : nombre maximum d'itérations atteint
%      
% ---------------------------------------------------------------------------------
    
% TO DO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function f_beta = f(beta)
        [~, R, ~] = Hess_f_C14(beta_pre);
        f_beta = 1/2 * norm(R)^2;
    end 
    function norm_grad_f_beta = n(beta)
        [~, R, J] = Hess_f_C14(beta_pre);
        norm_grad_f_beta = norm(J.'*R);
    end
% TO DO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    beta_pre = beta0;
    nb_it = 0;
    Tol_abs = option(1);
    Tol_rel = option(2);
    exitflag = 0;
    while exitflag == 0
        [H, R, J] = Hess_f_C14(beta_pre);
        beta = beta_pre - H\(J.'*R);
        norm_grad_f_beta = n(beta);
        f_beta = f(beta);
        delta = beta - beta_pre;
        norm_delta = norm(delta);
        nb_it = nb_it + 1;
        if norm_grad_f_beta < max(Tol_rel*n(beta0), Tol_abs)
            exitflag = 1;
            break
        end
        if norm(f_beta - f(beta_pre)) < max(Tol_rel*f(beta_pre), Tol_abs)
            exitflag = 2;
            break
        end
        if norm(delta) < max(Tol_rel*norm(beta), Tol_abs)
            exitflag = 3;
            break
        end
        if nb_it >= option(3)
            exitflag = 4;
            break
        end
        beta_pre = beta;
    end
end
