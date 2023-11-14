vérifier que vous pouvez monter jusqu’à 256 processeurs (nombre de processeurs du fichier
cluster hostfile.txt, caché dans l’alias de smpirun). Que se passe-t-il avec SimGrid quand on
dépasse cette valeur ?

Les taches sont attribuées à 256 processeurs. Si on dépasse cette valeur, les taches sont attribuées par packet à ces processeurs.