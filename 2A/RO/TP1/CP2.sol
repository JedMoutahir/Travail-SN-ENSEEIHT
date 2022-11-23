Problem:    
Rows:       8
Columns:    6 (6 integer, 0 binary)
Non-zeros:  12
Status:     INTEGER OPTIMAL
Objective:  CoutUnitaire = 10 (MINimum)

   No.   Row name        Activity     Lower bound   Upper bound
------ ------------    ------------- ------------- -------------
     1 demandeServie(1)
                                  -3            -3             = 
     2 demandeServie(2)
                                  -3            -3             = 
     3 stockMax(1,1)
                                   2                         2.5 
     4 stockMax(1,2)
                                   1                           1 
     5 stockMax(2,1)
                                   1                           1 
     6 stockMax(2,2)
                                   1                           2 
     7 stockMax(3,1)
                                   0                           2 
     8 stockMax(3,2)
                                   1                           1 

   No. Column name       Activity     Lower bound   Upper bound
------ ------------    ------------- ------------- -------------
     1 Mquantite(1,1)
                    *              2             0               
     2 Mquantite(2,1)
                    *              1             0               
     3 Mquantite(3,1)
                    *              0             0               
     4 Mquantite(1,2)
                    *              1             0               
     5 Mquantite(2,2)
                    *              1             0               
     6 Mquantite(3,2)
                    *              1             0               

Integer feasibility conditions:

KKT.PE: max.abs.err = 0.00e+00 on row 0
        max.rel.err = 0.00e+00 on row 0
        High quality

KKT.PB: max.abs.err = 0.00e+00 on row 0
        max.rel.err = 0.00e+00 on row 0
        High quality

End of output
