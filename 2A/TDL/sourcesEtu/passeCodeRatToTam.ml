(* Module de la passe de gestion des placements memoire *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type
open Tam
open Code

type t1 = Ast.AstPlacement.programme
type t2 = string

(* analyse_placement_expression : AstType.expression -> AstPlacement.expression *)
(* Paramètre e : l'expression à analyser *)
(* Génere le code pour l'expression de type AstPlacement.expression *)
let rec generation_code_expression e =
  match e with
  | AstType.Ident(info) -> let (dep, base) = 
  match info_ast_to_info info with
    | InfoVar(_, _, dep, base) -> (dep, base)
    | _ -> failwith "Erreur dans generation_code_instruction"
  in let taille = getTaille (
    match info_ast_to_info info with
      | InfoVar(_, t, _, _) ->
        if (t = Undefined) then failwith "Type Undefined"
        else t
      | _ -> failwith "Pas un InfoVar"
    )
  in loada dep base
  ^ loadi taille
  | AstType.Booleen(b) ->
    if b then loadl_int 1
    else loadl_int 0
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
      | AstType.PlusRat -> call "SB" "RAdd"
      | AstType.MultInt -> subr "IMul"
      | AstType.MultRat -> call "SB" "RMul"
      | AstType.Fraction -> ""
      | AstType.EquBool -> subr "IEq"
      | AstType.EquInt -> subr "IEq"
      | AstType.Inf -> subr "ILeq")
  | AstType.AppelFonction(ia, le) -> ""

(* analyse_placement_instruction : AstType.instruction -> AstPlacement.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Paramètre reg : l'instruction à analyser *)
(* Paramètre dep : l'instruction à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'instruction
en une instruction de type AstType.instruction *)
(* Erreur si mauvaise utilisation des types *)
let rec generation_code_instruction i =
  match i with
  | AstPlacement.Affectation (info,e) | AstPlacement.Declaration (info, e) -> let (dep, base) = 
    match info_ast_to_info info with
      | InfoVar(_, _, dep, base) -> (dep, base)
      | _ -> failwith "Erreur dans generation_code_instruction"
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
  | AstPlacement.AffichageInt e ->
    generation_code_expression e
    ^ subr "IOut"
  | AstPlacement.AffichageRat e -> 
    generation_code_expression e
    ^ call "RO" "ROut"
  | AstPlacement.AffichageBool e -> 
    generation_code_expression e
    ^ subr "BOut"
  | AstPlacement.Conditionnelle (e,b1,b2) ->
    let lelse = getEtiquette() in
    let lend = getEtiquette() in
    generation_code_expression e
    ^ jumpif 0 lelse
    ^ generation_code_bloc b1
    ^ jump lend
    ^ label lelse
    ^ generation_code_bloc b2
    ^ label lend
  | AstPlacement.TantQue (e,b) -> 
    let lloop = getEtiquette() in
    let lend = getEtiquette() in 
    label lloop
    ^ generation_code_expression e
    ^ jumpif 0 lend
    ^ generation_code_bloc b
    ^ jump lloop
    ^ label lend
  | AstPlacement.Retour (e, t_ret, param) -> 
    generation_code_expression e
    ^ return t_ret param
  | AstPlacement.Empty -> ""

(* analyse_type_bloc : AstTds.bloc -> AstType.bloc *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des types et tranforme le bloc en un bloc de type AstType.bloc *)
(* Erreur si mauvaise utilisation des types *)
and generation_code_bloc (li, taille) =
  push taille
  ^ String.concat "" (List.map (generation_code_instruction) li)
  ^ pop 0 taille
(* analyse_placement_fonction : AstType.fonction -> AstPlacementfonction *)
(* Paramètre fun : la fonction à analyser *)
(* Tranforme la fonction en une fonction de type AstPlacement.fonction *)
let generation_code_fonction (AstPlacement.Fonction (info, linfo, bloc)) =
  ""

(* analyser : AstType.programme -> AstPlacement.programme *)
(* Paramètre : le programme à analyser *)
(* Tranforme le programme en un programme de type AstPlacement.programme *)
let analyser (AstPlacement.Programme (fonctions,prog)) =
  getEntete()
  ^ String.concat "" (List.map (generation_code_fonction) fonctions)
  ^ label "main"
  ^ generation_code_bloc prog 
  ^ halt