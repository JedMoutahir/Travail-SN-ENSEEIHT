with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Text_IO; use Ada.Text_IO;
with Huffman;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Command_Line; use Ada.Command_Line;

procedure Compresser is
   type T_Octet is mod 2 ** 8;	-- sur 8 bits
   for T_Octet'Size use 8;

   package Char_Natural_Huffman_Tree is new Huffman
     (--Symbol_Type => Character,
      Put => Ada.Text_IO.Put,
      Symbol_Sequence => String);
   
   
   procedure Afficher_Usage is
   begin
      New_Line;
      Put_Line ("Usage : compresser un fichier");
      New_Line;
      Put_Line ("   ./compresser fichier_texte.txt");
      Put_Line ("   ou   ");
      Put_Line ("   ./compresser -b fichier_texte.txt");
      New_Line;
   end Afficher_Usage;


   Tree         : Char_Natural_Huffman_Tree.Huffman_Tree;
   Frequencies  : Char_Natural_Huffman_Tree.Frequency_Maps.Map;
   Input_String : Unbounded_String;
   --File_Name_In : constant String :=  "test.txt";
   --File_Name_Out : constant String :=  "test.txt.huff";
   File      : Ada.Streams.Stream_IO.File_Type;	-- car il y a aussi Ada.Text_IO.File_Type
   S         : Stream_Access;
   c : Character;
   Nom_Fichier_In : Unbounded_String;
   Nom_Fichier_Out : Unbounded_String;
   Extention : constant String := ".hff";

begin
   if Argument_Count > 2 or Argument_Count = 0 then
      Afficher_Usage;
   else
      Put_Line("--------------------------debut de la compression--------------------------");
      New_Line;
      if(Argument_Count = 1) then
         Nom_Fichier_In := To_Unbounded_String(Argument(1));
         Append(Nom_Fichier_Out, Argument(1));
         Append(Nom_Fichier_Out, Extention);
      elsif(Argument(1) = "-b") then
         Nom_Fichier_In := To_Unbounded_String(Argument(2));
         Append(Nom_Fichier_Out, Argument(2));
         Append(Nom_Fichier_Out, Extention);
      else
         Afficher_Usage;
         return;
      end if;
      
      Open(File, In_File, To_String(Nom_Fichier_In));
      S := Stream(File);
      while not End_Of_File(File) loop
         c := Character'Input(S);
         Append(Input_String, c);
      end loop;
      --Put(To_String(Input_String));
      
      Close (File);

      -- build frequency map
      for I in To_String(Input_String)'Range loop
         declare
            use Char_Natural_Huffman_Tree.Frequency_Maps;
            Position : constant Cursor := Frequencies.Find (To_String(Input_String) (I));
         begin
            if Position = No_Element then
               Frequencies.Insert (Key => To_String(Input_String) (I), New_Item => 1);
            else
               Frequencies.Replace_Element
                 (Position => Position,
                  New_Item => Element (Position) + 1);
            end if;
         end;
      end loop;
 
      -- create huffman tree
      Char_Natural_Huffman_Tree.Create_Tree
        (Tree        => Tree,
         Frequencies => Frequencies);
 
      -- dump encodings
      --Char_Natural_Huffman_Tree.Dump_Encoding (Tree => Tree);
 

      -----------------BUILD THE COMPRESSED FILE-----------------   
      Create (File, Out_File, To_String(Nom_Fichier_Out));
   
      S := Stream (File);
    
      -----------------WRITE DATA NECESSARY FOR DECOMPRESSION-----------------
   
      --write frequencies
      Char_Natural_Huffman_Tree.Frequency_Maps.Map'Write(S, Frequencies);

      -----------------WRITE ENCODED FILE-----------------
      declare
         Code : constant Char_Natural_Huffman_Tree.Bit_Sequence := Char_Natural_Huffman_Tree.Encode(Tree    => Tree, Symbols => To_String(Input_String));
         Octet : T_Octet := 0;
         indice_reste : Integer;
      begin
         --Char_Natural_Huffman_Tree.Put (Code);
         --Ada.Text_IO.Put_Line(Char_Natural_Huffman_Tree.Decode (Tree => Tree, Code => Code));
         for k in 0..(Code'Length/8 - 1) loop
            for i in 0..7 loop
               if Code(i+8*k+1) then
                  Octet := Octet + 2**(8-i-1);
                  --Ada.Text_IO.Put("1");
               else
                  --Ada.Text_IO.Put("0");
                  null;
               end if;
            end loop;
            --Ada.Text_IO.Put(Integer'Image(Integer(Octet)));
            T_Octet'Write(S, Octet);
            Octet := 0;
            --Ada.Text_IO.
         end loop;
         indice_reste := Code'Length - Code'Length mod 8 ;--+1;
         for i in 0..7 loop
            if (i + indice_reste) > Code'Length then
               --Ada.Text_IO.Put("0");
               null;
            else
               if Code(i+indice_reste) then
                  Octet := Octet + 2**(8-i-1);
                  --Ada.Text_IO.Put("1");
               else
                  --Ada.Text_IO.Put("0");
                  null;
               end if;
            end if;
         end loop;
         --Ada.Text_IO.Put(Integer'Image(Integer(Octet)));
         T_Octet'Write(S, Octet);
         --Ada.Text_IO.
      end;
      --   Close the file
      Close (File);
      if(Argument_Count = 2) then
         Char_Natural_Huffman_Tree.PutTree(Tree);
      end if;
      
      Put_Line("--------------------------compression finie--------------------------");
      
   end if;

end Compresser;
