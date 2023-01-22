#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char** argv) {
    int n;
    printf("Combien de processus souhaitez-vous créer ? ");
    scanf("%d", &n);

    if (fork() == 0) {
        execl("/usr/bin/java", "java", "CompteurTest", NULL);
    } else {
        sleep(3);

        for (int i = 0; i < n - 1; i++) {
			if (fork() == 0) {
				execl("/usr/bin/java", "java", "CompteurTest", NULL);
			} 
		}
    }

    return 0;
}