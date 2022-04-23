with Ada.Text_IO;
with Huffman;
procedure Test_Huffman is
   package Char_Natural_Huffman_Tree is new Huffman
     (Put => Ada.Text_IO.Put,
      Symbol_Sequence => String);
   Tree         : Char_Natural_Huffman_Tree.Huffman_Tree;
   Frequencies  : Char_Natural_Huffman_Tree.Frequency_Maps.Map;
   Input_String : constant String :=
     "exemple de texte";
begin
   -- build frequency map
   for I in Input_String'Range loop
      declare
         use Char_Natural_Huffman_Tree.Frequency_Maps;
         Position : constant Cursor := Frequencies.Find (Input_String (I));
      begin
         if Position = No_Element then
            Frequencies.Insert (Key => Input_String (I), New_Item => 1);
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
   Ada.Text_IO.Put("new code for each character :");
   Ada.Text_IO.New_Line;
   Char_Natural_Huffman_Tree.Dump_Encoding (Tree => Tree);
 
   -- encode example string
   declare
      Code : constant Char_Natural_Huffman_Tree.Bit_Sequence :=
        Char_Natural_Huffman_Tree.Encode
          (Tree    => Tree,
           Symbols => Input_String);
   begin
      --encode stirng
      Ada.Text_IO.Put("encoded string :");
      Ada.Text_IO.New_Line;
      Char_Natural_Huffman_Tree.Put (Code);
      
      --decode string
      Ada.Text_IO.Put("decoded string :");
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line
        (Char_Natural_Huffman_Tree.Decode (Tree => Tree, Code => Code));
   end;
end Test_Huffman;
