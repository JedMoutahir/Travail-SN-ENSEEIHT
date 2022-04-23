#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>

// Definition du type t_note
// TODO
struct t_note {
    float valeur;
    float coef;
};
typedef struct t_note t_note;

// Definition d'un tableau de notes t_tab_notes de 5 éléments.
// TODO
typedef t_note t_tab_notes[5];

/**
 * \brief Initialiser une note
 * \param[out] note note à initialiser
 * \param[in] valeur nombre de points
 * \param[in] coef coefficient
 * \pre valeur <= 20 && valeur >= 0
 * \pre coef <= 1 && coef >= 0
 */
void initialiser_note(t_note* note, float valeur, float coef){
    assert(valeur <= 20 && valeur >= 0);
    assert(coef <= 20 && coef >= 0);
    // TODO
    note->valeur = valeur;
    note->coef = coef;
    //printf("%f %f %f %f \n", note->valeur, note->coef,  valeur, coef);
}


/**
 * \brief Calculer la moyenne des notes du tableau
 * \param[in] tab_notes tableau de nodes
 * \param[in] nb_notes nombre de notes
 */
float moyenne(t_tab_notes tab_notes, int nb_notes){
    // TODO
    float somme = 0.0;
    for(int i = 0 ; i < nb_notes ; i ++){
        somme += tab_notes[i].valeur * tab_notes[i].coef;
        //printf("%f %f \n", tab_notes[i].valeur, tab_notes[i].coef);
    }
    return somme;
}


int main(void){
    t_tab_notes notes;
    
    //Initialiser les éléments d'une variable tableau à 0.0
    initialiser_note(&notes[0], 10, 0.2);
    initialiser_note(&notes[1], 1, 0.3);
    initialiser_note(&notes[2], 12, 0.5);
    //printf("%f %f \n", notes[1].valeur, notes[1].coef);
    //Calculer la moyenne des 3 notes
    float moy = moyenne(notes, 3);
    printf("%d = %d \n", (int)(moy*100), (int)((10*0.2 + 1*0.3 + 12*0.5)*100));
    assert( (int)(moy*100) == (int)((10*0.2 + 1.5*0.3 + 12*0.5)*100));
    return EXIT_SUCCESS;
}
