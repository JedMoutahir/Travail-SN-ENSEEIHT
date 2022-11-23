\* Probleme Exercice 1 :  Assemblage *\

Maximize
    MargeTotale: + 1000000 L + 900000 S

Subject To
    MaxProdLuxe: + L <= 8
    MaxSurfaceParking: + 10 L + 20 S <= 150
    TempsMax: + 6 L + 5 S <= 60

Generals
    L
    S

End
