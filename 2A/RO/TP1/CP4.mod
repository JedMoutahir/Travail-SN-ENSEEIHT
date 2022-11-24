#  Cas particulier 4 :


###############################  Model ###############################

param n, integer, >= 1;
/* Nombre de clients */

###############################  Sets  ###############################

set V := 1..n;
/* Clients */

set E := {V, V};
/* Dimension de la matrice */

################### Variables ###################

var Choix{(i,j) in E}, binary;
/* Choix[i,j] = 1 si on choisi d'aller du client i vers le client j */

var Ventes{(i,j) in E}, >= 0;
/* Variable qui indique le nombre de ventes restantes après une livraison */

###################  Constants: Data to load   #########################

param Mcout{(i,j) in E};
/* Distance/Cout entre deux clients */

################### Constraints ###################

s.t. leave{i in V}: sum{(i,j) in E} Choix[i,j] = 1;
/* On quitte le client une et une seule fois */

s.t. enter{j in V}: sum{(i,j) in E} Choix[i,j] = 1;
/* On va chez le client une et une seule fois */

s.t. cap{(i,j) in E}: Ventes[i,j] <= (n-1) * Choix[i,j];
/* Le nombre de ventes restantes dépends de Choix. Ceci permet d'avoir un trajet valide. */

s.t. node{i in V}:
      sum{(j,i) in E} Ventes[j,i] + (if i = 1 then n) = sum{(i,j) in E} Ventes[i,j] + 1;
/* Le nombre de ventes restantes dépends de Choix. Ceci permet d'avoir un trajet valide. */

###### Objective ######

minimize total: sum{(i,j) in E} Mcout[i,j] * Choix[i,j];

#end;


#default data

data;

param n := 6;

param Mcout: 1 2 3 4 5 6 :=
1 0 1 1 10 12 12
2 1 0 1 8 10 11
3 1 1 0 8 11 10
4 10 8 8 0 1 1
5 12 10 11 1 0 1
6 12 11 10 1 1 0;

end;
