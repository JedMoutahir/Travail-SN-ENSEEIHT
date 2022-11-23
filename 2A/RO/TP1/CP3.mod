#  Cas Particulier 3 : 


###############################  Model ###############################



###############################  Sets  ###############################

set nProduit := {1..2};
set nDemande := {1..2};
set nMagasin := {1..3};

################### Variables ###################

var Mquantite{nDemande, nMagasin, nProduit}, integer, >=0; 
var MtrajetChoisi{nDemande, nMagasin}, binary, >=0; 

###################  Constants: Data to load   #########################

param Mcommande{nDemande, nProduit}, >=0; 
param Mstock{nMagasin, nProduit}, >=0; 
param Mcout{nMagasin, nProduit}, >=0; 
param McoutFixe{nDemande, nMagasin}, >=0; 
param McoutVar{nDemande, nMagasin}, >=0; 

################### Constraints ###################

s.t. demandeServie{i in nProduit, j in nDemande}:
  Mcommande[j,i] = sum{k in nMagasin} Mquantite[j,k,i];

s.t. stockMax{i in nMagasin, j in nProduit}:
  sum{k in nDemande} Mquantite[k,i,j] <= Mstock[i,j] ;

s.t. cheminIf1{i in nDemande, j in nMagasin}:
  MtrajetChoisi[i,j] <= sum{k in nProduit} Mquantite[i,j,k];

s.t. cheminIf2{i in nDemande, j in nMagasin}:
  sum{k in nProduit} Mquantite[i,j,k] <= MtrajetChoisi[i,j] * 100000000; ####### Replace the if statement #######

###### Objective ######

minimize CoutUnitaire: 
		(sum{i in nDemande, j in nMagasin} MtrajetChoisi[i,j] * McoutFixe[i,j]) + (sum{i in nDemande, j in nMagasin, k in nProduit } Mquantite[i,j,k] * (Mcout[j,k] + McoutVar[i,j]));

#end;


#default data

data;

param Mcommande: 1 2 :=
1 2 0
2 1 3;

param Mstock: 1 2 :=
1 2.5 1
2 1 2
3 2 1;

param Mcout: 1 2 :=
1 1 1
2 2 3
3 3 2;

param McoutFixe: 1 2 3 :=
1 110 90 100
2 110 90 100;

param McoutVar: 1 2 3 :=
1 10 1 5
2 2 20 10;

end;
