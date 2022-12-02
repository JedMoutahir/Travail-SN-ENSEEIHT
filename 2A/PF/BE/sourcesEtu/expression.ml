(* Exercice 3 *)
module type Expression = sig
  (* Type pour représenter les expressions *)
  type exp


  (* eval : exp -> int *)
  (* Evalue l'expression *)
  (* Paramètre exp : l'expression qu'on veut évaluer *)
  (* Résultat : le résultat de l'expression *)
  val eval : exp -> int
end

(* Exercice 4 *)

module ExpAvecArbreBinaire : Expression  =
struct
  (* Type pour représenter les expressions binaires *)
  type op = Moins | Plus | Mult | Div
  type exp = Binaire of exp * op * exp | Entier of int

  (* eval *)
  let rec eval exp = 
    match exp with
    |Entier e -> e
    |Binaire (expg, operateur, expd) -> 
      if operateur = Moins then
        (eval expg) - (eval expd)
      else if operateur = Plus then
        (eval expg) + (eval expd)
      else if operateur = Mult then
        (eval expg) * (eval expd)
      else if operateur = Div then
        (eval expg) / (eval expd)
      else
        assert false 
  
  (* Tests : TO DO *)
  let%test _ = eval (Binaire (Binaire (Entier 3, Plus, Entier 4), Moins, Entier 12)) = -5
  let%test _ = eval (Binaire (Entier 1, Moins, Entier 2)) = -1
  let%test _ = eval (Entier 1) = 1
end



(* Exercice 5 *)


let rec allTrue l =
  match l with
  |[false] -> false
  |[true] -> true
  |t::q -> t && (allTrue q)

module ExpAvecArbreNaire : Expression = 
struct

  (* Linéarisation des opérateurs binaire associatif gauche et droit *)
  type op = Moins | Plus | Mult | Div
  type exp = Naire of op * exp list | Valeur of int

  
(* bienformee : exp -> bool *)
(* Vérifie qu'un arbre n-aire représente bien une expression n-aire *)
(* c'est-à-dire que les opérateurs d'addition et multiplication ont au moins deux opérandes *)
(* et que les opérateurs de division et soustraction ont exactement deux opérandes.*)
(* Paramètre : l'arbre n-aire dont ont veut vérifier si il correspond à une expression *)
let rec bienformee exp = 
  match exp with
  |Valeur _ -> true
  |Naire (operateur, expListe) -> 
    if operateur = Moins then
      ((List.length expListe) = 2) && (allTrue (List.map (bienformee) expListe))
    else if operateur = Plus then
      (List.length expListe) >= 2 && (allTrue (List.map (bienformee) expListe))
    else if operateur = Mult then
      (List.length expListe) >= 2 && (allTrue (List.map (bienformee) expListe))
    else if operateur = Div then
      (List.length expListe) = 2 && (allTrue (List.map (bienformee) expListe))
    else
      assert false 

let en1 = Naire (Plus, [ Valeur 3; Valeur 4; Valeur 12 ])
let en2 = Naire (Moins, [ en1; Valeur 5 ])
let en3 = Naire (Mult, [ en1; en2; en1 ])
let en4 = Naire (Div, [ en3; Valeur 2 ])
let en1err = Naire (Plus, [ Valeur 3 ])
let en2err = Naire (Moins, [ en1; Valeur 5; Valeur 4 ])
let en3err = Naire (Mult, [ en1 ])
let en4err = Naire (Div, [ en3; Valeur 2; Valeur 3 ])

let%test _ = bienformee en1
let%test _ = bienformee en2
let%test _ = bienformee en3
let%test _ = bienformee en4
let%test _ = not (bienformee en1err)
let%test _ = not (bienformee en2err)
let%test _ = not (bienformee en3err)
let%test _ = not (bienformee en4err)

(* eval : exp-> int *)
(* Calcule la valeur d'une expression n-aire *)
(* Paramètre : l'expression dont on veut calculer la valeur *)
(* Précondition : l'expression est bien formée *)
(* Résultat : la valeur de l'expression *)
let rec eval_bienformee exp = 
  match exp with
  |Valeur e -> e
  |Naire (operateur, expListe) -> 
    if operateur = Moins then
      List.fold_right (-) (List.map (eval_bienformee) expListe) 0
    else if operateur = Plus then
      List.fold_right (+) (List.map (eval_bienformee) expListe) 0
    else if operateur = Mult then
      List.fold_right (Int.mul) (List.map (eval_bienformee) expListe) 1
    else if operateur = Div then
      let [t1;t2] = expListe in ((eval_bienformee t1) / (eval_bienformee t2))
    else
      assert false 
let%test _ = eval_bienformee en1 = 19
let%test _ = eval_bienformee en2 = 14
let%test _ = eval_bienformee en3 = 5054
let%test _ = eval_bienformee en4 = 2527

(* Définition de l'exception Malformee *)
exception Malformee

(* eval : exp-> int *)
(* Calcule la valeur d'une expression n-aire *)
(* Paramètre : l'expression dont on veut calculer la valeur *)
(* Résultat : la valeur de l'expression *)
(* Exception  Malformee si le paramètre est mal formé *)
let eval exp = 
  if bienformee exp then
    eval_bienformee exp
  else
    raise Malformee

let%test _ = eval en1 = 19
let%test _ = eval en2 = 14
let%test _ = eval en3 = 5054
let%test _ = eval en4 = 2527

let%test _ =
  try
    let _ = eval en1err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en2err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en3err in
    false
  with Malformee -> true

let%test _ =
  try
    let _ = eval en4err in
    false
  with Malformee -> true
end