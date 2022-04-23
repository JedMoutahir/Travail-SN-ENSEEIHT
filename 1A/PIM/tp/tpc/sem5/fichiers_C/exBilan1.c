/** Squelette du programme **/
/*********************************************************************
 *  Auteur  : MOUTAHIR Jed
 *  Version : 1.0.0
 *  Objectif : Conversion pouces/centimètres
 ********************************************************************/

#include <stdio.h>
#include <stdlib.h>

#define UN_POUCE 2.54
float valeur, lg_cm, lg_p;
char unité;
int main()
{

    /* Saisir la longueur */
    printf("%s", "Entrer une longueur (valeur + unité) : ");
    scanf("%f %c", &valeur, &unité);
    
    /* Calculer la longueur en pouces et en centimètres */
    switch(unité) {
        case 'p' : case 'P' :
            lg_p = valeur;
            lg_cm = lg_p * UN_POUCE;
            break;
        case 'c' : case 'C' :
            lg_cm = valeur;
            lg_p = lg_cm / UN_POUCE;
            break;
        case 'm' : case 'M' :
            lg_cm = valeur * 100;
            lg_p = lg_cm / UN_POUCE;
        default :
            lg_p = 0.0;
            lg_cm = 0.0;
            break;
    }
    
    /* Afficher la longueur en pouces et en centimètres */
    printf("%f p = %f cm \n", lg_p, lg_cm);
    return EXIT_SUCCESS;
}
