#include <stdio.h>    
#include <stdlib.h>   
#include <unistd.h>   
#include <sys/wait.h> 
#include <string.h>   
#include <fcntl.h>    

int main(int argc, char **argv) {
  
  int descripteurFichier, j;   
  int N = 30;                 
  char fichier[] = "temp.txt"; 
  pid_t pid1, pid2;                   

  pid1 = fork();
  
  if (pid1 < 0) {
    perror("Erreur lors du fork");
    exit(1);
  }
  
  if (pid1 != 0) {
    pid2 = fork();
    
    if (pid2 == 0) {
      
        descripteurFichier = open(fichier, O_WRONLY | O_CREAT | O_TRUNC, S_IRWXU | S_IRWXG | S_IRWXO);
        if (descripteurFichier < 0) {
          perror("Erreur d'ouverture!");
          exit(1);
        }
        for (int i = 1; i <= N; i++) {
          sleep(1); 
          if (write(descripteurFichier, &i, sizeof(int)) < 0) {
            perror("Erreur d'ecriture!");
            exit(1);
          }
          printf("ecriture de %d\n", i);
          if (i % 10 == 0) {
            if (lseek(descripteurFichier, 0, SEEK_SET) < 0) {
              perror("Erreur LSEEK ! ");
              exit(1);
            }
            //printf("retour au debut du fichier\n");
          }
        }
        if (close(descripteurFichier) < 0) {
          perror("Erreur fermeture de temp.txt!");
          exit(1);
        }
        exit(0);
      }
  } else {
    descripteurFichier = open(fichier, O_RDONLY, S_IRWXU | S_IRWXG | S_IRWXO);
    if (descripteurFichier < 0) {
      perror("Erreur ouverture de temp.txt!");
      exit(1);
    }
    sleep(1);
    for (int i = 1; i <= N/10; i++) {
      sleep(10);
      while (read(descripteurFichier, &j, sizeof(int))) {
        printf("%d\n", j);
      }
      if (lseek(descripteurFichier, 0, SEEK_SET) < 0) {
        perror("Erreur LSEEK! ");
        exit(1);
      }
    }
    if (close(descripteurFichier) < 0) {
      perror("Erreur fermeture de temp.txt!");
      exit(1);
    }
  }
  return EXIT_SUCCESS;
}
