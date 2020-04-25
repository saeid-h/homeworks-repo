#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#define ARRAYSIZE 32

//Note: _global_: from host and run in the device(such function is called kernel),and the result of kernel is stored in GPU and explicitily transferred to host, a function has no directive will run in host(by default)

//1.read in rows, write in columns
__global__ void row_col(int* odata, int* idata, int n) {
	int i;
	for (i = 0; i < n; i++) {
		odata[i*n + blockIdx.x] = idata[blockIdx.x*n + i];
	}
}

//2.read in columns and write in rows
__global__ void col_row(int* odata, int* idata, int n) {
	int i;
	for (i = 0; i < n; i++) {
		odata[blockIdx.x*n + i] = idata[i*n + blockIdx.x];
	}
}
//3.read in rows and write in columns + unroll 4 blocks
__global__ void row_col_unroll(int* odata, int* idata, int n) {
	for (int i = 0; i < 4; i++) {
		int x = blockIdx.x * 4 + i;
		for (int j = 0; j < n; j++) {
			odata[j*n + x] = idata[x*n + j];
		}
	}

}
//4.read in columns and write in rows + unroll 4 blocks
__global__ void col_row_unroll(int* odata, int* idata, int n) {
	for (int i = 0; i < 4; i++) {
		int x = blockIdx.x * 4 + i;
		for (int j = 0; j < n; j++) {
			odata[x*n + j] = idata[j*n + x];
		}
	}
}
//5.read in rows and write in columns + diagonal
__global__ void row_col_diag(float *odata, float *idata, int n) {
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < 4; j++) {
			int x = i;
			int y = (i + blockIdx.x * 4 + j) % n;
			odata[y*n + x] = idata[x*n + y];
		}
	}
}
//6.read in columns and write in row + diagonal
__global__ void col_row_diag(int* odata, int* idata, int n) {
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < 4; j++) {
				int x = i;
				int y = (i + blockIdx.x * 4 + j) % n;
				odata[y*n + x] = idata[x*n + y];
			}
		}
	}
void print_matrix(int* h_tdata, int n) {
	int i, j;
	printf("print matrix of %dx%d\n", n, n);
	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++) {
			printf("%d ", h_tdata[i*n + j]);
		}
		printf("\n");
	}
}

int main(int argc, char **argv) {
	int m_th, m_size;
	if (argc > 2) {
		m_th = atoi(argv[1]);
		m_size = atoi(argv[2]);
	}
	int i, j;
	const int n = m_size;
	const int mem_size = n*n * sizeof(int);

	//allocate memory for the matrix in host(including input and output)
	int *h_idata = (int*)malloc(mem_size);
	int *h_tdata = (int*)malloc(mem_size);
	//allocate memory for the matrix in device(including input and output)
	int *d_idata, *d_tdata;
	cudaMalloc(&d_idata, mem_size);
	cudaMalloc(&d_tdata, mem_size);

	//produce the matrix for transposition 
	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++) {
			h_idata[i*n + j] = i*n + j;
		}
	}

	/*-------------------------preparation------------------------------*/
	cudaMemcpy(d_idata, h_idata, mem_size, cudaMemcpyHostToDevice);//copy data from host to device(GPU)
																   //events for timing
	cudaEvent_t startEvent, stopEvent;
	cudaEventCreate(&startEvent);
	cudaEventCreate(&stopEvent);
	float ms;
	cudaMemset(d_tdata, 0, mem_size);
	
	/*-------------------implement different method-----------------------------*/
	cudaEventRecord(startEvent, 0);//start timing
	dim3 dimGrid(n, 1);
	dim3 dimBlock(1, 1);
	//to do 
	switch (m_th) {
		case 1:
			row_col << <dimGrid, 1 >> > (d_tdata, d_idata, n);//<<<grid,block>>> grid: each column is a block
			break;
		case 2:
			col_row << <dimGrid, 1 >> > (d_tdata, d_idata, n);
			break;
		case 3:
			row_col_unroll << < dimGrid, 1 >> > (d_tdata, d_idata, n);
			break;
		case 4:
			col_row_unroll << < dimGrid, 1 >> > (d_tdata, d_idata, n);
			break;
		case 5:
			row_col_diag << < dimGrid, 1 >> > (d_tdata, d_idata, n);
			break;
		case 6:
			col_row_diag << < dimGrid, 1 >> > (d_tdata, d_idata, n);
	}	

	/*--------------------------------------------------------------------------*/
	cudaEventRecord(stopEvent, 0);//end timing
	cudaEventSynchronize(stopEvent);//stop timing
	cudaEventElapsedTime(&ms, startEvent, stopEvent);
	cudaMemcpy(h_tdata, d_tdata, mem_size, cudaMemcpyDeviceToHost);//copy data from device(GPU) to host

	/*print_matrix(h_idata, n);
	print_matrix(h_tdata, n);*/

	//calculate the elapsed time 
	printf("the elapsed time is:%.10f\n", ms);

	/*------------------ending work:release memory in GPU and heap-----------------*/
	cudaEventDestroy(startEvent);
	cudaEventDestroy(stopEvent);
	cudaFree(d_tdata);
	cudaFree(d_idata);
	free(h_idata);
	free(h_tdata);
	return 0;
}
