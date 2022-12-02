Problème des philosophes
========================

Énoncé
------

N philosophes sont autour d'une table. Il y a une assiette par philosophe,
et *une* fourchette entre chaque assiette. Pour manger, un philosophe
doit utiliser les deux fourchettes adjacentes à son assiette (et celles-là
seulement).

Un philosophe peut être dans l'état :

- penseur : il n'utilise pas de fourchettes ;
- mangeur : il utilise les deux fourchettes adjacentes ; aucun de ses
  voisins ne peut manger ;
- demandeur : il souhaite manger mais ne dispose pas des deux fourchettes.

Visuellement les états mangeur/demandeur/penseur sont représentés par un
rond noir  (ou rouge en cas de possible problème) / un rond blanc / rien.

Code fourni
-----------
- `StrategiePhilo.java` : interface de la synchronisation entre philosophes.
- `PhiloSem.java` : une implantation de cette interface.
- `ProcessusPhilosophe.java` : code d'un philosophe.
- `Main.java` : programme principal.
  Définit aussi les `PhiloDroite(i)`, `PhiloGauche(i)`, `FourchetteGauche(i)`,
  `FourchetteDroite(i)`.
- `EtatFourchette.java` : définition des constantes pour fourchette placée
  sur la table, l'assiette gauche, l'assiette droite.
- `EtatPhilosophe.java` : définition des constantes pour philosophe penseur,
  demandeur ou mangeur.
- `IHM*.java` : interface utilisateur.
- `Synchro/Simulateur.java` : le simulateur de temps.

- Compilation:  
        `javac *.java`

- Exécution:  
        `java Main`  
        `java Main PhiloSem 10`  
         (classe implantant l'interface StrategiePhilo) (nb de philosophes)

À faire
-------

Implanter des stratégies de résolution du problème, en utilisant des
sémaphores.

 - `PhiloSem.java` est la seule classe à modifier. Le constructeur de cette classe prend
un paramètre correspondant au nombre de philosophes lancés. Les variables d'état ou
les sémaphores utilisés par les méthodes de cette classes seront (déclarés comme) des
attributs de cette classe.

- Il est possible de contrôler la progression des philosophes pas à pas, en mettant 
la simulation en pause, puis en cliquant sur les philosophes (voir l'aide de la fenêtre),
ce qui peut être très utile pour mettre en évidence des scénarios conduisant à des
situations pathologiques (famine, erreur...)

- Utiliser `Main.java` pour les numéros (`Main.FourchetteGauche` /
  `Main.FourchetteDroite` / `Main.PhiloGauche` / `Main.PhiloDroite`).

- (Optionnel, ce n'est que pour l'affichage) pour poser la fourchette n°f
sur l'assiette à *sa* droite, à *sa* gauche ou sur la table, utiliser

        IHMPhilo.poser (f, EtatFourchette.AssietteDroite);
        IHMPhilo.poser (f, EtatFourchette.AssietteGauche);
        IHMPhilo.poser (f, EtatFourchette.Table);



Indications
-----------

### Approche 1 : la fourchette est une ressource critique

=> associer un sémaphore par fourchette. Montrer qu'une solution naïve
présente un risque d'interblocage, i.e. d'une situation où tous les
philosophes sont définitivement bloqués, et trouver une solution évitant ce
risque. Étudier le degré de parallélisme dans le pire des cas.

### Approche 2 : introduire explicitement la notion d'état des philosophes.

Un philosophe peut manger si aucun de ses voisins ne mange, il doit attendre
sinon. Les problèmes à résoudre sont alors :

- présence d'un test-and-set (regarder les voisins et devenir mangeur) qui
   doit être atomique ;
- déblocage d'un philosophe qui ne pouvait pas manger précédemment et qui
   peut le faire suite aux changements d'états d'un ou de ses deux voisins.

Comparer le parallélisme avec le cas n°1.

## Approche 3 : équité

Observer que la solution 2 peut conduire à la famine d'un philosophe
(trouver un exemple avec 4 ou 5 philosophes). Imaginer une solution gérant
une priorité entre les philosophes permettant de résoudre ce problème.

La classe Semaphore
--------------------
La plateforme Java fournit la classe `java.util.concurrent.Semaphore` qui propose 
une implantation des sémaphores généraux, avec notamment :

- un constructeur prenant un paramètre entier, correspondant à la valeur initiale 
du sémaphore. Un second paramètre *optionnel* booléen, qui permet de préciser si 
le sémaphore créé est FIFO. Par défaut, les sémaphores de 
la classe `java.util.concurrent.Semaphore` ne sont pas FIFO.       
        Par exemple : `s=new Semaphore(5,true)` crée un sémaphore FIFO de valeur initiale 5.
        
- une méthode `acquire()`, qui correspond à l'opération `down()`
- une méthode `release()`, qui correspond à l'opération `up()`
