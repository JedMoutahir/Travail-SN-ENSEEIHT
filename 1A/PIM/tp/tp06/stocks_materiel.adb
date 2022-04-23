with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

-- Auteur: 
-- Gérer un stock de matériel informatique.
--
package body Stocks_Materiel is

    procedure Creer (Stock : out T_Stock) is
    begin
        Stock.Taille := 0;
    end Creer;


    function Nb_Materiels (Stock: in T_Stock) return Integer is
    begin
        return Stock.Taille;
    end;
    
    function Nb_Materiels_HE (Stock: in T_Stock) return Integer is
        Nb_HE : Integer;
    begin
        Nb_HE := 0;
        for i in 1..Stock.Taille loop
            if (Stock.Elements(i).Etat = False) then
                Nb_HE := Nb_HE + 1;
            end if;
        end loop;
        return Nb_HE;
    end;


    procedure Enregistrer (
            Stock        : in out T_Stock;
            Numero_Serie : in     Integer;
            Nature       : in     T_Nature;
            Annee_Achat  : in     Integer
                          ) is
        Materiel : T_Materiel;
    begin
        Materiel.Numero_Serie := Numero_Serie;
        Materiel.Nature := Nature;
        Materiel.Annee_Achat := Annee_Achat;
        Materiel.Etat := True;
        Stock.Elements(Nb_Materiels(Stock)+1) := Materiel;
        Stock.Taille := Stock.Taille + 1;
    end;


end Stocks_Materiel;
