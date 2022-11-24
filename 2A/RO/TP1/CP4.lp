\* Problem: CP4 *\

Minimize
 total: + Choix(1,2) + Choix(1,3) + 10 Choix(1,4) + 12 Choix(1,5)
 + 12 Choix(1,6) + Choix(2,1) + Choix(2,3) + 8 Choix(2,4)
 + 10 Choix(2,5) + 11 Choix(2,6) + Choix(3,1) + Choix(3,2)
 + 8 Choix(3,4) + 11 Choix(3,5) + 10 Choix(3,6) + 10 Choix(4,1)
 + 8 Choix(4,2) + 8 Choix(4,3) + Choix(4,5) + Choix(4,6) + 12 Choix(5,1)
 + 10 Choix(5,2) + 11 Choix(5,3) + Choix(5,4) + Choix(5,6)
 + 12 Choix(6,1) + 11 Choix(6,2) + 10 Choix(6,3) + Choix(6,4)
 + Choix(6,5)

Subject To
 leave(1): + Choix(1,1) + Choix(1,2) + Choix(1,3) + Choix(1,4)
 + Choix(1,5) + Choix(1,6) = 1
 leave(2): + Choix(2,1) + Choix(2,2) + Choix(2,3) + Choix(2,4)
 + Choix(2,5) + Choix(2,6) = 1
 leave(3): + Choix(3,1) + Choix(3,2) + Choix(3,3) + Choix(3,4)
 + Choix(3,5) + Choix(3,6) = 1
 leave(4): + Choix(4,1) + Choix(4,2) + Choix(4,3) + Choix(4,4)
 + Choix(4,5) + Choix(4,6) = 1
 leave(5): + Choix(5,1) + Choix(5,2) + Choix(5,3) + Choix(5,4)
 + Choix(5,5) + Choix(5,6) = 1
 leave(6): + Choix(6,1) + Choix(6,2) + Choix(6,3) + Choix(6,4)
 + Choix(6,5) + Choix(6,6) = 1
 enter(1): + Choix(1,1) + Choix(2,1) + Choix(3,1) + Choix(4,1)
 + Choix(5,1) + Choix(6,1) = 1
 enter(2): + Choix(1,2) + Choix(2,2) + Choix(3,2) + Choix(4,2)
 + Choix(5,2) + Choix(6,2) = 1
 enter(3): + Choix(1,3) + Choix(2,3) + Choix(3,3) + Choix(4,3)
 + Choix(5,3) + Choix(6,3) = 1
 enter(4): + Choix(1,4) + Choix(2,4) + Choix(3,4) + Choix(4,4)
 + Choix(5,4) + Choix(6,4) = 1
 enter(5): + Choix(1,5) + Choix(2,5) + Choix(3,5) + Choix(4,5)
 + Choix(5,5) + Choix(6,5) = 1
 enter(6): + Choix(1,6) + Choix(2,6) + Choix(3,6) + Choix(4,6)
 + Choix(5,6) + Choix(6,6) = 1
 cap(1,1): - 5 Choix(1,1) + Ventes(1,1) <= -0
 cap(1,2): - 5 Choix(1,2) + Ventes(1,2) <= -0
 cap(1,3): - 5 Choix(1,3) + Ventes(1,3) <= -0
 cap(1,4): - 5 Choix(1,4) + Ventes(1,4) <= -0
 cap(1,5): - 5 Choix(1,5) + Ventes(1,5) <= -0
 cap(1,6): - 5 Choix(1,6) + Ventes(1,6) <= -0
 cap(2,1): - 5 Choix(2,1) + Ventes(2,1) <= -0
 cap(2,2): - 5 Choix(2,2) + Ventes(2,2) <= -0
 cap(2,3): - 5 Choix(2,3) + Ventes(2,3) <= -0
 cap(2,4): - 5 Choix(2,4) + Ventes(2,4) <= -0
 cap(2,5): - 5 Choix(2,5) + Ventes(2,5) <= -0
 cap(2,6): - 5 Choix(2,6) + Ventes(2,6) <= -0
 cap(3,1): - 5 Choix(3,1) + Ventes(3,1) <= -0
 cap(3,2): - 5 Choix(3,2) + Ventes(3,2) <= -0
 cap(3,3): - 5 Choix(3,3) + Ventes(3,3) <= -0
 cap(3,4): - 5 Choix(3,4) + Ventes(3,4) <= -0
 cap(3,5): - 5 Choix(3,5) + Ventes(3,5) <= -0
 cap(3,6): - 5 Choix(3,6) + Ventes(3,6) <= -0
 cap(4,1): - 5 Choix(4,1) + Ventes(4,1) <= -0
 cap(4,2): - 5 Choix(4,2) + Ventes(4,2) <= -0
 cap(4,3): - 5 Choix(4,3) + Ventes(4,3) <= -0
 cap(4,4): - 5 Choix(4,4) + Ventes(4,4) <= -0
 cap(4,5): - 5 Choix(4,5) + Ventes(4,5) <= -0
 cap(4,6): - 5 Choix(4,6) + Ventes(4,6) <= -0
 cap(5,1): - 5 Choix(5,1) + Ventes(5,1) <= -0
 cap(5,2): - 5 Choix(5,2) + Ventes(5,2) <= -0
 cap(5,3): - 5 Choix(5,3) + Ventes(5,3) <= -0
 cap(5,4): - 5 Choix(5,4) + Ventes(5,4) <= -0
 cap(5,5): - 5 Choix(5,5) + Ventes(5,5) <= -0
 cap(5,6): - 5 Choix(5,6) + Ventes(5,6) <= -0
 cap(6,1): - 5 Choix(6,1) + Ventes(6,1) <= -0
 cap(6,2): - 5 Choix(6,2) + Ventes(6,2) <= -0
 cap(6,3): - 5 Choix(6,3) + Ventes(6,3) <= -0
 cap(6,4): - 5 Choix(6,4) + Ventes(6,4) <= -0
 cap(6,5): - 5 Choix(6,5) + Ventes(6,5) <= -0
 cap(6,6): - 5 Choix(6,6) + Ventes(6,6) <= -0
 node(1): - Ventes(1,2) - Ventes(1,3) - Ventes(1,4) - Ventes(1,5)
 - Ventes(1,6) + Ventes(2,1) + Ventes(3,1) + Ventes(4,1) + Ventes(5,1)
 + Ventes(6,1) = -5
 node(2): + Ventes(1,2) - Ventes(2,1) - Ventes(2,3) - Ventes(2,4)
 - Ventes(2,5) - Ventes(2,6) + Ventes(3,2) + Ventes(4,2) + Ventes(5,2)
 + Ventes(6,2) = 1
 node(3): + Ventes(1,3) + Ventes(2,3) - Ventes(3,1) - Ventes(3,2)
 - Ventes(3,4) - Ventes(3,5) - Ventes(3,6) + Ventes(4,3) + Ventes(5,3)
 + Ventes(6,3) = 1
 node(4): + Ventes(1,4) + Ventes(2,4) + Ventes(3,4) - Ventes(4,1)
 - Ventes(4,2) - Ventes(4,3) - Ventes(4,5) - Ventes(4,6) + Ventes(5,4)
 + Ventes(6,4) = 1
 node(5): + Ventes(1,5) + Ventes(2,5) + Ventes(3,5) + Ventes(4,5)
 - Ventes(5,1) - Ventes(5,2) - Ventes(5,3) - Ventes(5,4) - Ventes(5,6)
 + Ventes(6,5) = 1
 node(6): + Ventes(1,6) + Ventes(2,6) + Ventes(3,6) + Ventes(4,6)
 + Ventes(5,6) - Ventes(6,1) - Ventes(6,2) - Ventes(6,3) - Ventes(6,4)
 - Ventes(6,5) = 1

Bounds
 0 <= Choix(1,1) <= 1
 0 <= Choix(1,2) <= 1
 0 <= Choix(1,3) <= 1
 0 <= Choix(1,4) <= 1
 0 <= Choix(1,5) <= 1
 0 <= Choix(1,6) <= 1
 0 <= Choix(2,1) <= 1
 0 <= Choix(2,2) <= 1
 0 <= Choix(2,3) <= 1
 0 <= Choix(2,4) <= 1
 0 <= Choix(2,5) <= 1
 0 <= Choix(2,6) <= 1
 0 <= Choix(3,1) <= 1
 0 <= Choix(3,2) <= 1
 0 <= Choix(3,3) <= 1
 0 <= Choix(3,4) <= 1
 0 <= Choix(3,5) <= 1
 0 <= Choix(3,6) <= 1
 0 <= Choix(4,1) <= 1
 0 <= Choix(4,2) <= 1
 0 <= Choix(4,3) <= 1
 0 <= Choix(4,4) <= 1
 0 <= Choix(4,5) <= 1
 0 <= Choix(4,6) <= 1
 0 <= Choix(5,1) <= 1
 0 <= Choix(5,2) <= 1
 0 <= Choix(5,3) <= 1
 0 <= Choix(5,4) <= 1
 0 <= Choix(5,5) <= 1
 0 <= Choix(5,6) <= 1
 0 <= Choix(6,1) <= 1
 0 <= Choix(6,2) <= 1
 0 <= Choix(6,3) <= 1
 0 <= Choix(6,4) <= 1
 0 <= Choix(6,5) <= 1
 0 <= Choix(6,6) <= 1

Generals
 Choix(1,1)
 Choix(1,2)
 Choix(1,3)
 Choix(1,4)
 Choix(1,5)
 Choix(1,6)
 Choix(2,1)
 Choix(2,2)
 Choix(2,3)
 Choix(2,4)
 Choix(2,5)
 Choix(2,6)
 Choix(3,1)
 Choix(3,2)
 Choix(3,3)
 Choix(3,4)
 Choix(3,5)
 Choix(3,6)
 Choix(4,1)
 Choix(4,2)
 Choix(4,3)
 Choix(4,4)
 Choix(4,5)
 Choix(4,6)
 Choix(5,1)
 Choix(5,2)
 Choix(5,3)
 Choix(5,4)
 Choix(5,5)
 Choix(5,6)
 Choix(6,1)
 Choix(6,2)
 Choix(6,3)
 Choix(6,4)
 Choix(6,5)
 Choix(6,6)

End
