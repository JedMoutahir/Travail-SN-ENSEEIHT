(* Module de la passe de gestion des placements memoire *)
(* doit être conforme à l'interface Passe *)

open Tds
open Ast
open Type

type t1 = Ast.AstType.programme
type t2 = Ast.AstPlacement.programme

(* analyse_placement_instruction : AstType.instruction -> AstPlacement.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Paramètre reg : reference dans la pile *)
(* Paramètre dep : deplacement par rapport à la reference *)
(* Tranforme l'instruction en une instruction de type AstPlacement.instruction *)
let rec analyse_placement_instruction i reg dep =
  match i with
  | AstType.Declaration (info, e) ->
    begin
      (match (info_ast_to_info info) with
      | InfoVar(_, t, _, _) -> 
        (modifier_adresse_variable dep reg info;
        (AstPlacement.Declaration(info, e), getTaille t))
      | _ -> failwith "Erreur dans analyse_placement_instruction")
    end
  | AstType.Affectation (info,e) ->
        (AstPlacement.Affectation(info, e), 0)
  | AstType.AffichageInt e ->
      (AstPlacement.AffichageInt e, 0)
  | AstType.AffichageRat e ->
    (AstPlacement.AffichageRat e, 0)
  | AstType.AffichageBool e ->
    (AstPlacement.AffichageBool e, 0)
  | AstType.AffichagePointeur(e) -> 
    (AstPlacement.AffichagePointeur(e), 0)
  | AstType.Conditionnelle (e,b1,b2) ->
    let newb1 = analyse_placement_bloc b1 dep reg in
    let newb2 = analyse_placement_bloc b2 dep reg in
    (AstPlacement.Conditionnelle(e, newb1, newb2), 0)
  | AstType.TantQue (e,b) ->
    let newb = analyse_placement_bloc b dep reg in
    (AstPlacement.TantQue (e, newb), 0)
  | AstType.Retour (e, info) ->
      begin
        (match (info_ast_to_info info) with
        | InfoFun(_,typ,lp) -> 
          (AstPlacement.Retour (e, getTaille typ, List.fold_left (+) 0 (List.map getTaille lp)), 0)
        | _ -> failwith "Erreur dans analyse_placement_instruction")
      end
  | AstType.Empty -> AstPlacement.Empty, 0
  | AstType.Loop (n, li) ->
    let nli = analyse_placement_bloc li dep reg in
    (AstPlacement.Loop (n, nli), 0)
  | AstType.Continue (n) -> (AstPlacement.Continue (n), 0)
  | AstType.Break (n) -> (AstPlacement.Break (n), 0)

(* analyse_placement_bloc : AstType.bloc -> AstPlacement.bloc *)
(* Paramètre li : liste d'instructions à analyser *)
(* Paramètre reg : reference dans la pile *)
(* Paramètre dep : deplacement par rapport à la reference *)
(* Tranforme le bloc en un bloc de type AstPlacement.bloc *)
and analyse_placement_bloc li dep reg =
match li with
    | [] -> ([], 0)
    | i::qi -> let (ni, taille) = (analyse_placement_instruction i reg dep) in 
    let (nli, tli) = analyse_placement_bloc qi (dep + taille) reg in
    (ni::nli , taille + tli)

(* analyse_placement_fonction : AstType.fonction -> AstPlacement.fonction *)
(* Paramètre fun : la fonction à analyser *)
(* Tranforme la fonction en une fonction de type AstPlacement.fonction *)
let analyse_placement_fonction (AstType.Fonction (info, linfo, bloc)) =
  let rec modifier_adresse_variable_param li depl =
    match li with
    | [] -> ();
    | t::q -> 
      match (info_ast_to_info t) with
      | InfoVar(_,typ,_,_) -> 
        modifier_adresse_variable (depl-(getTaille typ)) "LB" t;
        modifier_adresse_variable_param q (depl-(getTaille typ));
      | _ -> failwith "Erreur dans analyse_placement_fonction"
  in

  let (nb,tb) = analyse_placement_bloc bloc 3 "LB" in
  modifier_adresse_variable_param (List.rev linfo) 0;

  AstPlacement.Fonction(info, linfo, (nb, tb))

(* analyser : AstType.programme -> AstPlacement.programme *)
(* Paramètre : le programme à analyser *)
(* Tranforme le programme en un programme de type AstPlacement.programme *)
let analyser (AstType.Programme (fonctions,prog)) =
  let newfun = (List.map analyse_placement_fonction fonctions) in
  let newbloc = (analyse_placement_bloc prog 0 "SB") in
  AstPlacement.Programme(newfun, newbloc)