#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>

void multAv(double x[], double *A, double y[], int m, int n);

void init0(double x[], int n);

double dot(double x[], double y[], int n);

int main(int argc, char* argv[]) {

    int size;
    int const n = 12;
    int my_rank;
    double local_dot, global_dot, normA, reference;

    MPI_Init(&argc, &argv);
 
    // Get number of processes and check that 4 processes are used
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if(size != 4) {
      printf("This application is meant to be run with 4 MPI processes.\n");
      MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE);
    }
 
    // Get my rank
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

    //  Declaration and Initialization of A (one for all components)
    //  the blocking on rows, b, is the same for all nodes
    //  (if you don't change the constants)
    int b = n / size;
    double *A;

    A = (double *) malloc(b*n*sizeof(double));

    for(int i = 0; i < b; i++){
      for(int j = 0; j < n; j++){
	A[i*n + j] = 1.0;
        reference = 66.000000; // sum_{i=1}^{12-1}
	//A[i*n + j] = (double) my_rank;
        //reference = 97.488461;
	//A[i*n + j] = (double) my_rank*(i+1)+(j+1);
        //reference = 239.899979;
        //printf("Process [%d], A[%d][%d] = %f\n", my_rank, i, j, A[i*n+j]);
      }
    }

    // reference vector to verify that the global vector is correct
    double v_ref[n];
    for(int i = 0; i < n; i++){
      v_ref[i] = (double) i;
    }

    // local vector
    double x_local[b];
    for(int i = 0; i < b; i++){
      x_local[i] = (double) b*my_rank + i;
      //printf("Process [%d], v_local[%d] = %f\n", my_rank, i, v_local[i]);
    }

    // global vector
    double x_global[n];
    init0(x_global, n);

    // Use a collective communication in order to gather on ALL the nodes the
    // part of the local vector into the global vector
    MPI_Allgather(x_local, b, MPI_DOUBLE, x_global, b, MPI_DOUBLE, MPI_COMM_WORLD);

    // the node 2 checks if the global vector is correct (should be 0 for all components)
    if(my_rank == 2) {
      for(int i = 0; i < n; i++){
	      printf("Process [%d], vérif[%d] = %f\n", my_rank, i, x_global[i]-v_ref[i]);
      }
    }

    MPI_Barrier(MPI_COMM_WORLD);

    // vector y_local = A * x_global
    double y_local[b];
    init0(y_local, b);

    // Perform the multiplication
    multAv(y_local, A, x_global, b, n);

    // each node displays y (with A, full of ones, all the components of x
    // should be the same)
    for(int i = 0; i < b; i++){
      printf("Process [%d], y_local[%d] = %f\n", my_rank, i, y_local[i]);
    }

    // Perform the dot product on the local x
    local_dot  = dot(x_local, y_local, b);
    printf("local dot %f\n", local_dot);

    // Use one single collective communication to perfom the reduction in
    // global_dot
    MPI_Allreduce(&local_dot, &global_dot, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);

    // the norm is the square root of the global_dot
    normA = sqrt(global_dot);

    // Another node displays the norm
    if(my_rank == 2) {
      printf("normA %f\n", normA);
      printf("reference %f\n", reference);
    }
 
    MPI_Finalize();
 
    return EXIT_SUCCESS;
}

void multAv(double x[], double *A, double y[], int m, int n){

  for(int i = 0; i < m; i++){
    x[i] = 0.0;
    for(int j = 0; j < n; j++){
      x[i] += A[i*n + j] * y[j];
    }
  }
  return;
}

void init0(double x[], int n){

  for(int i = 0; i < n; i++){
    x[i] = 0.0;
  }
  return;
}

double dot(double x[], double y[], int n){
  double res = 0.0;

  for(int i = 0; i < n; i++) {
    res += x[i]*y[i];
  }

  return res;
}
