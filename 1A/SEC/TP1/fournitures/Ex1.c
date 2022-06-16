# include <stdio.h> /* printf */
# include <unistd.h> /* fork */
# include <stdlib.h> /* EXIT_SUCCESS */

int main() {
    while(1){
    	printf("still running\n");
    	sleep(1);
    }
    return EXIT_SUCCESS ;
}
