       MODULE fsmdcm
!****************************************************
! Ce module contient les subroutines effectuant 
!   - la factorisation symbolique d'une matrice creuse et calculant
!     le nombre de nouvelles entrees non nulles dans les facteurs
!     ( subroutine factorisation_symbolique )
!   - le calcul d'une permutation basée sur l'algorithme de degré minimum
!   - le calcul d'une permutation basée sur l'algorithme de Cuthill-Mc-Kee
! Toutes les subroutines ont en entrée le graphe de la matrice 
! qui est en général modifié durant le traitement.
!****************************************************
!
       USE definition
       PRIVATE pivot_deg_min ! subroutine locale au module 
!
       CONTAINS
!
!********* FOURNIE **********************************************
       SUBROUTINE factorisation_symbolique (g, dim, compt, trace ,perm)
       implicit none
! Factorisation symbolique de la matrice dont l'ordonnancement 
! est donne par "perm" avec comptabilite du fillin "compt".
! Si le parametre optionnel "perm" n'est pas fourni alors une
! factorisation  symbolique en suivant l'ordre naturel est effectué
!
! g     : graphe representant la matrice
! compt : compteur de fillin
! dim   : dimension de la matrice
! Parametre optionnel: 
!      perm  : tableau de permuation (perm(i) --> ieme pivot) 
       integer, intent(in)           :: dim
       type (cell_graphe), dimension(dim), intent(inout) :: g
       integer, intent(out)          :: compt
       logical, intent(in)           :: trace  ! vrai si impression demandee
       integer, intent(in), optional :: perm(dim)
! Local variable
       integer :: pivot, i
       if (trace) print *, '**** DEBUT SUBROUTINE factorisation_symbolique  '
! Fillin initial nul
       compt = 0
! Boucle sur tous les pivots dans l'ordre defini par perm
       do i = 1, dim
! Elimination du ieme pivot
         if (present(perm)) then 
!             elimination dans l'ordre donné par la permutation perm:
!             pivot perm(i) est éliminé à l'étape i
              pivot = perm(i)
         else
!             elimination dans l'ordre naturel
              pivot = i
         endif
         call elimination(g, dim, compt, pivot, trace)
       end do
       if (trace) print *, '**** FIN   SUBROUTINE factorisation_symbolique'
       return
       END SUBROUTINE factorisation_symbolique

!****************** À ÉCRIRE *******************************************
       SUBROUTINE degre_minimum(g, dim, compt, perm, trace, retour)
       implicit none
! Calcul d'un nouvel ordonnancement par l'algorithme du degre
! minimum avec comptabilite du fillin
!
! g     (inout) : graphe representant la matrice
! compt (out)   : compteur de fillin
! dim   (in)    : dimension de la matrice
! perm  (out)   : tableau de (dim) elements 
!                 representant le nouvel ordonnancement
!                  perm (i) = j <=> j elimine à l'etape i
! retour : code de retour, O si OK
       integer, intent(in)                               :: dim
       type (cell_graphe), dimension(dim), intent(inout) :: g
       integer, intent(out)                              :: compt, retour
       integer, dimension(dim), intent(out)              :: perm
       logical, intent(in)                               :: trace  ! vrai si impression demandee
! Variables temporaires
       integer :: newpiv, degmin
       integer :: i, j
!
       compt = 0
       perm = 0
       if (trace) print *, '*** DEBUT degre_minimum **'
       retour = 0

       print *, ' ****** A ECRIRE ********* ' 

       do i = 1, dim
! Calcul du pivot de degre minimum
         call pivot_deg_min(g, dim, newpiv, retour)
         perm(i) = newpiv
         call elimination(g, dim, compt, newpiv, trace)
       end do

       if (trace) print *, '*** FIN   degre_minimum **'

       return

       END SUBROUTINE degre_minimum
!****************************************************************

!**************** À ÉCRIRE **************************************
       SUBROUTINE CMcK(g, dim, start, perm, nbSets, iperiph, trace, retour)
       implicit none
! Algorithme de Cuthill Mac Kee.
!
! Parametres:
! ----------
! g       (inout): graphe representant la matrice,  le graphe g est modifie.
! dim     (in)   : nombre de noeuds dans de graphe
! start   (in)   : indice du noeud de depart de l'algorithme
!                   si (start == 0) alors le noeud de degre minimum sera
!                                   pris comme noeud de depart
! perm    (out)  : tableau de permutation 
!                   perm(i)=j indique que le noeud j est le ieme pivot. 
! nbSets  (out)  : nombre de "sets" dans l'ordonancement
! iperiph (out)  : Indice de noeud d'un sommet du dernier set
! trace   (in)   : vrai si trace d'execution demandee
! retour  (out)  : parametre de retour, 0 si OK
       integer, intent(in)                               :: dim, start
       type (cell_graphe), dimension(dim), intent(inout) :: g
       integer, intent(out)                              :: perm(dim)
       integer, intent(out)                              :: nbSets, iperiph
       logical, intent(in)                               :: trace  ! vrai si impression demandee
       integer, intent(out)                              :: retour
! variables locales
       integer :: nbpivots, next, degmin, newpiv
       integer :: i, j, ncol, min_ls
! pointeurs permettant de retrouver Si
       integer :: sideb, sifin
! Pointeurs temporaires
       type (cell_graphe), pointer :: rech, courant, prec, new
!
       retour   = 0
       nbpivots = 0
! calcul du premier pivot (celui de degre minimum)
       sideb = 1
       if (start ==0) then
         call pivot_deg_min(g,dim,newpiv,retour)
       else
         newpiv = start
       end if
       if (retour < 0 ) return
! Nouveau pivot trouve : mise a jour du nouvel ordonnancement
       nbpivots         = nbpivots+1
       perm(nbpivots)   = newpiv
       sifin            = nbpivots
! Son degre devient egal a -1
       g(newpiv)%indice = -1
       if (trace) print *, '** S0 = ', newpiv
       do i=1,dim
! construction de Si (toutes les variables adjacentes a Si-1)
         if (trace) print *, ' contruction de S',i, &
                ' sideb, sifin =', sideb, sifin
         min_ls = dim
         do j=sideb,sifin
!        parcourir la liste d'adjacence de j et construire Si
          if (trace) print *, ' adjacence de ',perm(j)
          rech => g(perm(j))%suivant
          do while (associated(rech))
           ncol = rech%indice
           if (g(ncol)%indice /= -1) then
! memorise le sommet du set en cours ayant le plus petit degre
             if (g(ncol)%indice .lt. min_ls) iperiph = ncol
             nbpivots       = nbpivots+1
             if (trace) print *, '** S',i, ' contient: ', ncol
             perm(nbpivots) = ncol
             g(ncol)%indice =-1
           end if
           if (nbpivots == dim) exit 
           rech => rech%suivant
          end do
          nbSets = i
         end do
         if (nbpivots == sifin) then
! aucun noeud adjacent a Si
          if (trace) print *, ' aucun noeud adjacent a S',i-1
          call pivot_deg_min(g,dim,newpiv,retour)
          if (retour < 0 ) return
          nbpivots         = nbpivots+1
          perm(nbpivots)   = newpiv
          g(newpiv)%indice = -1
          if (trace) print *, '** S',i, ' contient: ', newpiv
          nbSets = i
          iperiph = newpiv
         endif
         sideb = sifin+1
         sifin = nbpivots
         if (sifin < sideb ) then
           retour = -2
           print *, ' PB dans la construction de S',i
           return
         end if
         if (nbpivots == dim) exit 
!      end loop on i
       end do 
       if ( nbpivots /= dim) then 
         print *, ' nbpivots, dim = ', nbpivots, dim
         retour = -3
         print *, ' *** ERREUR dans CM '
       end if
       if (trace) print *, '**** FIN   SUBROUTINE CM  '
!
       return
       end SUBROUTINE CMcK
!
!****************************************************************
       SUBROUTINE pivot_deg_min(g, dim, pivot, retour)
       implicit none
!      recherche du pivot de degre minimum du graghe g
       integer, intent(in)                               ::  dim
       type (cell_graphe), dimension(dim), intent(inout) :: g
       integer, intent(out)                              :: pivot
       integer, intent(inout)                            :: retour ! negatif si probleme
! variables locales
       integer :: degmin, j, aux
  
       pivot = dim + 1
       
       if (dim <= 0) then
              retour = -1
       else
              retour = 1
              pivot = 1
              degmin = 2*dim
              do j = 1, dim 
                     if (g(j)%indice /= -1) then
                            aux = g(j)%indice
                            if (aux < degmin) then
                                   pivot = j
                                   degmin = aux
                            end if
                     end if
              end do
       end if              
       return

       end SUBROUTINE pivot_deg_min
!
       END MODULE fsmdcm
