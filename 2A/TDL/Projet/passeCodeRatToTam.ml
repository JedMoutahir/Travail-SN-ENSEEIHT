(* Module de la passe de gestion des placements memoire *)
(* doit être conforme à l'interface Passe *)
open Tds
open Ast
open Type
open Tam
open Code
(*
open Filename

 let () = Filename.set_temp_dir_name "/home/jmoutahi/Bureau/2A/TDL/TP02/sourceEtu/tempfortesting" 
*)

type t1 = Ast.AstPlacement.programme
type t2 = string

(* generation_code_affectable : AstPlacement.affectable -> string *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des affectable et genère le code pour l'affectable *)
let rec generation_code_affectable a ecriture deref =
  match a with
  | AstType.Ident ia -> let info = info_ast_to_info ia in
  let (depl, base) = (match info with
    | InfoVar(_, _, dep, base) -> (dep, base)
    | _ -> failwith "InfoVar attendu") in
    let typevarinfoast = (match info with
      | InfoVar(_, t, _, _) ->
        if (est_compatible t Undefined) then failwith "Type Undefined"
        else t
      | _ -> failwith "InfoVar attendu") in
    let taille = getTaille(typevarinfoast) in
    if (est_compatible typevarinfoast (Pointeur(Undefined))) then
      if (ecriture && not deref) then store taille depl base
      else load taille depl base
    else if (not ecriture)
    then load taille depl base
    else store taille depl base
  | AstType.Const(ia) -> let v = (match info_ast_to_info ia with
    | InfoConst(_, v) -> v
    | _ -> failwith "InfoConst attendu") in
    loadl_int (v)
  | AstType.DeRef (da, t) ->
    let taille = getTaille t in
    generation_code_affectable da ecriture true
    ^ (if (ecriture && not deref) then storei taille
    else loadi taille)

(* generation_code_expression : AstPlacement.expression -> string *)
(* Paramètre e : l'expression à analyser *)
(* Génere le code pour l'expression de type AstPlacement.expression *)
let rec generation_code_expression e =
  match e with
  | AstType.Affectable(a) ->
    generation_code_affectable a false false
  | AstType.Booleen(b) ->
    (if b then loadl_int 1
    else loadl_int 0)
    ^ subr "I2B"
  | AstType.Entier(e) -> loadl_int e
  | AstType.Unaire(op, exp) ->
    generation_code_expression exp
    ^ (match op with
      | AstType.Numerateur -> pop 0 1
      | AstType.Denominateur -> pop 1 1)
  | AstType.Binaire(op, eg, ed) -> 
    generation_code_expression eg
    ^ generation_code_expression ed
    ^ (match op with
      | AstType.PlusInt -> subr "IAdd"
      | AstType.PlusRat -> call "LB" "RAdd"
      | AstType.MultInt -> subr "IMul"
      | AstType.MultRat -> call "LB" "RMul"
      | AstType.Fraction -> call "LB" "Norm"
      | AstType.EquBool -> subr "IEq"
      | AstType.EquInt -> subr "IEq"
      | AstType.Inf -> subr "ILss")
  | AstType.AppelFonction(ia, le) -> 
    let nom = (match info_ast_to_info ia with
      | InfoFun (n,_,_) -> n
      | _ -> failwith "Erreur dans generation_code_expression") in
    String.concat "" (List.map generation_code_expression le)
    ^ call "LB" nom
  | AstType.Ternaire (c, e1, e2) ->
    let lelse = getEtiquette() in
    let lend = getEtiquette() in
    generation_code_expression c
    ^ jumpif 0 lelse
    ^ generation_code_expression e1
    ^ jump lend
    ^ label lelse
    ^ generation_code_expression e2
    ^ label lend
  | AstType.New t ->
    let taille = getTaille t in
    loadl_int taille
    ^ subr "MAlloc"
  | AstType.Adresse ia ->
    let (depl, reg) = (match info_ast_to_info ia with
      | InfoVar(_, _, dep, base) -> (dep, base)
      | _ -> failwith "InfoVar attendu") in
    loada depl reg
  | AstType.Null ->
    loadl_int 0

(* generation_code_instruction : AstPlacement.instruction -> string *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des instructions et genère le code pour l'instruction *)
let rec generation_code_instruction lloop i =
  match i with
  | AstPlacement.Declaration (info, e) -> let (dep, base) = 
    (match info_ast_to_info info with
      | InfoVar(_, _, dep, base) -> (dep, base)
      | _ -> failwith "Erreur dans generation_code_instruction")
    in let taille = getTaille (
      match info_ast_to_info info with
        | InfoVar(_, t, _, _) ->
          if (t = Undefined) then failwith "Type Undefined"
          else t
        | _ -> failwith "Pas un InfoVar"
      )
    in generation_code_expression e
    ^ loada dep base
    ^ storei taille
  | AstPlacement.Affectation (a,e) ->
    generation_code_expression e
    ^ generation_code_affectable a true false
  | AstPlacement.AffichageInt e ->
    generation_code_expression e
    ^ subr "IOut"
  | AstPlacement.AffichageRat e -> 
    generation_code_expression e
    ^ call "LB" "ROut"
  | AstPlacement.AffichageBool e -> 
    generation_code_expression e
    ^ subr "BOut"
  | AstPlacement.Conditionnelle (e,b1,b2) ->
    let lelse = getEtiquette() in
    let lend = getEtiquette() in
    generation_code_expression e
    ^ jumpif 0 lelse
    ^ generation_code_bloc lloop b1
    ^ jump lend
    ^ label lelse
    ^ generation_code_bloc lloop b2
    ^ label lend
  | AstPlacement.TantQue (e,b) -> 
    let etlloop = getEtiquette() in
    let lend = getEtiquette() in 
    label etlloop
    ^ generation_code_expression e
    ^ jumpif 0 lend
    ^ generation_code_bloc lloop b
    ^ jump etlloop
    ^ label lend
  | AstPlacement.Retour (e, t_ret, param) -> 
    generation_code_expression e
    ^ return t_ret param
  | AstPlacement.Empty -> ""
  | AstPlacement.AffichagePointeur e ->
    loadl_int 0
    ^ subr "IOut"
    ^ loadl_char 'x'
    ^ subr "COut"
    ^ generation_code_expression e
    ^ subr "IOut"
  | AstPlacement.Loop (n, li) ->
    let lend = getEtiquette() in
    let lbeg = n ^ lend in
    label lbeg
    ^ generation_code_bloc ((n, lend)::lloop) li
    ^ jump lbeg
    ^ label lend
  | AstPlacement.Continue (n) ->
    let (lbeg, lend) =
      (if (n = "") then List.hd lloop
      else List.find (fun x -> (fst x) = n) lloop) in
    jump (lbeg ^ lend)
  | AstPlacement.Break (n) ->
    let (_, lend) =
      (if (n = "") then List.hd lloop
      else List.find (fun x -> (fst x) = n) lloop) in
    jump (lend)

(* generation_code_bloc : AstPlacement.bloc -> string *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des blocs et genère le code pour le bloc *)
and generation_code_bloc lloop (li, taille) =
  push taille
  ^ String.concat "" (List.map (generation_code_instruction lloop) li)
  ^ pop 0 taille


(* generation_code_fonction : AstPlacement.fonction -> string *)
(* Paramètre fun : la fonction à analyser *)
(* Vérifie la bonne utilisation des fonctions et genère le code pour la fonction *)
let generation_code_fonction (AstPlacement.Fonction (info, _, bloc)) =
  let (nom, typlist) = (match info_ast_to_info info with
      | InfoFun (n,_,tl) -> n, tl
      | _ -> failwith "Erreur dans generation_code_expression") in
  let taille = List.fold_right (+) (List.map (fun t -> (getTaille t)) typlist) 0 in
  label nom
  ^ generation_code_bloc [] bloc
  ^ return 0 taille

(* analyser : AstPlacement.programme -> string *)
(* Paramètre : le programme à analyser *)
(* Génere le code pour le programme de type AstPlacement.programme *)
let analyser (AstPlacement.Programme (fonctions,prog)) =
  getEntete()
  ^ String.concat "" (List.map (generation_code_fonction) fonctions)
  ^ label "main"
  ^ generation_code_bloc [] prog 
  ^ halt