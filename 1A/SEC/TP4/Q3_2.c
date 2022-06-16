#include <stdio.h>    /* Input & Output */
#include <stdlib.h>   /* exit */
#include <unistd.h>   /* Basic primitives : fork, read, write, ...*/
#include <fcntl.h>    /* Files operations */
int main (int argc, char** argv) {

    int p[2];
    int unEntier = 27;
    
    pipe(p);

    pid_t pidFils = fork();
    
    if(pidFils == 0){
        int entierLu;
        read(p[0], &entierLu, sizeof(int));
        printf("entier lu : %d\n", entierLu);
    } else {
        write(p[1], &unEntier, sizeof(int));
    }
    
    close(p[1]);
    close(p[0]);
    return EXIT_SUCCESS ;
}
