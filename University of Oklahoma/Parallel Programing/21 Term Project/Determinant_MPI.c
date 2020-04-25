	
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

# define INDEX(i,j) i*ARRAYSIZE+j

// function's signature
void PrintMatrix(int m, int n, double *A);
void PrintVector(int n, double *x);
void read_matrix (double *A, int ARRAYSIZE);

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
	
	int my_share [num_procs];
	int my_start [num_procs];
	

/* Read input file ---------------------------------------------------------- */
		
	if (my_rank == 0){
		printf ("Number of process = %d\n", num_procs);
		read_matrix (A, ARRAYSIZE);
	}
	
	
	/* http://mpitutorial.com/
		tutorials/mpi-broadcast-and-collective-communication/

	is faster than broadcast
	*/


/* Upper Matrix Decomposition ----------------------------------------------- */
		
	for (int k = 0; k < ARRAYSIZE - 1; k++){
		
		// Update share of matrix rows for each process
		int _sh = ((ARRAYSIZE - k - 1) / num_procs) + 1;
		for (int i = 0; i < num_procs; i++){
			my_start[i] = i * _sh + k + 1;
			if (my_start[i] < ARRAYSIZE){
				if (my_start[i] + _sh - 1 < ARRAYSIZE)
					my_share[i]	= _sh;	
				else
					my_share[i] = ARRAYSIZE - my_start[i];
			}
			else {
				my_share[i]	= 0;	
			}
		}	
		
	
		// Update local matrices
		if (my_rank == 0){
			for (int dest = 1; dest < num_procs; dest++){
				if (my_share[dest] > 0){
					MPI_Send (&A[INDEX(k,k)], ARRAYSIZE, MPI_DOUBLE, dest, 0, MPI_COMM_WORLD);
					MPI_Send (&A[INDEX((my_start[dest]),k)], my_share[dest] * ARRAYSIZE, MPI_DOUBLE, dest, 1, MPI_COMM_WORLD);
				}
			}	
		}
		else {
			if (my_share[my_rank] > 0){
				MPI_Recv (&A[INDEX(k,k)], ARRAYSIZE, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, &status);
				MPI_Recv (&A[INDEX((k+1),k)], my_share[my_rank] * ARRAYSIZE, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD, &status);
			}
		}
		
		MPI_Barrier (MPI_COMM_WORLD);
		
		
		// Factorization
		for (int i = k+1; i < k + 1 + my_share[my_rank]; i++){
			double L = A[INDEX(i,k)] / A[INDEX(k,k)];
			for (int j = k+1; j < ARRAYSIZE; j++){
				A[INDEX(i,j)] = A[INDEX(i,j)] - L * A[INDEX(k,j)];
			}
		}
		
		// Update Main Matrix in process 0
		if (my_rank != 0){
			if (my_share[my_rank] > 0)
        		MPI_Send (&A[INDEX((k+1),k)], my_share[my_rank] * ARRAYSIZE, MPI_DOUBLE, 0, 2, MPI_COMM_WORLD);
		}	
		else {
			for (int src = 1; src < num_procs; src++)
				if (my_share[src] > 0)
					MPI_Recv(&A[INDEX((my_start[src]),k)], my_share[src] * ARRAYSIZE, MPI_DOUBLE, src, 2, MPI_COMM_WORLD, &status);
		}
		
		MPI_Barrier (MPI_COMM_WORLD);		
	}



	
/* Determinant calculations based on diagonal ------------------------------- */
	
    double det = 0;
	double logsum = 0;
	int neg_nums = 0;
	
	if (my_rank == 0){
		for (int i = 0; i < ARRAYSIZE; i++){
			if (A[INDEX(i,i)] < 0){
				neg_nums++;
				logsum += log10(fabs(A[INDEX(i,i)]));
			}
			else
				logsum += log10(A[INDEX(i,i)]);
		}
		det = pow(10.0, logsum);
		if (neg_nums % 2 != 0)
			det = -det;
		
		printf("Determinant: %f\n", det);
		printf("log10(fabs(det)): %f\n", logsum);
	}

		
	

/* Finalization ------------------------------------------------------------- */
    
	wall_time = MPI_Wtime() - wall_time;
	if (my_rank == 0)
		printf ("\nWall time = %f secs.\n", wall_time);
	
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




