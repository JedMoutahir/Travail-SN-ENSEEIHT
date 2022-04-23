with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
--with SDA_Exceptions; 		use SDA_Exceptions;

--! Les Unbounded_String ont une capacité variable, contrairement au String
--! pour lesquelles une capacité doit être fixée.
with LCA;

procedure lca_sujet is

    package LCA_String_Integer is
            new LCA (T_Cle => Unbounded_String, T_Donnee => Integer);
    use LCA_String_Integer;

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

    Sda : T_LCA;

begin
    Put_Line("init : ");
    Initialiser(Sda);
    Put_Line("enrg1 : ");
    Enregistrer(Sda, +"un", 1);
    Put_Line("enrg2 : ");
    Enregistrer(Sda, +"deux", 2);
    Put_Line("aff : ");
    Afficher(Sda);
    if(Cle_Presente(Sda, +"un"))then
        Put_Line("un présent");
    end if;
    Enregistrer(Sda, +"un", 3);
    Put(La_Donnee(Sda, +"un"), 1);
    New_Line;
    Put_Line("supp enrg1 : ");
    Supprimer(Sda, +"un");
    Put_Line("aff : ");
    Afficher(Sda);
    Put_Line("Vider Sda : ");
    Vider(Sda);
    Put_Line ("Fin des tests : OK.");
end lca_sujet;
