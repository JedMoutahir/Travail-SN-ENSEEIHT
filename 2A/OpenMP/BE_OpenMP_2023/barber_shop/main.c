#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"

void barber_shop_seq(int nbarbs, int nchairs);
void barber_shop_par_fixed(int nbarbs, int nchairs);
void barber_shop_par_any(int nbarbs, int nchairs);

int main(int argc, char **argv){
  long nbarbs, nchairs, nclients;
  long  t_start, t_end;
  float *xs, *xsd;
  double *xd, *xdd;
  
  // Command line arguments
  if ( argc == 4 ) {
    nbarbs   = atoi(argv[1]);    /* number of barbers */
    nchairs  = atoi(argv[2]);    /* number of chairs */
    nclients = atoi(argv[3]);    /* number of clients */
    if(nbarbs<=nchairs){
      printf("Please set nbarbs > nchairs.\n");
      return 1;
    }
  } else {
    printf("Usage:\n\n ./main nbarbs nchairs nclients\n where nbarbs is the number of barbers, nchairs the number of chairs and nclients the number of clients.\n");
    return 1;
  }

  init_data(nbarbs, nchairs, nclients);
  
 
  printf("\n\n========= Sequential ==================================================\n");
  t_start = usecs();
  barber_shop_seq(nbarbs, nchairs);
  t_end = usecs();
  printf("Execution   time oop : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  check_and_cleanup();

  printf("\n\n========= Parallel with assigned chair ================================\n");
  
  t_start = usecs();
  barber_shop_par_fixed(nbarbs, nchairs);
  t_end = usecs();
  printf("Execution   time  ip : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  check_and_cleanup();

  printf("\n\n========== Parallel with any chair ====================================\n");
  
  t_start = usecs();
  barber_shop_par_any(nbarbs, nchairs);
  t_end = usecs();
  printf("Execution   time  ip : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  check_and_cleanup();

  return 0;

}

void barber_shop_seq(int nbarbs, int nchairs){

  int barber, client, chair;
  
  barber = 0;

  for(;;){

    client = receive_client();

    /* No more clients to serve */
    if(client<0) break;
    
    chair = barber%nchairs;

    serve_client(barber, client, chair);

  }

}



/*
A barber can only use one chair.
Each barber has an integer identifier :
barber = {0, 1, ..., nbarbs − 1}
and the same for each chair :
chair = {0, 1, ..., nchairs − 1}.
Therefore, in this scenario, each barber can only
use chair = barber%nchairs.
You can't receive multiple clients at the same time.
You can't use a chair already in use
*/

//parallel version of barber_shop_seq with fixed chairs for each barber using omp
void barber_shop_par_fixed(int nbarbs, int nchairs){

  int barber, client, chair;
  
  omp_lock_t *chair_locks;
  chair_locks = (omp_lock_t *) malloc(nchairs*sizeof(omp_lock_t));
  for(chair = 0; chair < nchairs; chair++){
    omp_init_lock(&chair_locks[chair]);
  }

  omp_set_num_threads(nbarbs);

  #pragma omp parallel for private(barber, client, chair)
  for(barber = 0; barber < nbarbs; barber++){

    for(;;){

      client = receive_client();

      /* No more clients to serve */
      if(client<0) break;
      
      chair = barber%nchairs; //assign a chair to the barber

      omp_set_lock(&chair_locks[chair]); //lock the chair
      serve_client(barber, client, chair); //serve the client
      omp_unset_lock(&chair_locks[chair]); //unlock the chair
    }

  }
}


//parallel version of barber_shop_seq with any chair for each barber using omp
void barber_shop_par_any(int nbarbs, int nchairs){

  int barber, client, chair;
  
  omp_lock_t *chair_locks;
  chair_locks = (omp_lock_t *) malloc(nchairs*sizeof(omp_lock_t));
  for(chair = 0; chair < nchairs; chair++){
    omp_init_lock(&chair_locks[chair]);
  }

  omp_set_num_threads(nbarbs);

  #pragma omp parallel for private(barber, client, chair)
  for(barber = 0; barber < nbarbs; barber++){

    for(;;){

      client = receive_client();

      /* No more clients to serve */
      if(client<0) break;
      
      chair = -1; //assign a chair to the barber
      while(chair == -1){
        for(int i = 0; i < nchairs; i++){
          if(omp_test_lock(&chair_locks[i]) == 1){
            chair = i;
            break;
          }
        }
      }

      if(chair == -1){
        printf("No chairs available for barber %d and client %d \n", barber, client);
        continue;
      } else {
        serve_client(barber, client, chair); //serve the client
        omp_unset_lock(&chair_locks[chair]); //unlock the chair
      }
    }
  }
}

