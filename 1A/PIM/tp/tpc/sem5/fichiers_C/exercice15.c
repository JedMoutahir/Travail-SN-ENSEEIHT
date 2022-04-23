#include <stdlib.h> 
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>

#define CAPACITE 20
// Definition du type tableau
typedef float t_tableau[CAPACITE];
// TODO 

/**
 * \brief Initialiser les éléments d'un tableau de réels avec 0.0
 * \param[out] tab tableau à initialiser
 * \param[in] taille nombre d'éléments du tableau
 * \pre taille <= CAPACITE
 */ 
void initialiser(t_tableau tab, int taille){
    assert(taille <= CAPACITE);
    // TODO
    for (int i = 0 ; i <= taille ; i++){
        tab[i] = 0.0;
    }
}

/**
 * \brief le tableau est-il vide ?
 * \param[in out] tab tableau à tester
 * \param[in] taille nombre d'éléments du tableau
 * \pre taille <= CAPACITE
 */ 
bool est_vide(t_tableau tab, int taille){
    assert(taille <= CAPACITE);
    bool vide = false;
    // TODO
    for (int i = 0 ; i <= taille ; i++){
        vide = tab[i] == 0.0;
        if(!vide){
            return false;
        }
    }
    return vide;
}

int main(void){
    t_tableau T;
    //Initialiser les éléments d'une variable tableau à 0.0
    initialiser(T, 10);
    //Vérifier avec assert que tous les éléments vallent bien 0.0
    assert(est_vide(T, 10));
    
    return EXIT_SUCCESS;
}
