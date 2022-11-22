\* Problem: CP1 *\

Minimize
 CoutUnitaire: + Mquantite(1,1) + 2 Mquantite(2,1) + 3 Mquantite(3,1)
 + Mquantite(1,2) + 3 Mquantite(2,2) + 2 Mquantite(3,2)

Subject To
 demandeServie(1): - Mquantite(1,1) - Mquantite(2,1) - Mquantite(3,1)
 = -3
 demandeServie(2): - Mquantite(1,2) - Mquantite(2,2) - Mquantite(3,2)
 = -3
 stockMax(1,1): + Mquantite(1,1) <= 2.5
 stockMax(1,2): + Mquantite(1,2) <= 1
 stockMax(2,1): + Mquantite(2,1) <= 1
 stockMax(2,2): + Mquantite(2,2) <= 2
 stockMax(3,1): + Mquantite(3,1) <= 2
 stockMax(3,2): + Mquantite(3,2) <= 1

End
