#  Cas Particulier 2 : 


###############################  Model ###############################



###############################  Sets  ###############################

set nProduit := {1..2};
set nDemande := {1..2};
set nMagasin := {1..3};

################### Variables ###################

var Mquantite{nMagasin, nProduit}, integer, >=0; 

###################  Constants: Data to load   #########################

param Mcommande{nDemande, nProduit}, >=0; 
param Mstock{nMagasin, nProduit}, >=0; 
param Mcout{nMagasin, nProduit}, >=0; 

################### Constraints ###################

s.t. demandeServie{i in nProduit}:
  sum{j in nDemande} Mcommande[j,i] = sum{j in nMagasin} Mquantite[j,i];

s.t. stockMax{i in nMagasin, j in nProduit}:
  Mquantite[i,j] <= Mstock[i,j] ;

###### Objective ######

minimize CoutUnitaire: 
		sum{i in nMagasin, j in nProduit} Mquantite[i,j] * Mcout[i,j]; 
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

end;
