!
       PROGRAM validation
! Utilisation des outils du module definition
       use definition
       use fsmdcm
! n : nombre de lignes ou de colonnes
! m : nombre d'elements non nuls
       integer :: n, m
! Declaration de la matrice
       type (mcreuse) :: a
! Declaration du graphe associe a la matrice
       type(cell_graphe), dimension(:), allocatable :: g
! Declaration du nouvel ordonnancement resultant du degre minimum
! et de Cuthill Mac Kee direct
       integer, dimension(:), allocatable :: neword
! Declaration du nouvel ordonnancement resultant de
! Cuthill Mac Kee inverse
       integer,dimension(:), allocatable :: ordcmki
! Declaration de variables auxiliaires pour la routine
! Cuthill Mac Kee
       integer :: istart, nbSets, iperiph
! Declaration du compteur de fillin
       integer :: totfill
! Indice de boucle
       integer :: i
! Controle du impression
       logical :: trace       ! vrai si impression demandee
       logical :: printmatlab ! controle impression pour matlab
! parametre de retour de subroutines
       integer :: retour
!                    
       print *, ' * DEBUT validation'
! Boleen de sortie de trace
       trace = .false.
       printmatlab = .false.
!
! Creation et impression de la matrice
!
       call creation_matrice(a, n, m, trace, retour)
       if (retour /= 0) then
         print *, ' Pb dans la lecture', &
              ' de la matrice, retour = ', retour
         stop
       end if
       if (printmatlab) call matlab_imprimer(a, n, m)
!
! Creation du graphe associe
!
       call creation_graphe(g, n, a, trace)
! Edition du graphe cree
       if (trace) call edition_graphe(g, n)
!
! Allocation des tableaux de permutation pour les differents orderings
!
       allocate(neword(n), stat=retour)
       if ( retour > 0 ) then
         print *, ' Pb allocation dynamique memoire '
         stop
       endif
       allocate(ordcmki(n), stat=retour)
       if ( retour > 0 ) then
         print *, ' Pb allocation dynamique memoire '
         stop
       endif
! -------------------------------------------------------
! Factorisation symbolique de la matrice non reordonnancee et
! calcul du remplissage
! -------------------------------------------------------
       call factorisation_symbolique (g, n, totfill, trace)
       print *, ' .. Remplissage avec ordre naturel        :', totfill
! Re-generation du graphe initial
       if (trace) print *,' Re-creation d un graphe existant'
       call creation_graphe(g, n, a, trace)
! -------------------------------------------------------
! Application de l'algorithme du degre minimum
! -------------------------------------------------------
       call degre_minimum(g, n, totfill, neword, trace, retour)
       print *, ' .. Remplissage apres degre minimum        :', totfill
       if (trace)  then
         print *,' tableau de permutation : '
         print "(1x,15i5)", (neword(i), i = 1, n)
       end if
       if (printmatlab) then
         open(FILE='perm_matlabMD', UNIT=10, STATUS='UNKNOWN')
         do i = 1, n
          write(10,*) neword(i)
         end do
         close(10)
       end if

!      --- Re-generation du graphe initial
       call creation_graphe(g, n, a, trace)
! -------------------------------------------------------
! Application de l'algorithme du Cuthil Mac Kee direct
! -------------------------------------------------------
        istart = 0
        print *,' Cuthill McKee '
        print *,' .. noeud de depart: ', istart
        call CMcK(g, n, istart, neword, nbSets, iperiph, trace, retour)
!       --- Calcul du remplissage dans la matrice des facteurs
!       --- Recréer le graphe (corrompu) à partir de la matrice originale
        call creation_graphe(g, n, a, trace)
        call factorisation_symbolique (g, n, totfill, trace, neword)
        print *, ' .. NBsets         : ', nbSets
        print *, ' .. Remplissage apres Cuthill McKee      : ', totfill
        if (trace) then
           print *, 'tableau de permutation (CMI) : '
           print "(1x,10i5)", (neword(i), i= 1,n)
        end if
        if (printmatlab) then
          open(FILE='perm_matlabCM', UNIT=10, STATUS='UNKNOWN')
          do i = 1, n
           write(10,*) ordcmki(i)
          end do
         close(10)
        end if
 
! -------------------------------------
! Generation de Cuthill Mac Kee inverse
! -------------------------------------
        do i = 1 ,n
            ordcmki(i) = neword(n-i+1)
        end do
!       --- Calcul du remplissage dans la matrice des facteurs
!       --- Recréer le graphe (corrompu) à partir de la matrice originale
        call creation_graphe(g, n, a, trace)
        call factorisation_symbolique (g, n, totfill, trace, ordcmki)
        print *, ' .. Remplissage Cuthill Mac kee inverse  : ', totfill
        if (trace) then
           print *, 'tableau de permutation (CMI) : '
           print "(1x,10i5)", (ordcmki(i), i = 1, n)
        end if
        if (printmatlab) then
          open(FILE='perm_matlabRCM', UNIT=12, STATUS='UNKNOWN')
          do i = 1, n
           write(12,*) ordcmki(i)
          end do
         close(12)
        end if
 
 500   print *, ' * FIN validation'
       stop
       END
