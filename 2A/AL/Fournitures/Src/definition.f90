      MODULE definition
       implicit none
!
       type mcreuse
! Schema de stockage au format Compressed Sparse Column (CSC) : 
!   PTCOL tableau d'entiers pour ! gerer les indirections, 
!   VALEUR coefficients reels de la matrice,
!   INDLIG indices de lignes, nonnul nombre de coefficients non nuls,
!   ncol dimension de la matrice
         integer, dimension(:), pointer :: PTCOL
         real, dimension(:), pointer    :: VALEUR
         integer, dimension(:), pointer :: INDLIG
         integer                        :: nonnul, ncol
       END type mcreuse

       type cell_graphe
! Cellule elementaire pour la construction du graphe : permet le
! chainage des noeuds adjacents et sert egalement a definir le tableau
! d'entree du graphe
         integer                     :: indice
         type (cell_graphe), pointer :: suivant
       END type cell_graphe
!
       PRIVATE :: merge  ! subroutine privee au module
!
!**********************************************
! description des procedures du MODULE definion
!**********************************************
       CONTAINS
!
       SUBROUTINE creation_matrice(mat, n, p, trace, retour)
       implicit none
! Creation dynamique de la matrice creuse "mat", de dimension "n",
! possedant "p" elements non nuls. 
! n     : dimension de la matrice
! p     : nnz dans la matrice
! trace : vrai si l'impression de la matrice est demande.
! retour: = 0 si aucun probleme dans la lecture et 
!         dans l'allocation dynamique de la memoire. 
!        >0 si pb d'allocation dynamique de la memoire
!       = -1 si pb de lecture des donnees (on autorise 
!           uniquement l'omission des valeurs reelles). 
!
! Lecture de la matrice sur l'entree standard
!
       type(mcreuse), intent(out) :: mat
       integer, intent(out)       :: n, p
       logical, intent(in)        :: trace  ! vrai si impression demandee
       integer, intent(out)       :: retour ! >0 si probleme
! local variables:
       logical                    :: reelLUS  ! on peut ne pas lire les reeels
       integer                    :: i
! formats de lecture/ecriture des donnees
       character (len=9)          :: fipt='(12i6)', find='(10i5)'
       character (len=10)         :: fval='(10f7.2)'
       character (len=80)         :: message
!
       read (5, '(a80)', END=500) message
       print '(a80)', message
       read (5, *, END=500) n, p
! Allocation dynamique
       if (trace) print *, ' ** DEBUT creation_matrice **'
       allocate(mat%PTCOL(n+1), stat=retour)
       if ( retour > 0 ) return
       allocate(mat%INDLIG(p), stat=retour)
       if ( retour > 0 ) return
       mat%ncol = n
       mat%nonnul = p
       nullify(mat%VALEUR)  ! pour tester ensuite si associated
! Lecture des donnees sur l'entree standard
       read (5, '(a80)', END=500) message
       read(5, fipt, END=500) (mat%PTCOL(i), i = 1, n+1)
       read (5, '(a80)', END=500) message
       read(5, find, END=500) (mat%INDLIG(i), i = 1, p)
       if (trace) then
!        Impression de la matrice
         print *, 'matrice d ordre : ', n, ' nb de nonzeros : ', p
         print *, 'tableau de pointeurs'
         print fipt, (mat%PTCOL(i), i = 1, n+1)
         print *, 'indices de lignes'
         print find, (mat%INDLIG(i), i = 1, p)
       end if
       read (5, '(a80)', END=400) message
       allocate(mat%VALEUR(P), stat=retour)
       if ( retour > 0 ) return
       read(5, fval, END=400) (mat%VALEUR(i), i = 1, p)
       if (trace) then
!        Impression des valeurs reelles de la matrice
         print '(a80)', message
         print fval, (mat%VALEUR(i), i = 1, p)
       end if
 400   if (trace) print *, ' ** FIN creation_matrice **'
       return
! ----------------------------------------------
! Cas d'erreur de lecture de la matrice
 500   print *, ' PB dans la lecture de la matrice d''entree '
       retour = -1
       return
       END SUBROUTINE creation_matrice 
!
!
!**********************************************************************
       SUBROUTINE matlab_imprimer(mat, n, m)
       implicit none
!  Impression de la matrice sous le format
!  Indice_ligne Indice_colonne  [Valeur] pour
!  lecture sous matlab.
       type (mcreuse), intent(in) :: mat
       integer, intent(in)        :: n, m
!
! local variables:
!      Formats d'ecriture
       character (len=8)          :: fimatlab='(2i6)'
       character (len=19)         :: frmatlab='(i6,1x,i6,1x,f15.4)'
       logical                    :: reelLUS  ! on n'a pas lu les reels
       integer                    :: i, j
!
       reelLUS = associated(mat%VALEUR)
       open(FILE='mat_matlab', UNIT=10, STATUS='UNKNOWN')
       if (reelLUS) print *, ' values available'
       do i = 1, n
        do j = mat%PTCOL(i), mat%PTCOL(i+1)-1
         if (reelLUS) then
           write (10, frmatlab) i, mat%INDLIG(j), mat%VALEUR(j)
         else
           write (10, fimatlab) i, mat%INDLIG(j)
         endif
        enddo
       enddo
       close(10)
!
       END SUBROUTINE matlab_imprimer
!
!**********************************************************************
       SUBROUTINE creation_graphe(g, dim, mat, trace)
       implicit none
! Creation du graphe g associe a la matrice mat d'ordre dim
! le graphe g a ete declare dynamique et alloue dans le programme
! principal. Edition du graphe
       type (mcreuse), intent(in)  :: mat
       integer, intent(in)         :: dim
       logical, intent(in)         :: trace
       type (cell_graphe), dimension(:), allocatable, intent(out) :: g
! variables de travail
       type (cell_graphe), pointer :: courant, deb, next
       integer                     :: retour, i, j
       if (trace) print *, ' ** DEBUT creation_graphe **'
       if (.NOT.ALLOCATED(g)) then
         allocate(g(dim), stat=retour)
         if (retour > 0) then
           print *, ' Pb dans l allocation dynamique du graphe '
           stop
         end if
         do i = 1, dim
           nullify(g(i)%suivant)
         enddo
       endif
! On commence par dealloue le graphe si celui-ci avait deja
! ete cree
       do j = 1, dim
          deb => g(j)%suivant 
          do while (associated(deb))
             next => deb%suivant
             deallocate(deb)
             deb => next
          end do
       enddo
!
       do j = 1, dim
! Creation de la liste associee au noeud j
!        initialisation du degre
         g(j)%indice = 0
         nullify(deb)
         do i = mat%PTCOL(j+1)-1, mat%PTCOL(j), -1
! Insertion d'un nouvel element non nul sauf le terme diagonal
           if (mat%INDLIG(i)/=j) then
             allocate(courant, stat=retour)
             if ( retour > 0 ) return
             courant%indice = mat%INDLIG(i)
             courant%suivant => deb
             deb => courant
             g(j)%indice = g(j)%indice+1
           end if
         end do
! Mise a jour du pointeur d'entree pour la liste associee au noeud j
         g(j)%suivant => deb
       end do
       if (trace) print *, ' ** FIN   creation_graphe **'
       return
       END SUBROUTINE creation_graphe
!
!**********************************************************************
       SUBROUTINE edition_graphe(g, dim)
       implicit none
! Edition du graphe g de dimension dim
       integer, intent(in)         :: dim
       type (cell_graphe), dimension(dim), intent(in) :: g
! variables locales
       integer                     :: i
       type (cell_graphe), pointer :: deb
!
       print *, '*** DEBUT edition du graphe'
       do i = 1, dim
         print *, 'noeud ', i, ' degre ', g(i)%indice
         deb => g(i)%suivant
         do while (associated(deb))
           print *, deb%indice
           deb => deb%suivant
         end do
       end do
       print *, '*** FIN edition du graphe'
       return
       END SUBROUTINE edition_graphe
!
!**********************************************************************
       SUBROUTINE elimination(g, dim, compt, pivot, trace)
       implicit none
! Elimination d'un pivot au cours de l'operation de factorisation
! et mise a jour associee du graphe
! g     (inout)  : graphe de representation de la matrice
!           (en sortie g(pivot)%indice = -1 pour indiquer
!            que le pivot a été éliminé)
! compt (inout)  : compteur de fillin (mis a jour au cours de l'elimination)
! pivot (in)     : numero du pivot a eliminer
! dim   (in)    : ordre de la matrice
! trace : si vrai alors imprimer trace d'execution
       integer, intent(in)                             :: dim
       type (cell_graphe),dimension(dim),intent(inout) :: g
       integer, intent(inout)                          :: compt
       integer, intent(in)                             :: pivot
       logical, intent(in)                             :: trace  ! vrai si impression demandee
!
! Pointeur temporaires
       type (cell_graphe), pointer                     :: courant
! Compteurs temporaires
       integer                                         :: filladj, nbadj
       if (trace) print *, ' ** DEBUT elimination pivot : ', pivot
! Positionnement en debut de la liste du pivot
       courant => g(pivot)%suivant
! Balayage de la liste du pivot
       do while (associated(courant))
         if (trace) &
        print *, '   traitement de l''adjacent de no : ', courant%indice
! Fusion de la liste du pivot et de son adjacent courant
         call merge(pivot,          g(pivot)%suivant, &
                    courant%indice, g(courant%indice)%suivant, &
                    filladj, nbadj, trace) 
! Mise a jour du compteur de fillin
         compt = compt+filladj
! Mise a jour du degre de l'adjacent
         g(courant%indice)%indice = nbadj
         courant => courant%suivant
       end do
! Memoriser que le pivot a été éliminé
       g(pivot)%indice = -1  
       return
       END SUBROUTINE elimination
!
!     PRIVATE SUBROUTINES
!
       SUBROUTINE merge(npiv, ppiv, nadj, padj, nbelem, nbnonnul, trace)
! Procedure utilitaire permettant la fusion de deux listes
! et necessaire lors de l'elimination d'un pivot.
! ppiv : pointeur sur la liste d'adjacence du pivot
! padj : pointeur sur la liste d'un des adjacents du pivot
! nbelem : nombre de fillin provoque par la fusion
! nbnonnul : nombre de noeuds, apres fusion, dans liste decrite
!            par le pointeur padj
! trace : si vrai alors imprimer trace d'execution
       integer, intent(in)         :: npiv, nadj
       integer, intent(out)        :: nbelem, nbnonnul
       type (cell_graphe), pointer :: ppiv, padj
       logical, intent(in)         :: trace  ! vrai si impression demandee
! Pointeurs temporaires
       type (cell_graphe), pointer :: rech, courant, prec,new
! variables locales
       integer                     :: ncol, retour
       nbelem = 0
       nbnonnul = 0
! 1. SUPPRESSION DU PIVOT DANS LA LISTE DE L'ADJACENT
       rech => padj
       if (rech%indice == npiv) then
! Le pivot est tete de liste de l'adjacent
         padj => rech%suivant
         deallocate(rech)
       else
! Recherche du pivot
         do while (rech%indice /= npiv)
           prec => rech
           rech => rech%suivant
         end do
! Suppression du pivot
         prec%suivant => rech%suivant
         deallocate(rech)
       end if
!       print *, 'pivot supprime'
! 2. NETTOYAGE DE L'ADJACENT ET CALCUL DU FILLIN
       rech => ppiv
! Boucle sur tous les noeuds adjacents du pivot
       do while (associated(rech))
         ncol = rech%indice
! On ne traite pas le cas ou le numero du noeud courant coincide
! avec l'adjacent
         if (ncol /= nadj) then
! Recherche du noeud courant dans la liste de l'adjacent
           if (trace)  &
                  print *, '    chercher si fillin entre ', nadj, ' et ', ncol
           courant => padj
           prec => padj 
           do while (associated(courant))
             if (courant%indice == ncol) exit
             prec => courant
             courant => courant%suivant
           end do
!          print *, 'fin recherche'
           if (.not.associated(courant)) then
! Le noeud courant n'a pas ete trouve dans la liste de l'adjacent :
! il y a fillin et creation d'un nouveau element dans la liste de
! l'adjacent (en fin de liste).
             if (trace)  print *, '     creation cellule ', nadj, ncol
             allocate(new, stat=retour)
             if ( retour > 0 ) return
             new%indice = ncol
             if (associated(padj)) then
               prec%suivant => new
             else
               padj => new
             end if
             nullify(new%suivant)
! Incrementation du compteur de fillin
             nbelem = nbelem+1
           end if
         end if
         rech => rech%suivant
       end do
!       print *, 'fin du nettoyage et du fillin'
! 3. CALCUL DU NOMBRE D'ELEMENTS DANS LA LISTE DE L'ADJACENT
       rech => padj
       do while (associated(rech))
!         print *, 'nbnonnul ', nadj, '  ', rech%indice
         nbnonnul = nbnonnul+1
         rech => rech%suivant
       end do
       return
       END SUBROUTINE merge


      SUBROUTINE CLEAN_graphe(g, dim)
       integer, intent(in)                             :: dim
       type (cell_graphe), dimension(dim), intent(out) :: g
! variables de travail
       type (cell_graphe), pointer                     :: deb, rech
       integer                                         :: retour
       integer                                         :: i, j
       print *, ' ** DEBUT cleaning graphe **'
       do j = 1, dim
         DO WHILE (associated(g(j)%suivant))
           deb  =>  g(j)%suivant
           g(j)%suivant => deb%suivant
           deallocate(deb)
         ENDDO
       enddo 
       print *, ' ** END cleaning graphe **'
       END SUBROUTINE CLEAN_graphe  

!
       END MODULE definition
