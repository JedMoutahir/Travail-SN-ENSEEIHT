#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h> /* définit mmap  */
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main (int argc, char *argv[])
{
 int fin, fout, taille;
 char *src, *dst;
 char qq [1];
 struct stat statbuf;

 if (argc != 3) {
   printf("usage: %s <fichier source> <fichier destination>\n", argv[0]);
   exit(1);
 }
 /* ouvrir source */
 /* à faire */

 /* recuperer la taille de la source */
 /* à faire */

 /* coupler source */
 /* à faire */


 /* ouvrir destination */
 /* à faire */
 
 /*	Note : le mode O_RDWR (plutôt que O_WRONLY) est nécessaire car mmap impose 
 	qu'un fichier couplé soit toujours (au moins) ouvert en lecture
 */

 /* ajuster la taille du fichier destination à la taille du fichier source */
 /* à faire */

 /*	Note : 
 	Pourquoi ajuster ? 
 	------------------
 	mmap ne spécifie pas quel est le resultat d'une ecriture *apres* la fin d'un fichier
	couplé (SIGBUS est une possibilite, frequente). Il faut donc fixer la taille du 
	fichier destination à la taille du fichier source *avant* le couplage.
	Comment ajuster ?
	-----------------
	 Le plus simple est d'utiliser truncate, 
	 mais vous pouvez utiliser lseek(a la taille du fichier source) + write d'un octet, 
	 que vous connaissez déjà 
 */
 	
 /* coupler destination */
 /* à faire */
 
 /* Note : MAP_SHARED est necessaire pour que les ecritures soient visibles 
 	dans le fichier */

 /* la copie est le plus facile :) */
 /* à faire */

 exit(0);
}