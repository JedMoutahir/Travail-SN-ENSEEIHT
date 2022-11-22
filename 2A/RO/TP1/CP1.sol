Problem:    
Rows:       8
Columns:    6
Non-zeros:  12
Status:     OPTIMAL
Objective:  CoutUnitaire = 9.5 (MINimum)

   No.   Row name   St   Activity     Lower bound   Upper bound    Marginal
------ ------------ -- ------------- ------------- ------------- -------------
     1 demandeServie(1)
                    NS            -3            -3             =            -2 
     2 demandeServie(2)
                    NS            -3            -3             =            -3 
     3 stockMax(1,1)
                    NU           2.5                         2.5            -1 
     4 stockMax(1,2)
                    NU             1                           1            -2 
     5 stockMax(2,1)
                    B            0.5                           1 
     6 stockMax(2,2)
                    B              1                           2 
     7 stockMax(3,1)
                    B              0                           2 
     8 stockMax(3,2)
                    NU             1                           1            -1 

   No. Column name  St   Activity     Lower bound   Upper bound    Marginal
------ ------------ -- ------------- ------------- ------------- -------------
     1 Mquantite(1,1)
                    B            2.5             0               
     2 Mquantite(2,1)
                    B            0.5             0               
     3 Mquantite(3,1)
                    NL             0             0                           1 
     4 Mquantite(1,2)
                    B              1             0               
     5 Mquantite(2,2)
                    B              1             0               
     6 Mquantite(3,2)
                    B              1             0               

Karush-Kuhn-Tucker optimality conditions:

KKT.PE: max.abs.err = 0.00e+00 on row 0
        max.rel.err = 0.00e+00 on row 0
        High quality

KKT.PB: max.abs.err = 0.00e+00 on row 0
        max.rel.err = 0.00e+00 on row 0
        High quality

KKT.DE: max.abs.err = 0.00e+00 on column 0
        max.rel.err = 0.00e+00 on column 0
        High quality

KKT.DB: max.abs.err = 0.00e+00 on row 0
        max.rel.err = 0.00e+00 on row 0
        High quality

End of output
