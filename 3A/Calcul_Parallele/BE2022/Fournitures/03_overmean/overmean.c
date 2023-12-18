#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <mpi.h>

int main(int argc, char* argv[]) { 

  // comment this line, if you want the same vector for each run
  srand( time( NULL ) );

  MPI_Init(&argc, &argv);

  // Get number of processes
  int nb_process;
  MPI_Comm_size(MPI_COMM_WORLD, &nb_process);

  // Fix root's rank
  int root_rank = 0;

  // Get my rank
  int my_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

  // global size (only the root know its value)
  int global_size = 0;
  // local size (we fix this value in order to be regular)
  int local_size = 3;
  // local vector
  int *local_vector = NULL;
  int *global_vector = NULL;

  // root process
  if(my_rank == root_rank) {
    global_size = nb_process*local_size; // to be able to split
                                         // the global vector into sub-vectors
                                         // with the same size
    printf("global_size = %d\n", global_size); 
    global_vector = (int *) malloc(sizeof(int)*global_size);
    for(int i = 0; i < global_size; i++) {
      //global_vector[i] = i;
      global_vector[i] = rand() % 101;
      printf("global_vector[%d] = %d\n", i, global_vector[i]); 
    }
  }
  // Each process gets its part of the global vector
  local_vector = (int *) malloc(sizeof(int)*local_size);
  MPI_Scatter(global_vector, local_size, MPI_INT, local_vector, local_size, MPI_INT, root_rank, MPI_COMM_WORLD);

  for(int i = 0; i < local_size; i++) {
    printf("[%d] local_vector[%d] = %d\n", my_rank, i, local_vector[i]); 
  }

  // compute the local sum
  int local_sum = 0.0;

  for(int i = 0; i < local_size; i++) {
    local_sum += local_vector[i];
  }
  printf("Process %d computed its local sum = %d.\n", my_rank, local_sum);

  // compute the global sum by a reduction on process 0
  int global_sum;
  
  MPI_Reduce(&local_sum, &global_sum, 1, MPI_INT, MPI_SUM, root_rank, MPI_COMM_WORLD);

  if(my_rank == root_rank) printf("Process %d got the global sum = %d.\n", my_rank, global_sum);

  float mean; // float!!

  // the root computes the mean (only one to know the global size)
  if(my_rank == root_rank) {
    mean = ((float) global_sum) / global_size;
    printf("Process %d computed the mean = %f.\n", my_rank, mean);
  }

  // broadcast of the mean to all process
  MPI_Bcast(&mean, 1, MPI_FLOAT, root_rank, MPI_COMM_WORLD);

  // compute the number of values (from the local vector) over the mean
  int local_number = 0;
  for(int i = 0; i < local_size; i++) {
    if(local_vector[i] >= mean) local_number++;
  }
  printf("Process %d has %d values over the mean.\n", my_rank, local_number);

  int over_the_mean;
  // reduce these numbers on root process
  MPI_Reduce(&local_number, &over_the_mean, 1, MPI_INT, MPI_SUM, root_rank, MPI_COMM_WORLD);

  // Compute overthe mean on root process sequentially
  int root_over_the_mean = 0;
  if(my_rank == root_rank) {
    for(int i = 0; i < global_size; i++) {
      if(global_vector[i] >= mean) root_over_the_mean++;
    }
  }

  if(my_rank == root_rank) printf("the total number of values over the mean is %d.\n the sequtial computation gives %d.\n", over_the_mean, root_over_the_mean);

  MPI_Finalize();

  return EXIT_SUCCESS;
}
