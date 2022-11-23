\* Problem: CP3 *\

Minimize
 CoutUnitaire: + 11 Mquantite(1,1,1) + 3 Mquantite(1,2,1)
 + 8 Mquantite(1,3,1) + 3 Mquantite(2,1,1) + 22 Mquantite(2,2,1)
 + 13 Mquantite(2,3,1) + 11 Mquantite(1,1,2) + 4 Mquantite(1,2,2)
 + 7 Mquantite(1,3,2) + 3 Mquantite(2,1,2) + 23 Mquantite(2,2,2)
 + 12 Mquantite(2,3,2) + 110 MtrajetChoisi(1,1) + 90 MtrajetChoisi(1,2)
 + 100 MtrajetChoisi(1,3) + 110 MtrajetChoisi(2,1)
 + 90 MtrajetChoisi(2,2) + 100 MtrajetChoisi(2,3)

Subject To
 demandeServie(1,1): - Mquantite(1,1,1) - Mquantite(1,2,1)
 - Mquantite(1,3,1) = -2
 demandeServie(1,2): - Mquantite(2,1,1) - Mquantite(2,2,1)
 - Mquantite(2,3,1) = -1
 demandeServie(2,1): - Mquantite(1,1,2) - Mquantite(1,2,2)
 - Mquantite(1,3,2) = -0
 demandeServie(2,2): - Mquantite(2,1,2) - Mquantite(2,2,2)
 - Mquantite(2,3,2) = -3
 stockMax(1,1): + Mquantite(1,1,1) + Mquantite(2,1,1) <= 2.5
 stockMax(1,2): + Mquantite(1,1,2) + Mquantite(2,1,2) <= 1
 stockMax(2,1): + Mquantite(1,2,1) + Mquantite(2,2,1) <= 1
 stockMax(2,2): + Mquantite(1,2,2) + Mquantite(2,2,2) <= 2
 stockMax(3,1): + Mquantite(1,3,1) + Mquantite(2,3,1) <= 2
 stockMax(3,2): + Mquantite(1,3,2) + Mquantite(2,3,2) <= 1
 cheminIf1(1,1): - Mquantite(1,1,1) - Mquantite(1,1,2)
 + MtrajetChoisi(1,1) <= -0
 cheminIf1(1,2): - Mquantite(1,2,1) - Mquantite(1,2,2)
 + MtrajetChoisi(1,2) <= -0
 cheminIf1(1,3): - Mquantite(1,3,1) - Mquantite(1,3,2)
 + MtrajetChoisi(1,3) <= -0
 cheminIf1(2,1): - Mquantite(2,1,1) - Mquantite(2,1,2)
 + MtrajetChoisi(2,1) <= -0
 cheminIf1(2,2): - Mquantite(2,2,1) - Mquantite(2,2,2)
 + MtrajetChoisi(2,2) <= -0
 cheminIf1(2,3): - Mquantite(2,3,1) - Mquantite(2,3,2)
 + MtrajetChoisi(2,3) <= -0
 cheminIf2(1,1): + Mquantite(1,1,1) + Mquantite(1,1,2)
 - 100000000 MtrajetChoisi(1,1) <= -0
 cheminIf2(1,2): + Mquantite(1,2,1) + Mquantite(1,2,2)
 - 100000000 MtrajetChoisi(1,2) <= -0
 cheminIf2(1,3): + Mquantite(1,3,1) + Mquantite(1,3,2)
 - 100000000 MtrajetChoisi(1,3) <= -0
 cheminIf2(2,1): + Mquantite(2,1,1) + Mquantite(2,1,2)
 - 100000000 MtrajetChoisi(2,1) <= -0
 cheminIf2(2,2): + Mquantite(2,2,1) + Mquantite(2,2,2)
 - 100000000 MtrajetChoisi(2,2) <= -0
 cheminIf2(2,3): + Mquantite(2,3,1) + Mquantite(2,3,2)
 - 100000000 MtrajetChoisi(2,3) <= -0

Bounds
 0 <= MtrajetChoisi(1,1) <= 1
 0 <= MtrajetChoisi(1,2) <= 1
 0 <= MtrajetChoisi(1,3) <= 1
 0 <= MtrajetChoisi(2,1) <= 1
 0 <= MtrajetChoisi(2,2) <= 1
 0 <= MtrajetChoisi(2,3) <= 1

Generals
 Mquantite(1,1,1)
 Mquantite(1,2,1)
 Mquantite(1,3,1)
 Mquantite(2,1,1)
 Mquantite(2,2,1)
 Mquantite(2,3,1)
 Mquantite(1,1,2)
 Mquantite(1,2,2)
 Mquantite(1,3,2)
 Mquantite(2,1,2)
 Mquantite(2,2,2)
 Mquantite(2,3,2)
 MtrajetChoisi(1,1)
 MtrajetChoisi(1,2)
 MtrajetChoisi(1,3)
 MtrajetChoisi(2,1)
 MtrajetChoisi(2,2)
 MtrajetChoisi(2,3)

End
