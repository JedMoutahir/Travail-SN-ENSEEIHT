Problem:    
Rows:       22
Columns:    18 (18 integer, 6 binary)
Non-zeros:  60
Status:     INTEGER OPTIMAL
Objective:  CoutTotal = 368 (MINimum)

   No.   Row name        Activity     Lower bound   Upper bound
------ ------------    ------------- ------------- -------------
     1 demandeServie(1,1)
                                  -2            -2             = 
     2 demandeServie(1,2)
                                  -1            -1             = 
     3 demandeServie(2,1)
                                   0            -0             = 
     4 demandeServie(2,2)
                                  -3            -3             = 
     5 stockMax(1,1)
                                   1                         2.5 
     6 stockMax(1,2)
                                   1                           1 
     7 stockMax(2,1)
                                   0                           1 
     8 stockMax(2,2)
                                   2                           2 
     9 stockMax(3,1)
                                   2                           2 
    10 stockMax(3,2)
                                   0                           1 
    11 cheminIf1(1,1)
                                   0                          -0 
    12 cheminIf1(1,2)
                                   0                          -0 
    13 cheminIf1(1,3)
                                  -1                          -0 
    14 cheminIf1(2,1)
                                  -1                          -0 
    15 cheminIf1(2,2)
                                  -1                          -0 
    16 cheminIf1(2,3)
                                   0                          -0 
    17 cheminIf2(1,1)
                                   0                          -0 
    18 cheminIf2(1,2)
                                   0                          -0 
    19 cheminIf2(1,3)
                              -1e+08                          -0 
    20 cheminIf2(2,1)
                              -1e+08                          -0 
    21 cheminIf2(2,2)
                              -1e+08                          -0 
    22 cheminIf2(2,3)
                                   0                          -0 

   No. Column name       Activity     Lower bound   Upper bound
------ ------------    ------------- ------------- -------------
     1 Mquantite(1,1,1)
                    *              0             0               
     2 Mquantite(1,2,1)
                    *              0             0               
     3 Mquantite(1,3,1)
                    *              2             0               
     4 Mquantite(2,1,1)
                    *              1             0               
     5 Mquantite(2,2,1)
                    *              0             0               
     6 Mquantite(2,3,1)
                    *              0             0               
     7 Mquantite(1,1,2)
                    *              0             0               
     8 Mquantite(1,2,2)
                    *              0             0               
     9 Mquantite(1,3,2)
                    *              0             0               
    10 Mquantite(2,1,2)
                    *              1             0               
    11 Mquantite(2,2,2)
                    *              2             0               
    12 Mquantite(2,3,2)
                    *              0             0               
    13 MtrajetChoisi(1,1)
                    *              0             0             1 
    14 MtrajetChoisi(1,2)
                    *              0             0             1 
    15 MtrajetChoisi(1,3)
                    *              1             0             1 
    16 MtrajetChoisi(2,1)
                    *              1             0             1 
    17 MtrajetChoisi(2,2)
                    *              1             0             1 
    18 MtrajetChoisi(2,3)
                    *              0             0             1 

Integer feasibility conditions:

KKT.PE: max.abs.err = 0.00e+00 on row 0
        max.rel.err = 0.00e+00 on row 0
        High quality

KKT.PB: max.abs.err = 0.00e+00 on row 0
        max.rel.err = 0.00e+00 on row 0
        High quality

End of output
