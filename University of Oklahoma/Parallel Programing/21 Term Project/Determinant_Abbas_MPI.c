	
/* -----------------------------------------------------------------------------
	author: Saied Hosseinipoor
	email:	saied@ou.edu
	Date:	April 12, 2017
	Modified: April 13, 2017

----------------------------------------------------------------------------- */

# include <mpi.h>
# include <math.h>
# include <stdio.h>
# include <stdlib.h>
# include <time.h>
# include <string.h>

# define INDEX(i,j) i*ARRAYSIZE+j

// function's signature
void timestamp ();
void PrintMatrix(int m, int n, double *A);
void PrintVector(int n, double *x);
void read_matrix (double *A, int ARRAYSIZE);

void Inverse (double* A_inv, double* A, int size);
double Determinant (double* A, int size);
void Multiply ( double* C, double* A, double* B, int size);
void Subtract (double* C, double* A, double* B, int size);
void Map (double* Aij, double* A, int n, int w, int i, int j);
void ReMap (double* A, int n, double* Aij, int w, int i, int j);


int ARRAYSIZE = 16;


/* Main --------------------------------------------------------------------- */

int main (int argc, char *argv[]){
   
		
/* MPI initialization  ------------------------------------------------------ */
	
    int my_rank, num_procs;		// Parallel process's parameters
    MPI_Status status;
    int mpi_error_code;     /* Error code returned by MPI call */
	
    mpi_error_code = MPI_Init (&argc, &argv);
    mpi_error_code = MPI_Comm_size (MPI_COMM_WORLD, &num_procs);
    mpi_error_code = MPI_Comm_rank (MPI_COMM_WORLD, &my_rank);
    
    double wall_time = MPI_Wtime ();
    //if (my_rank == 0) timestamp ();
	
	if (argc > 1){
		if (my_rank == 0) printf("Receiving: %s\n", argv[1]); 
		ARRAYSIZE = atoi(argv[1]);
	}
			
	double* A = (double*) malloc (ARRAYSIZE * ARRAYSIZE * sizeof(double));	

/* Read input file ---------------------------------------------------------- */
		
	if (my_rank == 0){
		read_matrix (A, ARRAYSIZE);
	}
	
	
	/* http://mpitutorial.com/
		tutorials/mpi-broadcast-and-collective-communication/

	is faster than broadcast
	*/


/* Upper Matrix Decomposition ----------------------------------------------- */


	int my_share [num_procs];
	int my_start [num_procs];
	
	int w = 4;
	int q = ARRAYSIZE / w;	
	
	//double M[w*w];
	
	for (int i = 0; i < q - 1; i++){
		double Aii[w*w];
		double Aii_inv[w*w];
		
		Map (Aii, A, ARRAYSIZE, w, i, i);
		Inverse (Aii_inv, Aii, w);
		
		for (int j = i + 1; j < q; j++){
			double Mji[w*w];
			double Aji[w*w];
			Map (Aji, A, ARRAYSIZE, w, j, i);
			Multiply (Mji, Aji, Aii_inv, w);
			//ReMap (M, ARRAYSIZE, Mji, w, j, i);
			ReMap (A, ARRAYSIZE, Aji, w, j, i);
			
			//double m = A[INDEX(j,i)] / A[INDEX(i,i)];
			for (int k = i + 1; k < q; k++){
				double Ajk[w*w];
				Map (Ajk, A, ARRAYSIZE, w, j, k);
				double Aik[w*w];
				Map (Aik, A, ARRAYSIZE, w, i, k);
				double temp[w*w];
				
				Multiply(temp, Mji, Aik, w);
				Subtract (Ajk, Ajk, temp, w);
				//A[INDEX(j,k)] = A[INDEX(j,k)] - m * A[INDEX(i,k)];
				ReMap (A, ARRAYSIZE, Ajk, w, j, k);
			}
		}
	}
	
	
/* Determinant calculations based on diagonal ------------------------------- */
	
    
	double det = 0;
	double Det = 1;
	double logsum = 0;
	int neg_nums = 0;
	
	double Aii[w*w];
		
	if (my_rank == 0){
		for (int i = 0; i < q; i++){
			Map (Aii, A, ARRAYSIZE, w, i, i);
			Det *= Determinant (Aii, w);
			//printf("Determinant(%d): %f\n", i, Det);
			
			/*
			if (A[INDEX(i,i)] < 0){
				neg_nums++;
				logsum += log10(fabs(A[INDEX(i,i)]));
			}
			else
				logsum += log10(A[INDEX(i,i)]);
			*/
		}
		//det = pow(10.0, logsum);
		//if (neg_nums % 2 != 0)
		//	det = -det;
		
		printf("Determinant: %f\n", Det);
		//printf("log10(fabs(det)): %f\n", logsum);
	}

	
		
	

/* Finalization ------------------------------------------------------------- */
    
	wall_time = MPI_Wtime() - wall_time;
	
	free (A); 
		
    MPI_Finalize();
	
	return 0;
}





/* Functions ---------------------------------------------------------------- */

/* -------------------------------------------------------------------------- */
void PrintMatrix(int m, int n, double *A) {
	int i, j;
	for (i = 0; i < m; i++) {
		for (j = 0; j < n; j++) {
			printf("%.02f\t", A[INDEX(i,j)]);
		}
		printf("\n");
	}
}



/* -------------------------------------------------------------------------- */

void Inverse (double* A_inv, double* A, int n){
	
	for (int i = 0; i < n; i++){
		for (int j = 0; j < n; j++){
			if (i == j)
				A_inv[i*n+j] = 1;
			else
				A_inv[i*n+j] = 0;
		}
	}
	
	double  temp[n * n];
	memcpy (temp, A, n*n * sizeof(double));
	
		
	for (int k = 0; k < n; k++){
		double L = temp[k*n+k];
		for (int j = 0; j < k; j++){
			A_inv[k*n+j] = A_inv[k*n+j] / L;
		}
		for (int j = k; j < n; j++){
			A_inv[k*n+j] = A_inv[k*n+j] / L;
			temp[k*n+j] = temp[k*n+j] / L;
		}
		for (int i = 0; i < n; i++){
			if (i != k) {
				L = temp[i*n+k];
				for (int j = 0; j < k; j++){
					A_inv[i*n+j] += (-L * A_inv[k*n+j]);
				}
				for (int j = k; j < n; j++){
					A_inv[i*n+j] += (-L * A_inv[k*n+j]);
					temp[i*n+j] += (-L * temp[k*n+j]);
				}
			}
		}
	}
	
}



/* -------------------------------------------------------------------------- */

double Determinant (double* A, int n){
	
	double  temp[n * n];
	memcpy (temp, A, n * n * sizeof(double));
		
	for (int k = 0; k < n-1; k++){
		for (int i = k+1; i < n; i++){
			double L = temp[i*n+k] / temp[k*n+k];
			for (int j = k+1; j < n; j++){
				temp[i*n+j] += (-L * temp[k*n+j]);
			}
		}
	}
	
	double det = 1;
	for (int i = 0; i < n; i++){
		det = det * temp[i*n+i];
	}
	
	return det;
}




/* -------------------------------------------------------------------------- */
	
void Multiply ( double* C, double* A, double* B, int n){
	
	//double  M1[n * n];
	//double  M2[n * n];
	//double  C[n * n];

	//memcpy (M1, A, n * n * sizeof(double));
	//memcpy (M2, B, n * n * sizeof(double));
	
	for (int i = 0; i < n; i++){
		for (int j = 0; j < n; j++){
			double sum = 0;
			for (int k = 0; k < n; k++){
				sum += A[i*n+k] * B[k*n+j];
			}
			C[i*n+j] = sum;
		}
	}

	//return C;
}




/* -------------------------------------------------------------------------- */
	
void Subtract (double* C, double* A, double* B, int n){
	
	//double  C[n * n];

	for (int i = 0; i < n; i++){
		for (int j = 0; j < n; j++){
			C[i*n+j] = A[i*n+j] - B[i*n+j];
		}
	}

	//return C;
}




/* -------------------------------------------------------------------------- */

void Map (double* Aij, double* A, int n, int w, int i, int j){
	
	//double Aij[w*w];
	
	for (int p = 0; p < w; p++){
		for (int q = 0; q < w; q++){
			Aij[p*w+q] = A[i*w*n+j*w+p*n+q];
		}
	}
	
	//return Aij;
}



/* -------------------------------------------------------------------------- */

void ReMap (double* A, int n, double* Aij, int w, int i, int j){
	
	for (int p = 0; p < w; p++){
		for (int q = 0; q < w; q++){
			A[i*w*n+j*w+p*n+q] = Aij[p*w+q];
		}
	}
	
}


/* -------------------------------------------------------------------------- */
//Print out a vector neatly
void PrintVector(int n, double *x) {
	for (int i = 0; i < n; i++) {
		printf("%.02f\n", x[i]);
	}
}


/* -------------------------------------------------------------------------- */
void read_matrix (double *A, int ARRAYSIZE){
    
	char f_name[50];
	
	//Create filename
	sprintf (f_name, "%d.bin", ARRAYSIZE);
	printf ("Reading array file %s of size %dx%d\n",f_name,ARRAYSIZE,ARRAYSIZE);
	
	//Open file
	FILE *datafile=fopen(f_name,"rb");
	
	//Read elelements
	for (int i = 0; i < ARRAYSIZE; i++)
	    for (int j = 0; j < ARRAYSIZE; j++)
	        fread (&A[INDEX(i,j)], sizeof(double), 1, datafile);
			        
	printf("Matrix has been read.\n");
}

