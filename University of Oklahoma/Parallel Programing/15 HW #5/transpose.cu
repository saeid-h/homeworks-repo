


#include	<stdio.h>
#include	<stdlib.h>
#include	<cuda.h>
#include	<string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#define ARRAYSIZE 32
#define TILE_DIM 	32
#define BLOCK_ROWS 	8
#define NUM_REPS  100

__global__ void helloWorld (float *a, float *b, int size) {
	
	int id = blockIdx.x * blockDim.x + threadIdx.x;
	
	if (id < size*size){
		a[id] += b[id];
	}
	
}

__global__ void copy(float *odata, float* idata, int width,
                                     int height) {
										 
	int xIndex = blockIdx.x * TILE_DIM + threadIdx.x;
	int yIndex = blockIdx.y * TILE_DIM + threadIdx.y;
	
	int index  = xIndex + width * yIndex;
	
	for (int i = 0; i < TILE_DIM; i += BLOCK_ROWS) {
		odata[index+i*width] = idata[index+i*width];
  	}
}



__global__ void transposeNaive (float *odata, float* idata, 
								int width, int height, char direction) {
  
	int xIndex = blockIdx.x * TILE_DIM + threadIdx.x;
	int yIndex = blockIdx.y * TILE_DIM + threadIdx.y;
	
	int index_in  = xIndex + width * yIndex;
	int index_out = yIndex + height * xIndex;
	
	for (int i=0; i < TILE_DIM; i += BLOCK_ROWS) {
		if ( direction == 'H')
			odata[index_out+i] = idata[index_in+i*width];
		else
			odata[index_out+i*width] = idata[index_in+i];
	}
}



__global__ void row_col(int* odata, int* idata, int n) {
	int i;
	for (i = 0; i < n; i++) {
		odata[i*n + blockIdx.x] = idata[blockIdx.x*n + i];
	}
}

__global__ void col_row(int* odata, int* idata, int n) {
	int i;
	for (i = 0; i < n; i++) {
		odata[blockIdx.x*n + i] = idata[i*n + blockIdx.x];
	}
}
__global__ void row_col_unroll(int* odata, int* idata, int n) {
	for (int i = 0; i < 4; i++) {
		int x = blockIdx.x * 4 + i;
		for (int j = 0; j < n; j++) {
			odata[j*n + x] = idata[x*n + j];
		}
	}

}


__global__ void col_row_unroll(int* odata, int* idata, int n) {
	for (int i = 0; i < 4; i++) {
		int x = blockIdx.x * 4 + i;
		for (int j = 0; j < n; j++) {
			odata[x*n + j] = idata[j*n + x];
		}
	}
}

__global__ void row_col_diag(int *odata, int *idata, int n) {
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < 4; j++) {
			int x = i;
			int y = (i + blockIdx.x * 4 + j) % n;
			odata[y*n + x] = idata[x*n + y];
		}
	}
}

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


  
  
__global__ void transposeDiagonal (float *odata,
            float *idata, int width, int height, char direction) {
				
	__shared__ float tile[TILE_DIM][TILE_DIM+1];
	int blockIdx_x, blockIdx_y;
	
	// diagonal reordering
	if (width == height) {
		blockIdx_y = blockIdx.x;
		blockIdx_x = (blockIdx.x+blockIdx.y)%gridDim.x;
	} else {
		int bid = blockIdx.x + gridDim.x*blockIdx.y;
		blockIdx_y = bid%gridDim.y;
		blockIdx_x = ((bid/gridDim.y)+blockIdx_y)%gridDim.x;
	}
	
	int xIndex = blockIdx_x*TILE_DIM + threadIdx.x;
	int yIndex = blockIdx_y*TILE_DIM + threadIdx.y;
	int index_in = xIndex + (yIndex) * width;
	
	xIndex = blockIdx_y*TILE_DIM + threadIdx.x;
	yIndex = blockIdx_x*TILE_DIM + threadIdx.y;
	
	int index_out = xIndex + (yIndex)*height;
	for (int i = 0; i < TILE_DIM; i += BLOCK_ROWS) {
		if (direction == 'H')
			tile[threadIdx.y+i][threadIdx.x] = idata[index_in+i*width];
		else
			tile[threadIdx.y+i][threadIdx.x] = idata[index_in+i*height];
	}
	
	__syncthreads();
	
	for (int i = 0; i < TILE_DIM; i += BLOCK_ROWS) {
		if (direction == 'H')
			odata[index_out+i*height] = tile[threadIdx.x][threadIdx.y+i];
		else
			odata[index_out+i*width] = tile[threadIdx.x][threadIdx.y+i];
	}
}




__global__ void transposeCoalesced (float *odata,
            float *idata, int width, int height) {

	__shared__ float tile[TILE_DIM][TILE_DIM];
	int xIndex = blockIdx.x * TILE_DIM + threadIdx.x;
	int yIndex = blockIdx.y * TILE_DIM + threadIdx.y;
	
	int index_in = xIndex + (yIndex) * width;
	
	xIndex = blockIdx.y * TILE_DIM + threadIdx.x;
	yIndex = blockIdx.x * TILE_DIM + threadIdx.y;
	
	int index_out = xIndex + (yIndex) * height;
	
	for (int i = 0; i < TILE_DIM; i += BLOCK_ROWS) {
		tile[threadIdx.y+i][threadIdx.x] = idata[index_in+i*width];
	}
	
	__syncthreads();
	for (int i = 0; i < TILE_DIM; i += BLOCK_ROWS) {
		odata[index_out+i*height] = tile[threadIdx.x][threadIdx.y+i];
	}
}




__global__ void copySharedMem (float *odata, float *idata,
                          int width, int height) {
							  
	__shared__ float tile[TILE_DIM][TILE_DIM];
	int xIndex = blockIdx.x * TILE_DIM + threadIdx.x;
	int yIndex = blockIdx.y * TILE_DIM + threadIdx.y;
	int index  = xIndex + width * yIndex;
	
	for (int i = 0; i < TILE_DIM; i += BLOCK_ROWS) {
		tile[threadIdx.y+i][threadIdx.x] = idata[index+i*width];
	}
	
	__syncthreads();
	for (int i=0; i<TILE_DIM; i+=BLOCK_ROWS) {
		odata[index+i*width] = tile[threadIdx.y+i][threadIdx.x];
	}
}



__global__ void transposeFineGrained (float *odata,
           float *idata, int width, int height) {
			   
	__shared__ float block[TILE_DIM][TILE_DIM+1];
	int xIndex = blockIdx.x * TILE_DIM + threadIdx.x;
	int yIndex = blockIdx.y * TILE_DIM + threadIdx.y;
	
	int index = xIndex + (yIndex) * width;
	
	for (int i = 0; i < TILE_DIM; i += BLOCK_ROWS) {
		block[threadIdx.y+i][threadIdx.x] = idata[index+i*width];
	}
	
	__syncthreads();
  
	for (int i = 0; i < TILE_DIM; i += BLOCK_ROWS) {
		odata[index+i*height] = block[threadIdx.x][threadIdx.y+i];
    }
}




__global__ void transposeCoarseGrained (float *odata,
        float *idata, int width, int height) {
						
	__shared__ float block[TILE_DIM][TILE_DIM+1];
	int xIndex = blockIdx.x * TILE_DIM + threadIdx.x;
    int yIndex = blockIdx.y * TILE_DIM + threadIdx.y;
	
    int index_in = xIndex + (yIndex) * width;
	
    xIndex = blockIdx.y * TILE_DIM + threadIdx.x;
    yIndex = blockIdx.x * TILE_DIM + threadIdx.y;
	
    int index_out = xIndex + (yIndex) * height;
	
    for (int i = 0; i < TILE_DIM; i += BLOCK_ROWS) {
      block[threadIdx.y+i][threadIdx.x] = idata[index_in+i*width];
    }
	
    __syncthreads();
    
	for (int i=0; i<TILE_DIM; i += BLOCK_ROWS) {
		odata[index_out+i*height] = block[threadIdx.y+i][threadIdx.x];
    }
}
  
  












// -----------------------------------------------------------------------------

int main (int argc, char* argv[]){
	
	float kernelTime;
	int size = 1024;
	
	/* for size loop */
	//for (int size = 256; size < 8192; size *= 2){ 
		
	//float *A = (float*) malloc (size * size * sizeof(float));
	//float *B = (float*) malloc (size * size * sizeof(float));
	int *A = (int*) malloc (size * size * sizeof(int));
	int *B = (int*) malloc (size * size * sizeof(int));

	for (int i = 0; i < size*size; i++){
		A[i] = i; //(float) i;
		//B[i] = rand() / 1E6;
	}

	int *d_A, *d_B;

	// CUDA events
    cudaEvent_t start, stop;
	
	int size_x, size_y;
	size_x = size_y = size;
  	// execution configuration parameters
    //dim3 grid(size_x/TILE_DIM, size_y/TILE_DIM), threads(TILE_DIM,BLOCK_ROWS);
	dim3 dimGrid(size, 1);
	dim3 dimBlock(1, 1);
	
	if (cudaMalloc(&d_A, size*size * sizeof(int)) != cudaSuccess){
		printf ("A allocation error !!!\n");
		return 0;
	}
	
	if (cudaMalloc(&d_B, size*size * sizeof(int)) != cudaSuccess){
		printf ("B allocation error !!!\n");
		cudaFree (d_A);
		return 0;
	}
	
	if (cudaMemcpy(d_A, A, size*size * sizeof(int), cudaMemcpyHostToDevice) != cudaSuccess){
		printf ("A copy Error !!!\n");
		cudaFree (d_A);
		cudaFree (d_B);
		return 0;
	}
	
	if (cudaMemcpy(d_B, B, size*size * sizeof(int), cudaMemcpyHostToDevice) != cudaSuccess){
		printf ("B copy Error !!!\n");
		cudaFree (d_A);
		cudaFree (d_B);
		return 0;
	}
	


// Part 1 ---------------------------------------------------------------------	
	
	// initialize events, EC parameters
	cudaEventCreate (&start);
	cudaEventCreate (&stop);
	
	// Warm-up
	//transposeNaive<<<grid, threads>>>(d_B, d_A, size_x, size_y, 'H');
	row_col << <dimGrid, 1 >> > (d_B, d_A, size);
	
	// take measurements for loop over kernel launches
	cudaEventRecord(start, 0);
	
	for (int i=0; i < NUM_REPS; i++) {
	  	//transposeNaive<<<grid, threads>>>(d_B, d_A,size_x, size_y, 'H');
		row_col << <dimGrid, 1 >> > (d_B, d_A, size);
	}	
	
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&kernelTime, start, stop);
	
	cudaMemcpy(B, d_B, size*size * sizeof(float), cudaMemcpyDeviceToHost);
	/*	
	if (cudaMemcpy(B, d_B, size*size * sizeof(float), cudaMemcpyDeviceToHost) != cudaSuccess){
		printf ("Result copy Error !!!\n");
		cudaFree (d_A);
		cudaFree (d_B);
		return 0;
	}
	*/
	printf ("\nTime for calculation of %d x %d matrix ", size_x, size_y);
	printf ("transpose from rows to columns ");
	printf ("is %f msec.\n", kernelTime/NUM_REPS);


// Part 2 ---------------------------------------------------------------------	
	
	// initialize events, EC parameters
	cudaEventCreate (&start);
	cudaEventCreate (&stop);
	
	// Warm-up
	//transposeNaive<<<grid, threads>>>(d_B, d_A, size_x, size_y, 'V');
	col_row << <dimGrid, 1 >> > (d_B, d_A, size);
	
	
	// take measurements for loop over kernel launches
	cudaEventRecord(start, 0);
	
	for (int i=0; i < NUM_REPS; i++) {
		//transposeNaive<<<grid, threads>>>(d_B, d_A,size_x, size_y, 'V');
		col_row << <dimGrid, 1 >> > (d_B, d_A, size);
	}	
	
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&kernelTime, start, stop);
	
	if (cudaMemcpy(B, d_B, size*size * sizeof(float), cudaMemcpyDeviceToHost) != cudaSuccess){
		printf ("Result copy Error !!!\n");
		cudaFree (d_A);
		cudaFree (d_B);
		return 0;
	}
	
	cudaMemcpy(B, d_B, size*size * sizeof(float), cudaMemcpyDeviceToHost);
	
	/*
	printf ("\nTime for calculation of %d x %d matrix ", size_x, size_y);
	printf ("transpose from columns to rows ");
	printf ("is %f msec.\n", kernelTime/NUM_REPS);
	*/
	

// Part 3 ---------------------------------------------------------------------	
	
	// initialize events, EC parameters
	cudaEventCreate (&start);
	cudaEventCreate (&stop);
	
	// Warm-up
	//transposeNaive<<<grid, threads>>>(d_B, d_A, size_x, size_y, 'H');
	row_col_unroll << <dimGrid, 1 >> > (d_B, d_A, size);	
	
	// take measurements for loop over kernel launches
	cudaEventRecord(start, 0);
	
	for (int i=0; i < NUM_REPS; i++) {
	  	//transposeNaive<<<grid, threads>>>(d_B, d_A,size_x, size_y, 'H');
		row_col_unroll << <dimGrid, 1 >> > (d_B, d_A, size);
	}	
	
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&kernelTime, start, stop);
	
	cudaMemcpy(B, d_B, size*size * sizeof(float), cudaMemcpyDeviceToHost);
	/*	
	if (cudaMemcpy(B, d_B, size*size * sizeof(float), cudaMemcpyDeviceToHost) != cudaSuccess){
		printf ("Result copy Error !!!\n");
		cudaFree (d_A);
		cudaFree (d_B);
		return 0;
	}
	*/
	printf ("\nTime for calculation of %d x %d matrix ", size_x, size_y);
	printf ("transpose from rows to columns ");
	printf ("is %f msec.\n", kernelTime/NUM_REPS);


// Part 4 ---------------------------------------------------------------------	
	
	// initialize events, EC parameters
	cudaEventCreate (&start);
	cudaEventCreate (&stop);
	
	// Warm-up
	//transposeNaive<<<grid, threads>>>(d_B, d_A, size_x, size_y, 'V');
	col_row_unroll << <dimGrid, 1 >> > (d_B, d_A, size);
	
	
	// take measurements for loop over kernel launches
	cudaEventRecord(start, 0);
	
	for (int i=0; i < NUM_REPS; i++) {
		//transposeNaive<<<grid, threads>>>(d_B, d_A,size_x, size_y, 'V');
		col_row_unroll << <dimGrid, 1 >> > (d_B, d_A, size);
	}	
	
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&kernelTime, start, stop);
	
	if (cudaMemcpy(B, d_B, size*size * sizeof(float), cudaMemcpyDeviceToHost) != cudaSuccess){
		printf ("Result copy Error !!!\n");
		cudaFree (d_A);
		cudaFree (d_B);
		return 0;
	}
	
	cudaMemcpy(B, d_B, size*size * sizeof(float), cudaMemcpyDeviceToHost);
	
	
	printf ("\nTime for calculation of %d x %d matrix ", size_x, size_y);
	printf ("transpose from columns to rows ");
	printf ("is %f msec.\n", kernelTime/NUM_REPS);
	
	
		
// Part 5 ---------------------------------------------------------------------	
	
	// initialize events, EC parameters
	cudaEventCreate (&start);
	cudaEventCreate (&stop);
	
	// Warm-up
	//transposeDiagonal<<<grid, threads>>>(d_B, d_A, size_x, size_y, 'H');
	row_col_diag <<< dimGrid, 1 >>> (d_B, d_A, size);
	
	
	// take measurements for loop over kernel launches
	cudaEventRecord(start, 0);
	
	for (int i=0; i < NUM_REPS; i++) {
	  	//transposeDiagonal<<<grid, threads>>>(d_B, d_A,size_x, size_y, 'H');
		row_col_diag <<< dimGrid, 1 >>> (d_B, d_A, size);
	}	
	
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&kernelTime, start, stop);
	
	if (cudaMemcpy(B, d_B, size*size * sizeof(float), cudaMemcpyDeviceToHost) != cudaSuccess){
		printf ("Result copy Error !!!\n");
		cudaFree (d_A);
		cudaFree (d_B);
		return 0;
	}
	
	printf ("\nTime for calculation of %d x %d matrix ", size_x, size_y);
	printf ("diagonal transpose from rows to columns ");
	printf ("is %f msec.\n", kernelTime/NUM_REPS);
	



// Part 6 ---------------------------------------------------------------------	
	
	// initialize events, EC parameters
	cudaEventCreate (&start);
	cudaEventCreate (&stop);
	
	// Warm-up
	//transposeDiagonal<<<grid, threads>>>(d_B, d_A, size_x, size_y, 'V');
	col_row_diag << < dimGrid, 1 >> > (d_B, d_A, size);
	
	
	// take measurements for loop over kernel launches
	cudaEventRecord(start, 0);
	
	for (int i=0; i < NUM_REPS; i++) {
	  	//transposeDiagonal<<<grid, threads>>>(d_B, d_A,size_x, size_y, 'V');
  		col_row_diag << < dimGrid, 1 >> > (d_B, d_A, size);
	}	
	
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&kernelTime, start, stop);
	
	if (cudaMemcpy(B, d_B, size*size * sizeof(float), cudaMemcpyDeviceToHost) != cudaSuccess){
		printf ("Result copy Error !!!\n");
		cudaFree (d_A);
		cudaFree (d_B);
		return 0;
	}
	
	printf ("\nTime for calculation of %d x %d matrix ", size_x, size_y);
	printf ("diagonal transpose from columns to rows ");
	printf ("is %f msec.\n", kernelTime/NUM_REPS);
	

	


// Finalize -------------------------------------------------------------------	
	
	printf ("\n\n");
	
	for (int i = 0; i < 5; i++){
		for (int j = 0; j < 5; j++){
			printf ("%4.2f   ", A[i*size+j]);
		}
		printf ("\n");
	}
	
	printf ("\n\n");
	
	for (int i = 0; i < 5; i++){
		for (int j = 0; j < 5; j++){
			printf ("%4.2f\t", B[i*size+j]);
		}
		printf ("\n");
	}
	
	
	free (A);
	free (B);
	cudaFree (d_A);
	cudaFree (d_B);
	cudaEventDestroy(start); 
	cudaEventDestroy(stop);
	
	//} /* for size loop */
	
	return 0;
}












