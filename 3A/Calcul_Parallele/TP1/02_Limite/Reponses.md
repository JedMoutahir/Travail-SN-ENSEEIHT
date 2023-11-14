(a) rappelez pour quelle taille de message (petite, grande), MPI Send aura un comportement
asynchrone (resp. synchrone)

petite taille de message : asynchrone
grande taille de message : synchrone

(b) que va-t-il se passer quand votre programme, complété comme indiqué, sera appelé avec une
taille de message qui fera que MPI Send sera synchrone ?

Le programme va se bloquer car le send est synchrone et le receive est bloquant

(c) estimez à 10 entiers près, la taille limite ?

16383 entiers

(d) proposez une solution pour que l’échange entre les deux noeuds puissent se faire au del`a de
cette limite (plusieurs réponses possibles). Vous avez la possibilité de les tester en dehors de
la séance.

 - On peut utiliser MPI_Isend et MPI_Irecv pour rendre le send asynchrone et le receive non bloquant
 - On peut utiliser MPI_Sendrecv pour faire un send et un receive en même temps