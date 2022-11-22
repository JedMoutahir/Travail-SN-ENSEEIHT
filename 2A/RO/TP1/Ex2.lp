\* Problem: Ex2 *\

Minimize
 CoutFormation: + 15 Mpt(1,1) + 54 Mpt(1,2) + 52 Mpt(1,3) + 23 Mpt(2,1)
 + 45 Mpt(2,2) + 35 Mpt(2,3) + 55 Mpt(3,1) + 45 Mpt(3,2) + 79 Mpt(3,3)

Subject To
 MptBienDefinieLignes(1): + Mpt(1,1) + Mpt(1,2) + Mpt(1,3) = 1
 MptBienDefinieLignes(2): + Mpt(2,1) + Mpt(2,2) + Mpt(2,3) = 1
 MptBienDefinieLignes(3): + Mpt(3,1) + Mpt(3,2) + Mpt(3,3) = 1
 MptBienDefinieColonnes(1): + Mpt(1,1) + Mpt(2,1) + Mpt(3,1) = 1
 MptBienDefinieColonnes(2): + Mpt(1,2) + Mpt(2,2) + Mpt(3,2) = 1
 MptBienDefinieColonnes(3): + Mpt(1,3) + Mpt(2,3) + Mpt(3,3) = 1

Bounds
 0 <= Mpt(1,1) <= 1
 0 <= Mpt(1,2) <= 1
 0 <= Mpt(1,3) <= 1
 0 <= Mpt(2,1) <= 1
 0 <= Mpt(2,2) <= 1
 0 <= Mpt(2,3) <= 1
 0 <= Mpt(3,1) <= 1
 0 <= Mpt(3,2) <= 1
 0 <= Mpt(3,3) <= 1

Generals
 Mpt(1,1)
 Mpt(1,2)
 Mpt(1,3)
 Mpt(2,1)
 Mpt(2,2)
 Mpt(2,3)
 Mpt(3,1)
 Mpt(3,2)
 Mpt(3,3)

End
