#include "aux.h"
#include "omp.h"


int main(int argc, char **argv){
  long t_start, t_end;
  int  l, t, L, T;
  Token token;
  
  if ( argc == 3 ) {
    L = atoi(argv[1]);    /* number of loops */
    T = atoi(argv[2]);    /* number of threads */
  } else {
    printf("Usage:\n\n ./main L T\n\nsuch that L is the number of loops and T the number of threads to use.\n");
    return 1;
  }

  init(&token, L, T);

#pragma omp parallel private(l,t)
  {
    for(l=0; l<L; l++){
      printf("Loop %2d\n",l);
      for(t=0; t<T; t++)
        {
          if(t==omp_get_thread_num()) process(&token);
#pragma omp barrier
        }
    }
  }
  
  check(&token, L, T);

  
  return 0;
}
