#include <stdio.h>
#include <omp.h>
#include <cublas_v2.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <cblas.h>
#include "utils.h"

#define MIN(x, y) (((x) < (y)) ? (x) : (y))

void gemm_seq(size_t M, size_t N, size_t K, float alpha, float *A,
              size_t lda, float *B, size_t ldb, float beta, float *C,
              size_t ldc) {
    cblas_sgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, M,
                N, K, alpha, A, lda, B, ldb, beta, C, ldc);
}


void gemm_cpu(size_t M, size_t N, size_t K, float alpha, float *A,
              size_t lda, float *B, size_t ldb, float beta, int nb_th,
              float *C, size_t ldc) {

    int th;         // Thread id number
    int nb_col;     // Number of columns in a block column
    int firstcol;   // Index of the first column of the current block column

    // TODO: Separate the GEMM work between the available OMP threads
    #pragma omp parallel private(th, nb_col, firstcol)
    {
        th = omp_get_thread_num();
        nb_col = N / nb_th;
        if (th < N % nb_th) nb_col++;
        firstcol = th * (N / nb_th) + MIN(th, N % nb_th);

        cblas_sgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, M,
                    nb_col,
                    K, alpha, A, lda,
                    &B[firstcol*K],
                    ldb, beta,
                    &C[firstcol*K],
                    ldc);
    }
    return;
}


void gemm_gpu(size_t M, size_t N, size_t K, float alpha, float *A,
              size_t lda, float *B, size_t ldb, float beta, float *C,
              size_t ldc) {
    int ierr;
    cublasHandle_t handle;

    cublasCreate(&handle);

    // Send/Retrieve the data on the GPU
    #pragma omp target data map(to: A[0:M*K], B[0:K*N]) map(tofrom: C[0:M*N])
    {
        // Allocate data on the GPU
        #pragma omp target data use_device_ptr(A, B, C)
        {
            // Execute the cublasSgemm routine on the GPU
            ierr = cublasSgemm(handle,CUBLAS_OP_N, CUBLAS_OP_N, M, N, K, &alpha, A,
                            M, B, K, &beta, C, M);
            if(ierr != CUBLAS_STATUS_SUCCESS)
            {
            printf( "failed %d %f.\n", ierr, C[0]);
            exit(1);
            } 
        }
    }

    // Deallocate data on the GPU
    #pragma omp target exit data map(delete: A[0:M*K], B[0:K*N], C[0:M*N])

    cublasDestroy(handle);

    return;
}


void gemm_gpu_cpu(size_t M, size_t N, size_t K, float alpha, float *A,
              size_t lda, float *B, size_t ldb, float beta, int nb_th,
              int per, float *C, size_t ldc) {

    size_t nb_col_gpu ; // = ? TODO // Number of column for the GPU block
    size_t nb_col_cpu ; // = ? TODO // Number of column for the CPU block

    int th;         // Thread id number
    int nb_col;     // Number of columns in a block column
    int firstcol;   // Index of the first column of the current block column

    // TODO: Separate the GEMM work such that the GPU compute a percentage 
    // "per" of the GEMM and the CPU threads compute the remaining 
    
    // IF (I AM THE 0th THREAD) THEN
    //      I COMPUTE THE GPU WORKLOAD using the gemm_gpu function
    // ELSE
    //      I COMPUTE A PART OF THE CPU WORKLOAD
    // ENDIF

    nb_col_gpu = N * per / 100;
    nb_col_cpu = N - nb_col_gpu;

    #pragma omp parallel private(th, nb_col, firstcol)
    {
        th = omp_get_thread_num();
        if(th == 0){
            if(per > 100 || per < 0) {
                printf("failed: 3rd argument should be a percentage (<100 and >0).\n");
                exit(1);
            }
            if(per != 0){
                // call to gemm_gpu
                gemm_gpu(M, nb_col_gpu, K, alpha, A, lda, &B[0], ldb, beta, &C[0], ldc);
            }

        } else {
            // th begin at 1 not 0
            nb_col = nb_col_cpu / (nb_th - 1);
            if (th-1 < nb_col_cpu % (nb_th - 1)) nb_col++;
            firstcol = nb_col_gpu + (th - 1) * (nb_col_cpu / (nb_th - 1)) + MIN(th - 1, nb_col_cpu % (nb_th - 1));

            cblas_sgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, M,
                        nb_col,
                        K, alpha, A, lda,
                        &B[firstcol*K],
                        ldb, beta,
                        &C[firstcol*K],
                        ldc);
        }
    }

    return;
}

