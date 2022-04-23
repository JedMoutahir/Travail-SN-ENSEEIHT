#include <stdlib.h> 
#include <stdio.h>

#define PI 3.141592 // déclaration d'une constante pré-processeur 18, 

int main(){
    int r = 15;
    float aire = (float) r*r * PI;
    float perim = (float) r * 2 * PI;
    printf("Périmètre : %f \nAire : %f", perim, aire);
    return EXIT_SUCCESS;
}
