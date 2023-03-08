#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"


void out_of_place_cast(long n, float *xs, double *xd);
void in_place_cast(long n, float *xs);
void check(long n, float *xs, double *xd);


int main(int argc, char **argv){
  long n, i, s, t;
  long  t_start, t_end;
  float *xs, *xsd;
  double *xd, *xdd;
  
  omp_set_num_threads(4);

  // Command line arguments
  if ( argc == 2 ) {
    n = atoi(argv[1]);    /* size of x */
  } else {
    printf("Usage:\n\n ./main n\n where n is the size of the array to be cast.\n");
    return 1;
  }
  
  xs  = (float*) malloc(n*sizeof(float));
  xd  = (double*) malloc(n*sizeof(double));
  xsd = (float*) malloc(n*sizeof(double));
  xdd = (double*) xsd;

  /* init arrays with random values */
  for(i=0; i<n; i++){
    xs[i] = (float)rand()/(float)(RAND_MAX/10.0);
    xsd[i] = xs[i];
  }

  printf("===== Out-of-place cast (parallel version)=======================================\n");
  t_start = usecs();
  out_of_place_cast(n, xs, xd);
  t_end = usecs();
  printf("Execution   time oop : %8.2f msec.\n",((double)t_end-t_start)/1000.0);
  check(n, xs, xd);

  printf("\n===== In-place cast (parallel version)===========================================\n");
  t_start = usecs();
  in_place_cast(n, xsd);
  t_end = usecs();
  printf("Execution   time  ip : %8.2f msec.\n",((double)t_end-t_start)/1000.0);
  check(n, xs, xdd);

  /* Uncomment this to print the beginning and end of arrays */
  /* printf("\n\n"); */
  /* for(i=0; i<5; i++) */
  /*   printf("%10d -- xs:%8.5f xd:%8.5f  xdd:%8.5f\n",i, xs[i], xd[i], xdd[i]); */
  /* printf("       ...\n"); */
  /* for(i=n-5; i<n; i++) */
  /*   printf("%10d -- xs:%8.5f xd:%8.5f  xdd:%8.5f\n",i, xs[i], xd[i], xdd[i]); */

  return 0;

}


void out_of_place_cast(long n, float *xs, double *xd){
  long i;

  #pragma omp parallel for
  for(i=0; i<n; i++)
    xd[i] = (double) xs[i];

  return;
}

void in_place_cast(long n, float *xs){

  long i, j;
  double *xd;
  
  /* make xd point to the xs array */
  xd = (double*)xs;

  //log 2 of n
  int k = (int) log2(n);
  //printf("k = %d \n", k);

  for(i=0; i<k; i++){
    //printf("i = %d \n", i);
    long beg = (long) pow(2, k-1-i);
    long end = (long) pow(2, k-i);
    //printf("beg = %d \n", beg);
    //printf("end = %d \n", end);

    //The work is split between the threads in the for loop below because the work is independent.
    #pragma omp parallel for
    for(j=beg; j<end; j++){
      //printf("j = %d \n", j);
      xd[j] = (double) xs[j];
    }
  }
  xd[0] = (double) xs[0];
}

void check(long n, float *xs, double *xd){

  long i;
  double max, d;

  max = 0;
  for(i=0; i<n; i++){
    d = fabs((((double)xs[i])-xd[i])/((double)xs[i]));
    if(d>max) max=d;
  }

  printf("Maximum difference is %f\n",max);
  /* Normally, max should be equal to zero... */
  if(max<1e-6){
    printf("The result is correct.\n");
  } else {
    printf("The result is wrong!!!\n");
  }
}


/*
  For the parallel version of out_of_place_cast, the execution time is 3.5 times faster than the sequential version.
  The improvement is due to the fact that the parallel version is able to split the work between the 4 threads.
  And since the work is independent, the threads can work in parallel.
  However it need 1.5 times as much memory as the in_place_cast version.
  And the improvement in speed is not 4 times as fast as the sequential version because the parallel version needs to create the threads and to synchronize them.

  For the parallel version of in_place_cast, the execution time is also 3.5 times faster than the sequential version.
  The improvement is due to the fact that the parallel version is able to split the work between the 4 threads.
  And since the work is independent, the threads can work in parallel.
  However the implementation of the in_place_cast i shard to understand and only works for a specific size of the array (a power of 2).
  But this implementation is able to use the exact minimum amount of memory needed. This is a 1.5 time improvement over the out_of_place_cast version.
*/

/*
  Time for n = 2^29

  for num_threads = 4
  ===== Out-of-place cast (parallel version)=======================================
  Execution   time oop :   434.63 msec.
  Maximum difference is 0.000000
  The result is correct.

  ===== In-place cast (parallel version)===========================================
  Execution   time  ip :   434.08 msec.
  Maximum difference is 0.000000
  The result is correct.

  for num_threads = 2
  ===== Out-of-place cast (parallel version)=======================================
  Execution   time oop :  728.24 msec.
  Maximum difference is 0.000000
  The result is correct.

  ===== In-place cast (parallel version)===========================================
  Execution   time  ip :  567.23 msec.
  Maximum difference is 0.000000
  The result is correct.

  for num_threads = 1
  ===== Out-of-place cast (parallel version)=======================================
  Execution   time oop :  1373.18 msec.
  Maximum difference is 0.000000
  The result is correct.

  ===== In-place cast (parallel version)===========================================
  Execution   time  ip :  898.18 msec.
  Maximum difference is 0.000000
  The result is correct.
  
*/