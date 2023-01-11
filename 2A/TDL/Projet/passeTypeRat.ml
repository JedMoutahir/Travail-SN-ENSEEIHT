(* Module de la passe de gestion des types *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type

type t1 = Ast.AstTds.programme
type t2 = Ast.AstType.programme

let rec analyse_type_affectable a =
  match a with
  | AstTds.Ident(ia) -> let info = info_ast_to_info ia in
    let typevarinfoast = (match info with
    | InfoVar(_, t, _, _) ->
      if (est_compatible t Undefined) then failwith "Type Undefined"
      else t
    | _ -> failwith "InfoVar attendu") in
      (AstType.Ident(ia), typevarinfoast)
  | AstTds.Const(ia) ->
    (AstType.Const(ia), Int)
  | AstTds.DeRef da ->
    let (nda, ta) = analyse_type_affectable da in
    match ta with
    | Pointeur(t) -> (AstType.DeRef(nda, t), t)
    | _ -> raise (TypeInattendu(ta, Pointeur(Undefined)))

(* analyse_type_expression : AstTds.expression -> AstType.expression *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'expression
en une expression de type AstType.expression *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_type_expression e = 
  match e with 
  | AstTds.Booleen(b) -> (AstType.Booleen(b), Bool)
  | AstTds.Entier(i) -> (AstType.Entier(i), Int)
  | AstTds.Unaire(op, e) ->
    let (newe, typee) = analyse_type_expression e in
    if (est_compatible typee Rat) then
      let (t_ret, newop) =
      begin
        match op with
        | AstSyntax.Numerateur -> (Int, AstType.Numerateur)
        | AstSyntax.Denominateur -> (Int, AstType.Denominateur)
 (*       | _ -> failwith "Erreur dans analyse_type_expression" *)
      end
      in (AstType.Unaire(newop, newe), t_ret)
    else raise (TypeInattendu(typee, Rat))
  | AstTds.Binaire(op, e1, e2) ->
    let (newe1, type1) = analyse_type_expression e1 in
    let (newe2, type2) = analyse_type_expression e2 in
    let (t_ret, newop) =
    begin
      match op with
      | AstSyntax.Plus ->
        begin
          match type1, type2 with
          | Int, Int -> (Int, AstType.PlusInt)
          | Rat, Rat -> (Rat, AstType.PlusRat)
          | _ -> raise (TypeBinaireInattendu(op, type1, type2))
        end
      | AstSyntax.Mult ->
        begin
          match type1, type2 with
          | Int, Int -> (Int, AstType.MultInt)
          | Rat, Rat -> (Rat, AstType.MultRat)
          | _ -> raise (TypeBinaireInattendu(op, type1, type2))
        end
      | AstSyntax.Fraction ->
        begin
          match type1, type2 with
          | Int, Int -> (Rat, AstType.Fraction)
          | _ -> raise (TypeBinaireInattendu(op, type1, type2))
        end
      | AstSyntax.Equ ->
        begin
          match type1, type2 with
          | Int, Int -> (Bool, AstType.EquInt)
          | Bool, Bool -> (Bool, AstType.EquBool)
          | _ -> raise (TypeBinaireInattendu(op, type1, type2))
        end
      | AstSyntax.Inf -> 
      begin
        if (est_compatible type1 Int) then
          (Bool, AstType.Inf) 
        else 
          raise (TypeBinaireInattendu(op, type1, type2))
      end
    end
    in (AstType.Binaire(newop, newe1, newe2), t_ret)
  | AstTds.AppelFonction(ia, le) ->
    let (tf, ltf) = (
      match info_ast_to_info ia with
      | InfoFun(_, t_ret, lt_param) ->
        if (t_ret = Undefined) then failwith "Type Undefined"
        else (t_ret, lt_param)
      | _ -> failwith "Pas une InfoFun")
  in
    let nle = List.map (analyse_type_expression) le in
    let lte = List.map (fun x -> fst x) nle in
    let nlet = List.map (fun x -> snd x) nle in
    if (est_compatible_list nlet ltf) then (AstType.AppelFonction(ia, lte), tf)
    else raise (TypesParametresInattendus(nlet, ltf))
  | AstTds.Affectable(a) ->
    let (na, ta) = analyse_type_affectable a in
    (AstType.Affectable(na), ta)
  | AstTds.Ternaire (c, e1, e2) ->
    let (nc, tc) = analyse_type_expression c in
    let (ne1, te1) = analyse_type_expression e1 in
    let (ne2, te2) = analyse_type_expression e2 in
    if (est_compatible tc Bool) then
      if (est_compatible te1 te2) then (AstType.Ternaire(nc, ne1, ne2), te1)
      else raise (TypesRetourInattendus(te1, te2))
    else raise (TypeInattendu(tc, Bool))
  | AstTds.New t -> (AstType.New t, Pointeur(t))
  | AstTds.Adresse ia -> let info = info_ast_to_info ia in
  let typevarinfoast = (match info with
  | InfoVar(_, t, _, _) ->
    if (est_compatible t Undefined) then failwith "Type Undefined"
    else t
  | _ -> failwith "InfoVar attendu") in
    (AstType.Adresse(ia), Pointeur(typevarinfoast))
  | AstTds.Null -> (AstType.Null, Pointeur(Undefined))


(* analyse_type_instruction : AstTds.instruction -> AstType.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'instruction
en une instruction de type AstType.instruction *)
(* Erreur si mauvaise utilisation des types *)
let rec analyse_type_instruction i =
  match i with
  | AstTds.Declaration(t, ia, e) ->
    let (ne, te) = analyse_type_expression e in
    if (est_compatible t te) then
      begin
        modifier_type_variable t ia;
        AstType.Declaration(ia, ne)
      end
    else raise (TypeInattendu(te, t))
  | AstTds.Affichage e ->
    let (ne, te) = analyse_type_expression e in
    begin
      match te with
      | Bool -> AstType.AffichageBool(ne)
      | Int -> AstType.AffichageInt(ne)
      | Rat -> AstType.AffichageRat(ne)
      | Pointeur(_) -> AstType.AffichagePointeur(ne)
      | Undefined -> failwith "Erreur dans analyse_type_instruction"
    end
  | AstTds.Conditionnelle (c,tia,eia) ->
    let (nc, tc) = analyse_type_expression c in
    if (est_compatible tc Bool) then
      let nbt = analyse_type_bloc tia in
      let nbe = analyse_type_bloc eia in
      AstType.Conditionnelle(nc, nbt, nbe)
    else raise (TypeInattendu(tc, Bool))
  | AstTds.TantQue (c,bast) ->
    let (nc, tc) = analyse_type_expression c in
    if (est_compatible tc Bool) then
      let nb = analyse_type_bloc bast in
      AstType.TantQue(nc, nb)
    else raise (TypeInattendu(tc, Bool))
  | AstTds.Empty -> AstType.Empty
  | AstTds.Retour(e, ia) -> (
    let (ne, te) = analyse_type_expression e in
    let (t_ret, _) = 
    (match info_ast_to_info ia with
      | InfoFun(_, t_ret, lt_param) ->
        if (est_compatible t_ret Undefined) then failwith "Type Undefined"
        else (t_ret, lt_param)
      | _ -> failwith "Pas un InfoFun") 
    in
    if (est_compatible te t_ret) then
      AstType.Retour(ne, ia)
    else raise (TypeInattendu(te, t_ret)))
  | AstTds.Affectation (a,e) ->
    let (na, ta) = analyse_type_affectable a in
    let (ne, te) = analyse_type_expression e in
    if (est_compatible ta te) then AstType.Affectation(na, ne)
    else (raise (TypeInattendu(te, ta)))
  | AstTds.Loop (n, li) ->
    let nli = analyse_type_bloc li in
    AstType.Loop(n, nli)
  | AstTds.Continue (n) ->
    AstType.Continue (n)
  | AstTds.Break (n) ->
    AstType.Break (n)


(* analyse_type_bloc : AstTds.bloc -> AstType.bloc *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des types et tranforme le bloc en un bloc de type AstType.bloc *)
(* Erreur si mauvaise utilisation des types *)
and analyse_type_bloc li =
  List.map (analyse_type_instruction) li


let analyse_type_parametre (t, ia) =
  modifier_type_variable t ia;
  ia

(* analyse_type_fonction : AstTds.fonction -> AstTypefonction *)
(* Paramètre fun : la fonction à analyser *)
(* Vérifie la bonne utilisation des types et tranforme la fonction
en une fonction de type AstType.fonction *)
(* Erreur si mauvaise utilisation des types *)
let analyse_type_fonction (AstTds.Fonction(t,ia,lp,b)) =
  let lpia = List.map (analyse_type_parametre) lp in
  let ltp = List.map (fun x -> fst x) lp in
  modifier_type_fonction t ltp ia;
  let nb = analyse_type_bloc b in
  AstType.Fonction(ia, lpia, nb)

(* analyser : AstTds.programme -> AstType.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des types et tranforme le programme
en un programme de type AstType.programme *)
(* Erreur si mauvaise utilisation des types *)
let analyser (AstTds.Programme (fonctions,prog)) =
  let newfun = List.map (analyse_type_fonction) fonctions in
  let newbloc = analyse_type_bloc prog in
  AstType.Programme (newfun, newbloc)