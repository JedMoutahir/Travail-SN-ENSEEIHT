with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Vecteurs_Creux;    use Vecteurs_Creux;

-- Exemple d'utilisation des vecteurs creux.
procedure Exemple_Vecteurs_Creux is

    V : T_Vecteur_Creux;
    Epsilon: constant Float := 1.0e-5;
begin
    Put_Line ("Début du scénario");

    -- Initialiser V
    Initialiser(V);
    Put("V = "); Afficher (V); New_Line;

    -- V est nul
    if(Est_Nul(V)) then
        Put("V est nul");
    else
        Put("V est non nul");
    end if;
    New_Line;

    -- Detruire V
    Detruire(V);

    -- Indice 18 nul
    if(Composante_Recursif(V, 18) = 0.0) then
        Put("V[18] = 0.0");
    else
        Put("Erreur");
    end if;
    New_Line;

    -- Modifier V
    for I in 1..5 loop
        Modifier (V, I, Float(I));
    end loop;
    Put("V = "); Afficher (V); New_Line;

    Put_Line ("Fin du scénario");
end Exemple_Vecteurs_Creux;
