#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/types.h>

void garnir(char zone[], int lg, char motif) {
	int ind;
	for (ind=0; ind<lg; ind++) {
		zone[ind] = motif ;
	}
}

void lister(char zone[], int lg) {
	int ind;
	for (ind=0; ind<lg; ind++) {
		printf("%c",zone[ind]);
	}
	printf("\n");
}

int main(int argc,char *argv[]) {
	int taillepage = sysconf(_SC_PAGESIZE);
    int i;
    int n;
    int status;
    char * b;
    /*Descripteur fichier.*/
    int fd;

    /*Ouverture du fichier.*/
    fd = open("Test", O_WRONLY | O_CREAT | O_TRUNC,00777);
    
    if (fd == -1) {
        perror("Open : 1 ");
        exit(1);
    }
    
    /*Ecriture des deux pages de 'a'.*/
    for( i =1; i<= taillepage; i++) {
        if (write(fd,"aa",2) == -1) {
            perror("Write :");
            exit(1);
        }
    }

    /*Fermeture du fichier.*/
    if (close(fd) == -1) {
        perror("Close :");
        exit(1);
    }

    /*Ouverture du fichier en Lecture/Ecriture */
    fd = open("Test", O_RDWR,00777);
    if (fd == -1) {
        perror("Open : 2 ");
        exit(1);
    }
    
    /*Couplage du segment mémoire et du fichier.*/
    b = mmap(0, 2*taillepage, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

    /*Création du processus fils.*/
    switch(n = fork()) {
       case -1 :
            perror("fork :");
            exit(1);
		 
       case 0 : 
            sleep(2);
            
	        /*Récupération et affichage des 10 premiers octets des deux pages.*/
		    printf("10 premiers octets de la 1ere page : \n");	
	        lister(b, 10);
		    printf("10 premiers octets de la 2ieme page : \n");	
	        lister(b+taillepage, 10);
		    
		    for (i=0;i<taillepage;i++) {
		        b[i] = 'c';
		    }
		    break;
		    
       default : 
            /*Remplissage des 10 premiers caracteres de la page deux avec 'b'*/
            for (i=0;i<taillepage;i++) {
               b[taillepage+i] = 'b';
            }
		
		    /*Attendre la fin du fils.*/
		    waitpid(n,&status,WUNTRACED);
		
            /*Affichage des 10 premiers octets de la premiere page.*/
            printf("10 premiers octets de la 1ere page : \n");
            lister(b, 10);
            break;
	     }
   return 0;
}
