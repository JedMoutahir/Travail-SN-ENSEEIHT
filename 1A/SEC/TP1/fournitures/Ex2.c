#include <stdio.h>
#include <unistd.h>
#include <stdlib.h> /* exit */

int main(int argc, char *argv[]) {
    char *args[3];

    args[0] = "/bin/ls";        // first arg is the full path to the executable
    args[1] = "-l";
    args[2] = argv[1];
    int flag = 0;
    flag = execv(args[0], args);
    printf("fichier introuvable\n");
    return EXIT_FAILURE;
}
