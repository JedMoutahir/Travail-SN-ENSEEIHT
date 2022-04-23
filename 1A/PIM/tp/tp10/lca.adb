with Ada.Text_IO;            use Ada.Text_IO;
-- with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is

    procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Noeud, Name => T_LCA);

    procedure Initialiser(Sda: out T_LCA) is
    begin
        Sda := null;
    end Initialiser;


    function Est_Vide (Sda : T_LCA) return Boolean is
    begin
        return Sda = null;
    end;


    function Taille (Sda : in T_LCA) return Integer is
    begin
        if(Sda = null) then
            return 0;
        end if;
        return 1 + Taille(Sda.all.Sous_Arbre);
    end Taille;


    procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Donnee : in T_Donnee) is
    begin
        if(Sda = null) then
            Sda := new T_Noeud'(Cle, Donnee, null);
        elsif(Sda.all.Cle = Cle) then
            Sda.all.Donnee := Donnee;
        else
            Enregistrer(Sda.all.Sous_Arbre, Cle, Donnee);
        end if;
    end Enregistrer;


    function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean is
    begin
        if(Sda = null) then
            return False;
        elsif Sda.Cle = Cle then
            return True;
        else
            return Cle_Presente(Sda.all.Sous_Arbre, Cle);
        end if;
    end;


    function La_Donnee (Sda : in T_LCA ; Cle : in T_Cle) return T_Donnee is
    begin
        if(Sda = null) then
            raise Cle_Absente_Exception;
        end if;
        if(Sda.all.Cle = Cle) then
            return Sda.all.Donnee;
        else
            return La_Donnee(Sda.all.Sous_Arbre, Cle);
        end if;
    end La_Donnee;


    procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
        Sda_temp : T_LCA;
    begin
        Sda_temp := Sda;
        if(Sda = null) then
            raise Cle_Absente_Exception;
        end if;
        if(Sda.all.Cle = Cle) then
            Sda := Sda.all.Sous_Arbre;
            Free(Sda_temp);
        else
            Supprimer(Sda.all.Sous_Arbre, Cle);
        end if;
    end Supprimer;


    procedure Vider (Sda : in out T_LCA) is
    begin
        if(not Est_Vide(Sda)) then
            Vider(Sda.all.Sous_Arbre);
        end if;
        Free(Sda);
    end Vider;

    procedure Pour_Chaque (Sda : in T_LCA) is
    begin
        if Sda = null then
            null;
        else
            begin
                Traiter(Sda.all.Cle, Sda.all.Donnee);
            exception when others => null; --Put_Line("erreur traitement");
            end;
            Pour_Chaque(Sda.all.Sous_Arbre);
        end if;
    end Pour_Chaque;


end LCA;
