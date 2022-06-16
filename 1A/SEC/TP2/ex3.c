#include <stdio.h>    /* entrées/sorties */
#include <unistd.h>   /* primitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <setjmp.h>

int main () {
    jmp_buf saut;

    int loc = 0;
    
    setjmp(saut);
    
    printf("%d\n", loc);
    loc++;
    
    if(loc < 1){
        longjmp(saut, 0);
    }
    
    printf("%d\n", loc);
    
    return EXIT_SUCCESS;
}
