#include "aux.h"
#include "omp.h"

void loop1(int n){

  long   t_start, t_end;
  double time_it, load;
  int i;
  double *loads;
  double maxload, minload;
  
  load = 0.0;
#pragma omp parallel private(t_start,t_end, time_it)
  {
    
#pragma omp single
    loads = (double*)malloc(omp_get_num_threads()&*sizeof(double));

    loads[omp_get_thread_num()]=0.0;
    
#pragma omp for schedule(static,2)
    for(i=0; i<n; i++){
      t_start=usecs();
      func1(i,n);
      time_it = (double)(usecs()-t_start);
      loads[omp_get_thread_num()]+=time_it;
      if(n<=20) printf("Iteration %6d  of loop 1 took %.2f usecs\n",i, time_it);
    }

    #pragma omp single
    {
      maxload=0;
      minload=100000000;
      /* for(i=0; i<omp_get_num_threads(); i++){ */
      /*   if(loads[i]>maxload) maxload=loads[i]; */
      /*   if(loads[i]<minload) minload=loads[i]; */
      /* } */
    }

#pragma omp critical
    {
        if(loads[omp_get_thread_num()]>maxload) maxload=loads[i];
        if(loads[omp_get_thread_num()]<minload) minload=loads[i];
    }

    
  }

  

  
}


void loop2(int n){

  long   t_start, t_end;
  double time_it, load;
  int i;

  load = 0.0;
  
#pragma omp parallel
  {
#pragma omp for schedule(dynamic,2)
    for(i=0; i<n; i++){
      t_start=usecs();
      func2(i,n);
      time_it = (double)(usecs()-t_start);
      load+=time_it;
      if(n<=20) printf("Iteration %6d  of loop 2 took %.2f usecs\n",i, time_it);
    }
  }
}

void loop3(int n){

  long   t_start, t_end;
  double time_it, load;
  int i;

  load = 0.0;
  
#pragma omp parallel
  {
#pragma omp for schedule(dynamic,2)
    for(i=0; i<n; i++){
      t_start=usecs();
      func3(i,n);
      time_it = (double)(usecs()-t_start);
      load+=time_it;
      if(n<=20) printf("Iteration %6d  of loop 3 took %.2f usecs\n",i, time_it);
  }
  }

}


int main(int argc, char **argv){
  int    i, j, n;

  // Command line argument
  if ( argc == 2 ) {
    n = atoi(argv[1]);    /* the number of loop iterations */
  } else {
    printf("Usage:\n\n ./main n \n\nwhere n is the number of iterations in the loops\n");
    return 1;
  }

  printf("\n");
  
  loop1(n);
  
  printf("\n");

  loop2(n);
  
  printf("\n");

  loop3(n);
  
  printf("\n");
  
  return 0;
}
