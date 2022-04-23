#include <stdlib.h> 
#include <stdio.h>

int main(int argc, char* argv[]){
    printf("Les arguments sont : \n");
    // Afficher ici les argc arguments
    for(int i = 0 ; i < argc ; i++){
        printf("%s ", argv[i]);
    }
    printf("\n");
    return EXIT_SUCCESS;
}
