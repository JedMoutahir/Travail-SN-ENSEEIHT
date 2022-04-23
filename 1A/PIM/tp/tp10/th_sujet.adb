with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
--with SDA_Exceptions; 		use SDA_Exceptions;

--! Les Unbounded_String ont une capacité variable, contrairement au String
--! pour lesquelles une capacité doit être fixée.
with TH;

procedure TH_sujet is

    function Hachage(s : in Unbounded_String) return Integer is
    begin
        return Length(s) mod 11 + 1;
    end;

    package TH_Hachage is
            new TH (T_Cle => Unbounded_String, T_Donnee => Integer, Capacite => 11, Hachage => Hachage);
    use TH_Hachage;

	-- Retourner une chaîne avec des guillemets autour de S
	function Avec_Guillemets (S: Unbounded_String) return String is
	begin
		return '"' & To_String (S) & '"';
	end;


	-- Surcharge l'opérateur unaire "+" pour convertir une String
	-- en Unbounded_String.
	-- Cette astuce permet de simplifier l'initialisation
	-- de cles un peu plus loin.
	function "+" (Item : in String) return Unbounded_String
		renames To_Unbounded_String;


	-- Afficher une Unbounded_String et un entier.
	procedure Afficher (S : in Unbounded_String; N: in Integer) is
	begin
		Put (Avec_Guillemets (S));
		Put (" : ");
		Put (N, 1);
		New_Line;
	end Afficher;

	-- Afficher la Sda.
	procedure Afficher is
		new Pour_Chaque (Afficher);

    Sda : T_TH;

begin
    Put_Line("init : ");
    Initialiser(Sda);
    Put_Line("enrg : ");
    Enregistrer(Sda, +"un", 1);
    Enregistrer(Sda, +"deux", 2);
    Enregistrer(Sda, +"trois", 3);
    Enregistrer(Sda, +"quatre", 4);
    Enregistrer(Sda, +"cinq", 5);
    Enregistrer(Sda, +"quatre-vingt-dix-neuf", 99);
    Enregistrer(Sda, +"vingt-et-un", 21);
    Put_Line("aff : ");
    Afficher(Sda);
    Put_Line("Vider Sda : ");
    Vider(Sda);
    Put_Line ("Fin des tests : OK.");
end TH_sujet;
