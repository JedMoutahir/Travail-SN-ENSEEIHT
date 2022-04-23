#include <stdlib.h> 
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>

// Definition du type monnaie
// TODO 
struct monnaie {
    float valeur;
    char devise;
};
typedef struct monnaie monnaie;

typedef monnaie t_porte_monnaie[5];
/**
 * \brief Initialiser une monnaie 
 * \param[]
 * \pre 
 * // TODO
 */ 
void initialiser(monnaie* mon, float valeur, char devise){
    //assert(valeur > 0);
    // TODO
    mon->valeur = valeur;
    mon->devise = devise;
}


/**
 * \brief Ajouter une monnaie m2 à une monnaie m1 
 * \param[]
 * // TODO
 */ 
bool ajouter(monnaie* m1, monnaie* m2){
    // TODO
    //printf("%c %c \n", m1->devise, m2->devise);
    if(m1->devise == m2->devise){
        m1->valeur += m2->valeur;
        return true;
    } else {
        return false;
    }
}


/**
 * \brief Tester Initialiser 
 * \param[]
 * // TODO
 */ 
void tester_initialiser(){
    // TODO
    monnaie m;
    
    //Initialiser les éléments d'une variable tableau à 0.0
    initialiser(&m, 10, 'e');
    printf("%f %c \n", m.valeur, m.devise);
}

/**
 * \brief Tester Ajouter 
 * \param[]
 * // TODO
 */ 
void tester_ajouter(){
    // TODO
    monnaie m1;
    monnaie m2;
    monnaie m3;
    initialiser(&m1, 10, 'e');
    initialiser(&m2, 5.5, 'e');
    initialiser(&m3, 3.2, '$');
    assert(ajouter(&m1, &m2));
    assert(m1.valeur == 15.5);
    assert(!ajouter(&m1, &m3));
}



int main(void){
    tester_initialiser();
    tester_ajouter();
    // Un tableau de 5 monnaies
    // TODO
    t_porte_monnaie porte_monnaie;
    //Initialiser les monnaies
    // TODO
    for(int i = 0 ; i < 5 ; i++){
        float val;
        char dev;
        printf("valeure devise \n");
        scanf("\n%f %c", &val, &dev);
        initialiser(&porte_monnaie[i], val, dev);
    }
    // Afficher la somme des toutes les monnaies qui sont dans une devise entrée par l'utilisateur.
    // TODO
    char devise;
    printf("devise : \n");
    scanf("\n%c", &devise);
    monnaie somme;
    initialiser(&somme, 0.0, devise);
    
    for(int i = 0 ; i < 5 ; i++){
        ajouter(&somme, &porte_monnaie[i]);
    }
    printf("Total de %c : %f\n", devise, somme.valeur);
    return EXIT_SUCCESS;
}
