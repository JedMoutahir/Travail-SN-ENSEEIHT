Require Import Naturelle.
Section Session1_2021_Logique_Exercice_1.

Variable A B C : Prop.

Theorem Exercice_1_Naturelle :  ((A -> C) \/ (B -> C)) -> ((A /\ B) -> C).
Proof.
I_imp H.
I_imp J.
E_imp A.
E_ou (A -> C) (B -> C).
Hyp H.
I_imp H1.
Hyp H1.
I_imp H2.
I_imp H3.
E_imp B.
Hyp H2.
E_et_d A.
Hyp J.
E_et_g B.
Hyp J.
Qed.

Theorem Exercice_1_Coq : ((A -> C) \/ (B -> C)) -> ((A /\ B) -> C).
Proof.
intro H.
intro J.
destruct H as [H1 | H2].
cut A.
exact H1.
cut (A /\ B).
intro H.
elim H.
intros HA HB.
exact HA.
exact J.
cut B.
exact H2.
cut (A /\ B).
intro H.
elim H.
intros HA HB.
exact HB.
exact J.
Qed.

End Session1_2021_Logique_Exercice_1.

