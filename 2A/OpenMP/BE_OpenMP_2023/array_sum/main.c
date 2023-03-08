#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"

double superfast_sum_par(long n, double *x);

int main(int argc, char **argv){
  long n, i;
  long  t_start, t_end;
  double *x, *y, ss, ps;
  
  // Command line arguments
  if ( argc == 2 ) {
    n = atoi(argv[1]);    /* size of x */
  } else {
    printf("Usage:\n\n ./main n\n where n is the size of the array.\n");
    return 1;
  }
  
  x  = (double*) malloc(n*sizeof(double));
  y  = (double*) malloc(n*sizeof(double));

  /* init arrays with random values */
  for(i=0; i<n; i++){
    x[i] = (float)rand()/(float)(RAND_MAX/10.0);
    y[i] = x[i];
  }
  
  printf("===== Sequential sum =======================================\n");
  t_start = usecs();
  ss = superfast_sum(n, x);
  t_end = usecs();
  printf("Execution   time seq : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  printf("\n===== Parallel   sum =======================================\n");
  t_start = usecs();
  ps = superfast_sum_par(n, y);
  t_end = usecs();
  printf("Execution   time par : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  if(fabs((ss-ps)/ss) < 1e-12){
    printf("The result is correct.\n");
  } else {
    printf("The result is wrong.\n");
  }
  return 0;

}


//parallel version of superfast_sum with openmp by using as much as possible superfast_sum
double superfast_sum_par(long n, double *x){
  double sum = 0.0;
  int i;
  int num_threads = omp_get_max_threads();
  double *sums = (double*) malloc(num_threads*sizeof(double));
  int chunk_size = n/num_threads;
  int chunk_size_last = n - (num_threads-1)*chunk_size;
  #pragma omp parallel for private(i) shared(x, sums)
  for(i=0; i<num_threads; i++){
    if(i == num_threads-1){
      sums[i] = superfast_sum(chunk_size_last, x+i*chunk_size);
    } else {
      sums[i] = superfast_sum(chunk_size, x+i*chunk_size);
    }
  }
  for(i=0; i<num_threads; i++){
    sum += sums[i];
  }
  return sum;
}
 
