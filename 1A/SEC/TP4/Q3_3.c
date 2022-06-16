#include <stdio.h>    /* Input & Output */
#include <stdlib.h>   /* exit */
#include <unistd.h>   /* Basic primitives : fork, read, write, ...*/
#include <fcntl.h>    /* Files operations */
int main (int argc, char** argv) {

    int p[2];
    int N = 10;
    
    pipe(p);
    
    pid_t pidFils = fork();
    
    if(pidFils == 0){
        close(p[1]);
        int entierLu;
        int ret = read(p[0], &entierLu, sizeof(int));
        while(ret > 0){
            printf("entier lu : %d\n", entierLu);
            printf("retour read : %d\n", ret);
            ret = read(p[0], &entierLu, sizeof(int));
        }
        close(p[0]);
        printf("sortie de boucle\n");
        return EXIT_SUCCESS;
    } else {
        close(p[0]);
        for(int i = 1; i < N ; i++){
            write(p[1], &i, sizeof(int));
        }
        pause();
        close(p[1]);
    }
    
    return EXIT_SUCCESS;
}
