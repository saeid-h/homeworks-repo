	
/* -----------------------------------------------------------------------------
	author: Saied Hosseinipoor
	email:	saied@ou.edu
	Date:	April 12, 2017
	Modified: April 13, 2017

----------------------------------------------------------------------------- */

# include <math.h>
# include <stdio.h>
# include <stdlib.h>
# include <time.h>
# include <string.h>
# include <omp.h>


// function's signature
void timestamp ();
void PrintMatrix (int m, int n, double *A);
void PrintVector (int n, double *x);
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
   
		
/* Initialization  ---------------------------------------------------------- */
	
   	
	if (argc > 1)
		ARRAYSIZE = atoi(argv[1]);
	printf("\nReceiving: %d\n", ARRAYSIZE); 
	
	int thread_count = 64;
	if (argc > 2)
		thread_count = strtol(argv[2], NULL, 10);
			
		
			
	double* A = (double*) malloc (ARRAYSIZE * ARRAYSIZE * sizeof(double));	

/* Read input file ---------------------------------------------------------- */
		
	
	read_matrix (A, ARRAYSIZE);
	


/* Abbas Algorithm ---------------------------------------------------------- */

	int w = 1;	
	if (argc > 3){
		w = strtol(argv[3], NULL, 10);
		//printf ("%d\n", w);
		if (w > ARRAYSIZE) 
			w = ARRAYSIZE;
		else if (ARRAYSIZE % w != 0) {
			printf ("\nw is not divisible to array size.");
			printf ("It is set to 1.\n\n");
			w = 1;
		}
	}
	
	int q = ARRAYSIZE / w;	
	
	double Aii[w*w];
	double Aii_inv[w*w];
	double Mji[w*w];
	double Aji[w*w];
	double Ajk[w*w];
	double Aik[w*w];
	double temp[w*w];
	int i, j, k;


# pragma omp parallel num_threads (thread_count) \
	default (none) \
	shared(A, q, w, ARRAYSIZE) \
	private(Aii, Aii_inv, Aji, Ajk, Aik, Mji, temp,i, j, k) 
{
			
	for (i = 0; i < q - 1; i++){
		
		Map (Aii, A, ARRAYSIZE, w, i, i);
		Inverse (Aii_inv, Aii, w);
		
# 	pragma omp for schedule(guided) 
		for (j = i + 1; j < q; j++){
			
			Map (Aji, A, ARRAYSIZE, w, j, i);
			Multiply (Mji, Aji, Aii_inv, w);
			//#	pragma omp barrier
			ReMap (A, ARRAYSIZE, Aji, w, j, i);
			
			for (k = i + 1; k < q; k++){
				Map (Ajk, A, ARRAYSIZE, w, j, k);
				Map (Aik, A, ARRAYSIZE, w, i, k);
				
				Multiply(temp, Mji, Aik, w);
				Subtract (Ajk, Ajk, temp, w);
				//#	pragma omp barrier
				ReMap (A, ARRAYSIZE, Ajk, w, j, k);
			}
		}
	}
}
	
	
/* Determinant calculations based on diagonal ------------------------------- */
	
    
	double det = 0;
	double Det;
	double logsum = 0;
	int neg_nums = 0;
	

# pragma omp parallel for default (none) \
	shared (q, w, A, ARRAYSIZE, det, neg_nums) \
	private (Aii, i, Det)\
	reduction (+:logsum)
	
	for (i = 0; i < q; i++){
		Map (Aii, A, ARRAYSIZE, w, i, i);
		Det = Determinant (Aii, w);		
		
		if (Det < 0){
			neg_nums++;
			logsum += log10(fabs(Det));
		}
		else
			logsum += log10(Det);
		
	}
	
	det = pow(10.0, logsum);
	if (neg_nums % 2 != 0)
			det = -det;
	
	printf("Determinant: %f\n", det);
	printf("log10(fabs(det)): %f\n", logsum);


/* Finalization ------------------------------------------------------------- */
	
	free (A); 
	
	return 0;
}




/* Functions ---------------------------------------------------------------- */

/* -------------------------------------------------------------------------- */
void PrintMatrix(int m, int n, double *A) {
	int i, j;
	for (i = 0; i < m; i++) {
		for (j = 0; j < n; j++) {
			printf("%.02f\t", A[i*n+j]);
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
	
		
	for (int i = 0; i < n; i++){
		for (int j = 0; j < n; j++){
			double sum = 0;
			for (int k = 0; k < n; k++){
				sum += A[i*n+k] * B[k*n+j];
			}
			C[i*n+j] = sum;
		}
	}

}




/* -------------------------------------------------------------------------- */
	
void Subtract (double* C, double* A, double* B, int n){
	
	for (int i = 0; i < n; i++){
		for (int j = 0; j < n; j++){
			C[i*n+j] = A[i*n+j] - B[i*n+j];
		}
	}

}




/* -------------------------------------------------------------------------- */

void Map (double* Aij, double* A, int n, int w, int i, int j){
		
	for (int p = 0; p < w; p++){
		for (int q = 0; q < w; q++){
			Aij[p*w+q] = A[i*w*n+j*w+p*n+q];
		}
	}
	
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
	        fread (&A[i*ARRAYSIZE+j], sizeof(double), 1, datafile);
			        
	printf("Matrix has been read.\n");
}

