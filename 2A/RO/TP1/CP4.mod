#  Cas particulier 4 :


###############################  Model ###############################

param n, integer, >= 3;
/* Nombre de noeuds */

###############################  Sets  ###############################

set V := 1..n;
/* Sommets/Noeuds/Villes */

set E := {V, V};
/* Arcs/Choix de Chemins */

################### Variables ###################

var Choix{(i,j) in E}, binary;
/* Choix[i,j] = 1 si on choisi d'aller de la ville i vers la ville j */

var y{(i,j) in E}, >= 0;
/* y[i,j] is the number of cars, which the salesman has after leaving
   node i and before entering node j; in terms of the network analysis,
   y[i,j] is a flow through arc (i,j) */

###################  Constants: Data to load   #########################

param Mcout{(i,j) in E};
/* Distance/Cout entre deux Villes */

################### Constraints ###################

s.t. leave{i in V}: sum{(i,j) in E} Choix[i,j] = 1;
/* On quitte une ville une et une seule fois */

s.t. enter{j in V}: sum{(i,j) in E} Choix[i,j] = 1;
/* On entre une ville une et une seule fois */

s.t. cap{(i,j) in E}: y[i,j] <= (n-1) * Choix[i,j];
/* if arc (i,j) does not belong to the salesman's tour, its capacity
   must be zero; it is obvious that on leaving a node, it is sufficient
   to have not more than n-1 cars */

s.t. node{i in V}:
/* node[i] is a conservation constraint for node i */

      sum{(j,i) in E} y[j,i]
      /* summary flow into node i through all ingoing arcs */

      + (if i = 1 then n)
      /* plus n cars which the salesman has at starting node */

      = /* must be equal to */

      sum{(i,j) in E} y[i,j]
      /* summary flow from node i through all outgoing arcs */

      + 1;
      /* plus one car which the salesman sells at node i */

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
