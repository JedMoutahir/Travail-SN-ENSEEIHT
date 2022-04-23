with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.Command_Line;     use Ada.Command_Line;
with SDA_Exceptions;       use SDA_Exceptions;
with Alea;
with TH;

-- Évaluer la qualité du générateur aléatoire et les TH.
procedure Evaluer_Alea_TH is


    -- Afficher l'usage.
    procedure Afficher_Usage is
    begin
        New_Line;
        Put_Line ("Usage : " & Command_Name & " Borne Taille");
        New_Line;
        Put_Line ("   Borne  : les nombres sont tirés dans l'intervalle 1..Borne");
        Put_Line ("   Taille : la taille de l'échantillon");
        New_Line;
    end Afficher_Usage;


    -- Afficher le Nom et la Valeur d'une variable.
    -- La Valeur est affichée sur la Largeur_Valeur précisée.
    procedure Afficher_Variable (Nom: String; Valeur: in Integer; Largeur_Valeur: in Integer := 1) is
    begin
        Put (Nom);
        Put (" : ");
        Put (Valeur, Largeur_Valeur);
        New_Line;
    end Afficher_Variable;

    -- Évaluer la qualité du générateur de nombre aléatoire Alea sur un
    -- intervalle donné en calculant les fréquences absolues minimales et
    -- maximales des entiers obtenus lors de plusieurs tirages aléatoires.
    --
    -- Paramètres :
    -- 	  Borne: in Entier	-- le nombre aléatoire est dans 1..Borne
    -- 	  Taille: in Entier -- nombre de tirages (taille de l'échantillon)
    -- 	  Min, Max: out Entier -- fréquence minimale et maximale
    --
    -- Nécessite :
    --    Borne > 1
    --    Taille > 1
    --
    -- Assure : -- poscondition peu intéressante !
    --    0 <= Min Et Min <= Taille
    --    0 <= Max Et Max <= Taille
    --    Min /= Max ==> Min + Max <= Taille
    --
    -- Remarque : On ne peut ni formaliser les 'vraies' postconditions,
    -- ni écrire de programme de test car on ne maîtrise par le générateur
    -- aléatoire.  Pour écrire un programme de test, on pourrait remplacer
    -- le générateur par un générateur qui fournit une séquence connue
    -- d'entiers et pour laquelle on pourrait déterminer les données
    -- statistiques demandées.
    -- Ici, pour tester on peut afficher les nombres aléatoires et refaire
    -- les calculs par ailleurs pour vérifier que le résultat produit est
    -- le bon.
    procedure Calculer_Statistiques (
                                     Borne    : in Integer;  -- Borne supérieur de l'intervalle de recherche
                                     Taille   : in Integer;  -- Taille de l'échantillon
                                     Min, Max : out Integer  -- min et max des fréquences de l'échantillon
                                    ) with
            Pre => Borne > 1 and Taille > 1,
            Post => 0 <= Min and Min <= Taille
            and 0 <= Max and Max <= Taille
            and (if Min /= Max then Min + Max <= Taille)
    is
        function Hachage(n : in Integer) return Integer is
        begin
            return n mod 1000 + 1;
        end;

        package TH_Integer is
                new TH (T_Cle => Integer, T_Donnee => Integer, Capacite => 1000, Hachage => Hachage);
        use TH_Integer;

        Sda : T_TH;

        package Mon_Alea is
                new Alea (1, Borne);
        use Mon_Alea;



        -- Afficher une Unbounded_String et un entier.
        procedure Afficher (S : in Integer; N: in Integer) is
        begin
            Put (s, 1);
            Put (" : ");
            Put (N, 1);
            New_Line;
        end Afficher;

        -- Afficher la Sda.
        procedure Afficher is
                new Pour_Chaque (Afficher);


        procedure Remplir(Sda : in out T_TH) is
            nbAlea : Integer;
            nbTemp : Integer;
        begin
            for i in 1..Taille loop
                Mon_Alea.Get_Random_Number(nbAlea);
                Enregistrer(Sda, i, nbAlea);
            end loop;
        end Remplir;

        procedure Calculer_min_et_max(Sda : T_TH ; min : out Integer ; max : out Integer) is
            Donnee_Temp : Integer;
        begin
            min := La_Donnee(Sda, 1);
            max := La_Donnee(Sda, 1);
            for i in 1..Taille loop
                Donnee_Temp := La_Donnee(Sda, i);
                if(Donnee_Temp < min) then
                    min := Donnee_Temp;
                end if;
                if(Donnee_Temp > max) then
                    max := Donnee_Temp;
                end if;
            end loop;
        end Calculer_min_et_max;

        procedure Calculer_occurence_min_et_max(Sda : in out T_TH ; occMin : in out Integer ; occMax : in out Integer) is
            Donnee_Temp, min, max : Integer;
        begin
            min := La_Donnee(Sda, 1);
            max := La_Donnee(Sda, 1);
            for i in 1..Taille loop
                Donnee_Temp := La_Donnee(Sda, i);
                if(Donnee_Temp < min) then
                    min := Donnee_Temp;
                    occMin := 0;
                end if;
                if(Donnee_Temp > max) then
                    max := Donnee_Temp;
                    occMax := 0;
                end if;
                if(Donnee_Temp = min) then
                    occMin := occMin + 1;
                end if;
                if(Donnee_Temp = max) then
                    occMax := occMax + 1;
                end if;
            end loop;
        end Calculer_occurence_min_et_max;
    begin
        Initialiser(Sda);
        Remplir(Sda);
        --Afficher(Sda);
        Min := 0;
        Max := 0;
        Calculer_occurence_min_et_max(Sda, Min, Max);
    end Calculer_Statistiques;



    Min, Max: Integer; -- fréquence minimale et maximale d'un échantillon
    Borne: Integer;    -- les nombres aléatoire sont tirés dans 1..Borne
    Taille: integer;   -- nombre de tirages aléatoires
begin
    if Argument_Count /= 2 then
        Afficher_Usage;
    else
        -- Récupérer les arguments de la ligne de commande
        Borne := Integer'Value (Argument (1));
        Taille := Integer'Value (Argument (2));

        -- Afficher les valeur de Borne et Taille
        Afficher_Variable ("Borne ", Borne);
        Afficher_Variable ("Taille", Taille);

        Calculer_Statistiques (Borne, Taille, Min, Max);

        -- Afficher les fréquence Min et Max
        Afficher_Variable ("Min", Min);
        Afficher_Variable ("Max", Max);
    end if;
end Evaluer_Alea_TH;
