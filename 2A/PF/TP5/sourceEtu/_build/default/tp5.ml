(* Evaluation des expressions simples *)


(* Module abstrayant les expressions *)
module type ExprSimple =
sig
  type t
  val const : int -> t
  val plus : t -> t -> t
  val mult : t-> t -> t
end

(* Module réalisant l'évaluation d'une expression *)
module EvalSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = c
  let plus e1 e2 = e1 + e2
  let mult e1 e2 = e1 * e2
end


(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Définition des expressions *)
module ExemplesSimples (E:ExprSimple) =
struct
  (* 1+(2*3) *)
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  (* (5+2)*(2*3) *)
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
end

(* Module d'évaluation des exemples *)
module EvalExemples =  ExemplesSimples (EvalSimple)

let%test _ = (EvalExemples.exemple1 = 7)
let%test _ = (EvalExemples.exemple2 = 42)

module PrintSimple : ExprSimple with type t = string =
struct
  type t = string
  let const c = (string_of_int c)
  let plus e1 e2 = "(" ^ e1 ^ " + " ^ e2 ^ ")"
  let mult e1 e2 = "(" ^ e1 ^ " * " ^ e2 ^ ")"
end

(* Module d'évaluation des exemples *)
module PrintExemples =  ExemplesSimples (PrintSimple)

let%test _ = (PrintExemples.exemple1 = "(1 + (2 * 3))")
let%test _ = (PrintExemples.exemple2 = "((5 + 2) * (2 * 3))")

module CompteSimple : ExprSimple with type t = int =
struct
  type t = int
  let const _ = 0
  let plus e1 e2 = e1 + e2 + 1
  let mult e1 e2 = e1 + e2 + 1
end

(* Module d'évaluation des exemples *)
module CompteExemples =  ExemplesSimples (CompteSimple)

let%test _ = (CompteExemples.exemple1 = 2)
let%test _ = (CompteExemples.exemple2 = 3)

module type ExprVar =
sig
  type t
  val set : string -> t -> t -> t
  val value : string -> t
end

module type Expr =
sig
  include ExprSimple
  include (ExprVar with type t := t)
end

module PrintVar : ExprVar with type t = string =
struct
  type t = string
  let set v e1 e2 = "let "^v^" = "^e1^" in "^e2
  let value v = v
end

module Print : Expr with type t = string =
struct
  include PrintSimple
  include (PrintVar : ExprVar with type t:=t)
end

module ExemplesVar (E:Expr) =
struct
  (* “let x = 1+2 in x*3” *)
  let exemple  = E.(set "x" (plus (const 1) (const 2)) (mult (value "x") (const 3) ))
end

(* Module d'évaluation des exemples *)
module PrintExemples2 = ExemplesVar(Print)

let%test _ = (PrintExemples2.exemple = "let x = (1 + 2 in (x * 3)")

module PrintExemples3 = ExemplesSimples(Print)

let%test _ = (PrintExemples3.exemple1 = "(1 + (2 * 3))")
let%test _ = (PrintExemples3.exemple2 = "((5 + 2) * (2 * 3))")

type env = (string*int) list

module EvalVar : ExprVar with type t = env -> int =
struct
  type t = env -> int
  let set id e1 e2 = fun env -> e2 ((id,e1 env)::env)
  let value id = try List.assoc id with Not_found -> failwith "forme_expression_invalide" 
end

module EvalSimpleEnv : ExprSimple with type t = env -> int =
struct
  type t = env -> int
  let const c = fun _env -> c
  let plus e1 e2 =  fun env -> (e1 env) + (e2 env)
  let mult e1 e2 =  fun env -> (e1 env) * (e2 env)
end

module Eval : Expr with type t = env -> int =
struct
  include EvalSimpleEnv
  include (EvalVar : ExprVar with type t := t)
end

module ExemplesSimples2 (E:Expr) =
struct
  include ExemplesSimples(E)
  (* let x = 1+2 in x*3 *)
  let exemple3  = E.(set "x" (plus (const 1) (const 2)) (mult (value "x") (const 3)) )
end

module EvalExemples2 =  ExemplesSimples2 (Eval)

let%test _ = (EvalExemples2.exemple1 [] = 7)
let%test _ = (EvalExemples2.exemple2 [] = 42)
let%test _ = (EvalExemples2.exemple3 [] = 9)