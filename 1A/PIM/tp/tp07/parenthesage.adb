with Piles;
with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;

procedure Parenthesage is


    -- L'indice dans la chaîne Meule de l'élément Aiguille.
    -- Si l'Aiguille n'est pas dans la Meule, on retroune Meule'Last + 1.
    Function Index (Meule : in String; Aiguille: Character) return Integer with
        Post => Meule'First <= Index'Result and then Index'Result <= Meule'Last + 1
            and then (Index'Result > Meule'Last or else Meule (Index'Result) = Aiguille)
    is
    begin
        for i in Meule'Range loop
            if(Meule(i) = Aiguille) then
                return i;
            end if;
        end loop;
        return Meule'Last + 1;
    end Index;


    -- Programme de test de Index.
    procedure Tester_Index is
        ABCDEF : constant String := "abcdef";
    begin
        pragma Assert (1 = Index (ABCDEF, 'a'));
        pragma Assert (3 = Index (ABCDEF, 'c'));
        pragma Assert (6 = Index (ABCDEF, 'f'));
        pragma Assert (7 = Index (ABCDEF, 'z'));
        pragma Assert (4 = Index (ABCDEF (1..3), 'z'));
        pragma Assert (3 = Index (ABCDEF (3..5), 'c'));
        pragma Assert (5 = Index (ABCDEF (3..5), 'e'));
        pragma Assert (6 = Index (ABCDEF (3..5), 'a'));
        pragma Assert (6 = Index (ABCDEF (3..5), 'g'));
    end;


    -- Vérifier les bon parenthésage d'une Chaîne (D).  Le sous-programme
    -- indique si le parenthésage est bon ou non (Correct : R) et dans le cas
    -- où il n'est pas correct, l'indice (Indice_Erreur : R) du symbole qui
    -- n'est pas appairé (symbole ouvrant ou fermant).
    --
    -- Exemples
    --   "[({})]"  -> Correct
    --   "]"       -> Non Correct et Indice_Erreur = 1
    --   "((()"    -> Non Correct et Indice_Erreur = 2
    --
    procedure Verifier_Parenthesage (Chaine: in String ; Correct : out Boolean ; Indice_Erreur : out Integer) is

        package Pile_Caractere is
                new Piles (Capacite => Chaine'Length, T_Element => Character);
        use Pile_Caractere;
        package Pile_Integer is
                new Piles (Capacite => Chaine'Length, T_Element => Integer);
        use Pile_Integer;


        Ouvrants : Constant String := "([{";
        Fermants : Constant String := ")]}";
        Pile_Ouvrants : Pile_Caractere.T_Pile;
        Pile_Fermants : Pile_Caractere.T_Pile;
        Pile_Indices_Ouvrants : Pile_Integer.T_Pile;
        Pile_Indices_Fermants : Pile_Integer.T_Pile;
    begin
        Initialiser(Pile_Ouvrants);
        Initialiser(Pile_Fermants);
        Initialiser(Pile_Indices_Ouvrants);
        Initialiser(Pile_Indices_Fermants);
        for i in Chaine'Range loop
            if Chaine(i) = Ouvrants(1) then
                Empiler(Pile_Ouvrants, Ouvrants(1));
                Empiler(Pile_Indices_Ouvrants, i);
            elsif Chaine(i) = Ouvrants(2) then
                Empiler(Pile_Ouvrants, Ouvrants(2));
                Empiler(Pile_Indices_Ouvrants, i);
            elsif Chaine(i) = Ouvrants(3) then
                Empiler(Pile_Ouvrants, Ouvrants(3));
                Empiler(Pile_Indices_Ouvrants, i);
            end if;
        end loop;
        for i in Chaine'Range loop
            if Chaine(Chaine'Last-i+1) = Fermants(1) then
                Empiler(Pile_Fermants, Fermants(1));
                Empiler(Pile_Indices_Fermants, Chaine'Last-i+1);
            elsif Chaine(Chaine'Last-i+1) = Fermants(2) then
                Empiler(Pile_Fermants, Fermants(2));
                Empiler(Pile_Indices_Fermants, Chaine'Last-i+1);
            elsif Chaine(Chaine'Last-i+1) = Fermants(3) then
                Empiler(Pile_Fermants, Fermants(3));
                Empiler(Pile_Indices_Fermants, Chaine'Last-i+1);
            end if;
        end loop;
        while not Est_Vide(Pile_Ouvrants) loop
            if(Index(Ouvrants, Sommet(Pile_Ouvrants)) = Index(Ouvrants, Sommet(Pile_Ouvrants))) then
                Depiler(Pile_Ouvrants);
                Depiler(Pile_Indices_Ouvrants);
                Depiler(Pile_Fermants);
                Depiler(Pile_Indices_Fermants);

            else
                Correct := False;
                Indice_Erreur := Sommet(Pile_Indices_Fermants);
                exit;
            end if;
            if Est_Vide(Pile_Fermants) and not Est_Vide(Pile_Ouvrants) then
                Correct := False;
                Indice_Erreur := Sommet(Pile_Indices_Ouvrants);
                exit;
            end if;
        end loop;
        if Est_Vide(Pile_Fermants) then
            Correct := True;
        else
            Correct := False;
            while not Est_Vide(Pile_Fermants) loop
                Indice_Erreur := Sommet(Pile_Indices_Fermants);
                Depiler(Pile_Fermants);
                Depiler(Pile_Indices_Fermants);
            end loop;
        end if;
    end Verifier_Parenthesage;


    -- Programme de test de Verifier_Parenthesage
    procedure Tester_Verifier_Parenthesage is
        Exemple1 : constant String(1..2) :=  "{}";
        Exemple2 : constant String(11..18) :=  "]{[(X)]}";

        Indice : Integer;   -- Résultat de ... XXX
        Correct : Boolean;
    begin
        Verifier_Parenthesage ("(a < b)", Correct, Indice);
        pragma Assert (Correct);

        Verifier_Parenthesage ("([{a}])", Correct, Indice);
        pragma Assert (Correct);

        Verifier_Parenthesage ("(][{a}])", Correct, Indice);
        pragma Assert (not Correct);
        put(Indice);
        pragma Assert (Indice = 2);

        Verifier_Parenthesage ("]([{a}])", Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 1);

        Verifier_Parenthesage ("([{}])}", Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 7);

        Verifier_Parenthesage ("([{", Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 3);

        Verifier_Parenthesage ("([{}]", Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 1);

        Verifier_Parenthesage ("", Correct, Indice);
        pragma Assert (Correct);

        Verifier_Parenthesage (Exemple1, Correct, Indice);
        pragma Assert (Correct);

        Verifier_Parenthesage (Exemple2, Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 11);

        Verifier_Parenthesage (Exemple2(12..18), Correct, Indice);
        pragma Assert (Correct);

        Verifier_Parenthesage (Exemple2(12..15), Correct, Indice);
        pragma Assert (not Correct);
        pragma Assert (Indice = 14);
    end Tester_Verifier_Parenthesage;

begin
    Tester_Index;
    Tester_Verifier_Parenthesage;
end Parenthesage;
