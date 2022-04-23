with Ada.Text_IO;            use Ada.Text_IO;
with LCA;
-- wiilleh SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;
package body TH is

    --procedure Free is
    --        new Ada.Unchecked_Deallocation (Object => T_Noeud, Name => T_TH);

    procedure Initialiser(Sda: out T_TH) is
    begin
        for i in 1..Capacite loop
            Initialiser(Sda(i));
        end loop;
    end Initialiser;


    function Est_Vide (Sda : T_TH) return Boolean is
    begin
        for i in 1..Capacite loop
            if(not Est_Vide(Sda(i))) then
                return False;
            end if;
        end loop;
        return True;
    end;


    function Taille (Sda : in T_TH) return Integer is
        Nb_elem : Integer;
    begin
        Nb_elem := 0;
        for i in 1..Capacite loop
            Nb_elem := Nb_elem + Taille(Sda(i));
        end loop;

        return Nb_elem;
    end Taille;


    procedure Enregistrer (Sda : in out T_TH ; Cle : in T_Cle ; Donnee : in T_Donnee) is
    begin
        Enregistrer(Sda(Hachage(Cle)), Cle, Donnee);
    end Enregistrer;


    function Cle_Presente (Sda : in T_TH ; Cle : in T_Cle) return Boolean is
    begin
        return Cle_Presente(Sda(Hachage(Cle)), Cle);
    end;


    function La_Donnee (Sda : in T_TH ; Cle : in T_Cle) return T_Donnee is
    begin
        return La_Donnee(Sda(Hachage(Cle)), Cle);
    end La_Donnee;


    procedure Supprimer (Sda : in out T_TH ; Cle : in T_Cle) is
    begin
        Supprimer(Sda(Hachage(Cle)), Cle);
    end Supprimer;


    procedure Vider (Sda : in out T_TH) is
    begin
        for i in 1..Capacite loop
            Vider(Sda(i));
        end loop;
    end Vider;

    procedure Pour_Chaque (Sda : in T_TH) is
        procedure Traiter_element is
		new LCA_package.Pour_Chaque (Traiter);
    begin
        for i in 1..Capacite loop
            Traiter_element(Sda(i));
        end loop;
    end Pour_Chaque;

end TH;
