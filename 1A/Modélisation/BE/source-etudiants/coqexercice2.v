Require Import Naturelle.
Section Session1_2019_Logique_Exercice_2.

Variable A B : Prop.

Theorem Exercice_2_Naturelle : (~A) \/ B -> (~A) \/ (A /\ B).
Proof.
I_imp H.
E_ou A (~A).
TE.
I_imp J.
I_ou_d.
I_et.
Hyp J.
E_ou (~A) B.
Hyp H.
I_imp K.
E_antiT.
I_antiT A.
Hyp J.
Hyp K.
I_imp K.
Hyp K.
I_imp J.
I_ou_g.
Hyp J.
Qed.

Theorem Exercice_2_Coq : (~A) \/ B -> (~A) \/ (A /\ B).
Proof.
intro H.
elim H.
intro H1.
left.
exact H1.
intro H3.
left.
intro H1.
absurd A.
cut B.



Qed.

End Session1_2019_Logique_Exercice_2.

