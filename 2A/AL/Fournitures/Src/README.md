Contenu de ce repertoire :
==========================

# README: ce fichier
    makefile: makefile permettant de compiler les modules de mise
              en oeuvre et la validation  des codes fortran
# Fichiers pour la mise en oeuvre Fortran 90 de la facto symbolique (FS) et degree minimum (MD):
 * validation.f90 : programme principal utilise a la fois pour MD et RCM
   **(a modifier pour question 4)**
 * definition.f90: module de definition et de manipulation des differentes structures de donnees matrices creuses et graphes associes
   **(a ne pas modifier a priori)**
 * fsmdcm.f90: module implantant les routines necessaires a la mise en oeuvre de la factorization symbolique, du MD et de Cuthil-McKee (CM)
   **(a modifier)**
# Donnees de test:
 * mat0: petite matrice de validation pour les codes F90
 * ../Matrices: repertoire contenant les differentes matrices de validation 
