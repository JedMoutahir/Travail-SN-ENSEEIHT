#  Exercice 2 : 


###############################  Model ###############################



###############################  Sets  ###############################

set n;
set L := {1..3};
set C := {1..3};
################### Variables ###################

var Mpt{L, C} binary; 

###################  Constants: Data to load   #########################

param Mcout{L, C}, >=0; 

################### Constraints ###################


s.t. MptBienDefinieLignes{i in L}:
  sum{j in C} Mpt[i,j] = 1;
  
s.t. MptBienDefinieColonnes{i in L}:
  sum{j in C} Mpt[j,i] = 1;


###### Objective ######

minimize CoutFormation: 
		sum{i in L, j in C} Mpt[i,j] * Mcout[i,j]; 

#end;


#default data

data;

set n := 3;

param Mcout: 1 2 3 :=
1 15 54 52
2 23 45 35
3 55 45 79;

end;
