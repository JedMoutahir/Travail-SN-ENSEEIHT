#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <cblas.h>
#include "utils.h"
#include "dsmat.h"
#include "gemms.h"

void p2p_i_transmit_A(int p, int q, Matrix *A, int i, int l) {
  int j, b;
  int me, my_row, my_col;
  MPI_Comm_rank(MPI_COMM_WORLD, &me);
  node_coordinates_2i(p,q,me,&my_row,&my_col);

  int node, tag;
  Block * Ail;
  Ail =  & A->blocks[i][l];
  b = A->b;
  /* TODO : transmit A[i,l] using MPI_Issend/recv */
  // If I own A[i,l]
  if (Ail->owner == me) {
    // MPI_Issend Ail to my row
    for (j = 0; j < q; j++) {
      node = get_node(p, q, my_row, j);
      if (node != me) {
        MPI_Issend(Ail->c, b*b, MPI_FLOAT, node, tag, MPI_COMM_WORLD, &Ail->request);
      }
    }

  // If A[i,l] is stored on my row
  } else if (Ail->row == my_row) {
    Ail->c = calloc(b*b,sizeof(float));
    // MPI_Irecv Ail
    MPI_Irecv(Ail->c, b*b, MPI_FLOAT, Ail->owner, tag, MPI_COMM_WORLD, &Ail->request);
  }
  /* end TODO */
}

void p2p_i_transmit_B(int p, int q, Matrix *B, int l, int j) {
  int i,b;
  int me, my_row, my_col;
  MPI_Comm_rank(MPI_COMM_WORLD, &me);
  node_coordinates_2i(p,q,me,&my_row,&my_col);

  int node, tag;
  Block * Blj;
  Blj =  & B->blocks[l][j];
  b = B->b;
  /* TODO : transmit B[l,j] using MPI_Issend/recv */
  // If I own B[l,j]
  if (Blj->owner == me) {
    // MPI_Issend Blj to my column
    for (i = 0; i < p; i++) {
      node = get_node(p, q, i, my_col);
      if (node != me) {
        MPI_Issend(Blj->c, b*b, MPI_FLOAT, node, tag, MPI_COMM_WORLD, &Blj->request);
      }
    }

  // If B[l,j] is stored on my column
  } else if (Blj->col == my_col) {
    Blj->c = calloc(b*b,sizeof(float));
    // MPI_Irecv B[l,j]
    MPI_Irecv(Blj->c, b*b, MPI_FLOAT, Blj->owner, tag, MPI_COMM_WORLD, &Blj->request);
  }
  /* end TODO */
}

void p2p_i_wait_AB(int p, int q, Matrix *A, Matrix* B, Matrix* C, int l) {
  int me, my_row, my_col;
  MPI_Comm_rank(MPI_COMM_WORLD, &me);
  node_coordinates_2i(p,q,me,&my_row,&my_col);

  int i, j;
  Block *Ail, *Blj;
  /* TODO : wait for A[i,l] and B[l,j] if I need them */
  for (i = 0; i < A->mb ; i++) {
    Ail = &(A->blocks[i][l]);

    // If I need A[i,l] for my computation
    if (Ail->owner != me && Ail->row == my_row) {
      // MPI_Wait Ail
      MPI_Wait(&Ail->request, MPI_STATUS_IGNORE);
    }
  }
  for (j =0; j < B->nb; j++) {
    Blj = &(B->blocks[l][j]);

    // If I need B[l,j] for my computation
    if (Blj->owner != me && Blj->col == my_col) {
      // MPI_Wait Blj
      MPI_Wait(&Blj->request, MPI_STATUS_IGNORE);
    }
  }
  /* Alternative suggestion : iterate over blocks of C */
  /* end TODO */
}