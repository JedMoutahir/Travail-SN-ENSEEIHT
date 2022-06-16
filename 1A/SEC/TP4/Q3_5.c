#include <stdio.h>    /* Input & Output */
#include <stdlib.h>   /* exit */
#include <unistd.h>   /* Basic primitives : fork, read, write, ...*/
#include <fcntl.h>    /* Files operations */
int main (int argc, char** argv) {

    int p[2];
    int N = 10;
    uint8_t Tab[N];
    
    pipe(p);
    
    pid_t pidFils = fork();
    
    if(pidFils == 0){
        close(p[1]);
        int entierLu;
        int ret = read(p[0], &entierLu, sizeof(int));
        while(entierLu > 0){
            printf("entier lu : %d\n", entierLu);
            printf("retour read : %d\n", ret);
        }
        close(p[0]);
        printf("sortie de boucle\n");
        return EXIT_SUCCESS;
    } else {
        close(p[0]);
        int ret;
        while(1){
            for(int i = 0; i < N ; i++){
                ret = write(p[1], &Tab[i], sizeof(uint8_t));
            }
            sleep(1);
            printf("retour read : %d\n", ret);
        }
        close(p[1]);
    }
    
    return EXIT_SUCCESS;
}
