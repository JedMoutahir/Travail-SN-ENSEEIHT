#include <stdio.h>
#include <unistd.h>
#include <stdlib.h> /* exit */

int main() {
    int flag;
    while(1) {
        char buf[30]; /* contient la commande saisie au clavier */
        int ret; /* valeur de retour de scanf */
        if(ret == EOF){
        	printf("Salut\n");
        	break;
        }
        if(fork()==0){
            flag = execlp(buf, buf, (char*) NULL);
            printf("\nFAILURE\n");
            printf("entrer une commande : ");
            exit(0);
        } else {
        	printf("SUCCESS\n");
		ret = scanf("%s", buf); /* lit et range dans buf la chaine entrée au clavier */
		printf("\n");
        	wait();
        }
    }
    return EXIT_SUCCESS;
}
