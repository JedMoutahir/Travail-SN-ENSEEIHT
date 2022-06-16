#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <fcntl.h>

#define BUFSIZE 32

int main(int argc, char **argv) {

  int fichierSource;
  int fichierDestination;
  char buffer[BUFSIZE];

  bzero(buffer, sizeof(buffer));
  
  fichierSource = open(argv[1], O_RDONLY);

  if (fichierSource < 0) {
      perror("Erreur lors de l'ouverture du fichier source\n");
      exit(1);
    }
    
  fichierDestination = open(argv[2], O_CREAT | O_WRONLY | O_TRUNC, S_IRWXU | S_IRWXG | S_IRWXO);

  if (fichierDestination < 0) {
    perror("Erreur lors de l'ouverture du fichier destination\n");
    exit(1);
  }
  printf("ouverture ok\n");
  int nbLu = read(fichierSource, buffer, sizeof(buffer));
  while (nbLu > 0) {
      if (write(fichierDestination, buffer, nbLu) < 0) {
        perror("Erreur lors de l'ecriture du fichier destination\n");
        exit(1);
      }
      nbLu = read(fichierSource, buffer, sizeof(buffer));
    }
    bzero(buffer, sizeof(buffer));
    printf("lecture/ecriture ok\n");
    
  if (close(fichierSource) < 0) {
      perror("Erreur lors de la fermeture du fichier source\n");
      exit(1);
    }
    
  if (close(fichierDestination) < 0) {
    perror("Erreur lors de la fermeture du fichier destination\n");
    exit(1);
  }
  printf("fermeture ok\n");
  return EXIT_SUCCESS;
}
