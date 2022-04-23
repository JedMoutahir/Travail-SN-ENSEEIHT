(* Bibliothèque pour l’extraction de programme. *)
Require Import Extraction.
(* Ouverture d’une section *)
Section Induction.
(* Déclaration d’un domaine pour les éléments des listes *)
Variable A : Set.
Inductive liste : Set :=
Nil : liste
| Cons : A -> liste -> liste.
(* Déclaration du nom de la fonction *)
Variable append_spec : liste -> liste -> liste.
(* Spécification du comportement pour Nil *)
Axiom append_Nil : forall (l : liste), append_spec Nil l = l.
(* Spécification du comportement pour Cons *)
Axiom append_Cons : forall (t : A), forall (q l : liste),
append_spec (Cons t q) l = Cons t (append_spec q l).

Theorem append_Nil_right : forall (l : liste), (append_spec l Nil) = l.
intro l.
induction l.
rewrite append_Nil.
reflexivity.
rewrite append_Cons.
rewrite IHl.
reflexivity.
Qed.

Theorem append_associative : forall (l1 l2 l3 : liste),
(append_spec l1 (append_spec l2 l3)) = (append_spec (append_spec l1 l2) l3).
intros l1 l2 l3.
induction l1.
rewrite !append_Nil; reflexivity.
rewrite !append_Cons; rewrite IHl1; reflexivity.
Qed.

Fixpoint append_impl (l1 l2 : liste) {struct l1} : liste :=
match l1 with
Nil => l2
| (Cons t1 q1) => (Cons t1 (append_impl q1 l2))
end.

Theorem append_correctness : forall (l1 l2 : liste),
(append_spec l1 l2) = (append_impl l1 l2).
intros l1 l2.
induction l1.
rewrite append_Nil.
simpl.
reflexivity.
rewrite append_Cons.
rewrite IHl1.
simpl.
reflexivity.
Qed.

Variable rev_spec : liste -> liste.
(* Spécification du comportement pour Nil *)
Axiom rev_Nil : rev_spec Nil = Nil.
(* Spécification du comportement pour Cons *)
Axiom rev_Cons : forall (t : A), forall (q : liste),
rev_spec (Cons t q) = append_spec (rev_spec q) (Cons t Nil).

Lemma rev_append : forall (l1 l2 : liste),
(rev_spec (append_spec l1 l2)) = (append_spec (rev_spec l2) (rev_spec l1)).
intros l1 l2.
induction l1.
rewrite append_Nil.
rewrite rev_Nil.
rewrite append_Nil_right.
reflexivity.
rewrite append_Cons.
rewrite rev_Cons.
rewrite rev_Cons.
rewrite append_associative.
rewrite IHl1.
reflexivity.
Qed.

Theorem rev_rev : forall (l : liste), (rev_spec (rev_spec l)) = l.
intro l.
induction l.
rewrite !rev_Nil.
reflexivity.
rewrite rev_Cons.
rewrite rev_append.
rewrite rev_Cons.
rewrite rev_Nil.
rewrite append_Nil.
rewrite IHl.
rewrite append_Cons.
rewrite append_Nil.
reflexivity.
Qed.

Fixpoint rev_impl (l : liste) {struct l} : liste :=
match l with
Nil => Nil
| (Cons t q) => append_impl (rev_impl q) (Cons t Nil)
end.


End Induction.

Extraction Language OCaml.
Extraction "/tmp/induction" append_impl rev_impl.
Extraction Language Haskell.
Extraction "/tmp/induction" append_impl rev_impl.
Extraction Language Scheme.
Extraction "/tmp/induction" append_impl rev_impl.