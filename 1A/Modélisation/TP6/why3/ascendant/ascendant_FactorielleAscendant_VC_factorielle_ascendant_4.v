(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import BuiltIn.
Require BuiltIn.
Require int.Int.

(* Why3 assumption *)
Inductive ref (a:Type) :=
  | mk_ref : a -> ref a.
Axiom ref_WhyType : forall (a:Type) {a_WT:WhyType a}, WhyType (ref a).
Existing Instance ref_WhyType.
Arguments mk_ref {a}.

(* Why3 assumption *)
Definition contents {a:Type} {a_WT:WhyType a} (v:ref a) : a :=
  match v with
  | mk_ref x => x
  end.

Parameter factorielle: Z -> Z.

Axiom factorielle_zero : ((factorielle 0%Z) = 1%Z).

Axiom factorielle_succ :
  forall (n:Z), (0%Z <= n)%Z ->
  ((factorielle (n + 1%Z)%Z) = ((n + 1%Z)%Z * (factorielle n))%Z).

Parameter n: Z.

Axiom H : (0%Z <= n)%Z.

Parameter r: Z.

Parameter i: Z.

Axiom H1 : ((factorielle i) = r).

Axiom H2 : (0%Z <= i)%Z.

Axiom H3 : (i <= n)%Z.

Axiom H4 : ~ (i < n)%Z.

(* Why3 goal *)
Theorem VC_factorielle_ascendant : ((factorielle n) = r).
Proof.
rewrite <- H1.
cut ((i <= n)%Z).
intro J1.
cut (~ (i < n)%Z).
intro J2.
cut (i = n).
intro J3.
rewrite J3.
reflexivity.
omega.
apply H4.
apply H3.
Qed.

