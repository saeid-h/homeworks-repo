	
/* -----------------------------------------------------------------------------
	
	This code solves the folloeing boundary value problem by doubling recurrence 
	method for tridiagonal method. It is implemented as a parallel program using
	open-mpi library:

		y'' + f1(x) * y' + f2(x) * y = f3(x)
		f1 (x) = x;	f2(x) = 1; 	f3(x) = 2x;
		y(0) = 0; 	y(1) = 1;

	
	
	Solution:

		1. Form linear system of equations:	Ay = d

					|b1 c1  0  0  0 ...  0|
					|a2	b2 c2  0  0 ...  0|
				A = |0  a3 b3 c3  0 ...  0|
					|0    ...	    ...	 0|
					|0  0  ...    0  bN  0|  

				y = (y1, y2, ... , yN)t
				d = (d1, d2, ... , dN)t

		2. Decompse matrix A to upper/lower triangular matrices:	A = LU

					|1  w1  0  0  0 ...  0|
					|0	1  w2  0  0 ...  0|
				U = |0  0  1  w3  0 ...  0|
					|0    ...	    ...	 0|
					|0  0  ...    0  0   1|  

					|e1  0  0  0  0 ...  0|
					|a2	e2  0  0  0 ...  0|
				L = |0  a3 e3  0  0 ...  0|
					|0    ...	    ...	 0|
					|0  0  ...    0  eN  0|  

		3. So need to solve Lg = d and Uy = g

		4. First find wi:	

				wi = ci / (bi - ai wi-1)
		
		5. To solve non-linear equation for wi, assume wi = zi-1 / zi. 
		   consider vecto V = (zi-1, zi)t, then

					|0   ci|   |zi-1|
					|-ai bi| * | zi |

		6. Then find gi 

				             di                ai
	 			gi = ---------------- - ---------------- gi-1
					  bi - ai * wi-1     bi - ai * wi-1

		7. Finally solve two system of equations of 

				L * g = d
				U * y = g


	author: Saied Hosseinipoor
	email:	saied@ou.edu
	Date:	March 18, 2017
	Modified: March 23, 2017

	Reference: 	Karniadakis, George Em, and Robert M. Kirby II. 
				Parallel scientific computing in C++ and MPI: a seamless 
				approach to parallel algorithms and their implementation. 
				Cambridge University Press, 2003.
 
----------------------------------------------------------------------------- */

# include <mpi.h>
# include <math.h>
# include <stdio.h>
# include <stdlib.h>
# include <time.h>

// function's signature
void timestamp ();
double f1 (double x);
double f2 (double x);
double f3 (double x);


int main (int argc, char *argv[]){
    
    int size;					// Grid size
    int my_rank, num_procs;		// Parallel process's parameters
	
	int m = 10;					// Size = 2^m
	
	double x_start  = 0.0;	double y_start	= 0.0;
	double x_end	= 1.0;	double y_end	= 1.0;
		

/* MPI initialization  ------------------------------------------------------ */
	
    MPI_Status status;
    int mpi_error_code;     /* Error code returned by MPI call */
	
    mpi_error_code = MPI_Init (&argc, &argv);
    mpi_error_code = MPI_Comm_size (MPI_COMM_WORLD, &num_procs);
    mpi_error_code = MPI_Comm_rank (MPI_COMM_WORLD, &my_rank);
    
    double wall_time = MPI_Wtime ();
    if (my_rank == 0) timestamp ();


/* Problem Initialization --------------------------------------------------- */

	size = (int) pow(2, m);
		
	if (my_rank == 0){
		printf ("\nSolution Method:\tDoubling Recurrence\n");
		printf ("Problem size:\t\t%d\n", size);		
		printf ("Number of processes:\t%d\n\n", num_procs);
	}
	
	double h = (x_end - x_start) / (double) (size-1);
	//printf ("h = %4.2f\n", h);
	
    double* a = (double*) malloc (size * sizeof(double));
    double* b = (double*) malloc (size * sizeof(double));
    double* c = (double*) malloc (size * sizeof(double));
    double* d = (double*) malloc (size * sizeof(double));
	
	for (int i = 0; i < size; i++)
		a[i] = b[i] = c[i] = d[i] = 0.0;
	
    	
	b[0] = 1.0;
	d[0] = y_start;

	for (int i = 1; i < size-1; i++){
		a[i] = 2.0 - h * f1 (x_start + (double) i * h);
		b[i] = -4.0 + 2.0 * h * h * f2 (x_start + (double) i * h);
		c[i] = 2.0 + h * f1 (x_start + (double) i * h);
		d[i] = 2.0 * h * h * f3 (x_start + (double) i * h);
	}

	b[size-1] = 1.0;
	d[size-1] = y_end;

	/*
	if (my_rank == 0)
		for (int i = 0; i < size; i++){
			if (i % (size/100) == 0){
			printf ("a[%d]= %4.2f, b[%d]= %4.2f, c[%d]= %4.2f, d[%d]= %4.2f, ", 
			i, a[i], i, b[i], i, c[i], i, d[i]);
			printf ("\n");}
		}
	;*/
	

/* Matrix Decomposition Phase ----------------------------------------------- */
		
	int my_share, my_first;
	double A[2][2], V[2][2], A10_temp, A11_temp;
	
	double* w = (double*) malloc (size * sizeof(double));
	
	
	MPI_Barrier (MPI_COMM_WORLD);
	
	A[0][0] = A[1][1] = 1.0;
	A[1][0] = A[0][1] = 0.0;
	
	my_share = (int) floor((double) size / num_procs);
	my_first = my_rank * my_share;
	
	
	for(int i = my_first; 
			i < (my_share + my_first) && i < size; 
			i++){
		A10_temp = - a[i] * A[0][0] + b[i] * A[1][0];
		A11_temp = - a[i] * A[0][1] + b[i] * A[1][1];
		A[0][0] = c[i] * A[1][0];
		A[0][1] = c[i] * A[1][1];
		A[1][0] = A10_temp;
		A[1][1] = A11_temp;
	}
	
	MPI_Barrier (MPI_COMM_WORLD);

	for (int i = 0; i <= log2(num_procs); i++){
		if (my_rank + pow(2.0, i) < num_procs)
			MPI_Send (A, 4, MPI_DOUBLE, (int)(my_rank + pow(2.0, i)), 0,
						MPI_COMM_WORLD);
		if (my_rank - pow(2.0, i) >= 0){
			MPI_Recv (V, 4, MPI_DOUBLE, (int)(my_rank - pow(2.0, i)), 0,
	     				MPI_COMM_WORLD, &status);
						
			A10_temp = A[0][0] * V[0][0] + A[0][1] * V[1][0];
			A[0][1] = A[0][0] * V[0][1] + A[0][1] * V[1][1];
			A[0][0] = A10_temp;
			A10_temp = A[1][0] * V[0][0] + A[1][1] * V[1][0];
			A[1][1] = A[1][0] * V[0][1] + A[1][1] * V[1][1];
			A[1][0] = A10_temp;
		}
	}
	
	
	w[my_first + my_share - 1] = A[0][1] / A[1][1];
	
	/*
	if (my_rank == 0)
		for (int i = 0; i < size; i++)
			if (i % (size/100) == 0)
				printf ("w[%d]=%4.2f,  ", i, w[i]);
	;*/
	
	if (num_procs > 1){
		if( my_rank == 0){
			MPI_Send (&w[my_first + my_share - 1], 1, MPI_DOUBLE,
						1, 0, MPI_COMM_WORLD);

		} else{
			MPI_Recv (&w[my_first - 1], 1, MPI_DOUBLE, my_rank - 1, 0,
		           			MPI_COMM_WORLD, &status);
		  if (my_rank != num_procs - 1)
			  MPI_Send (&w[my_first + my_share - 1], 1, MPI_DOUBLE,
		             		my_rank + 1, 0, MPI_COMM_WORLD);
		}
	}
	
	MPI_Barrier (MPI_COMM_WORLD);
	MPI_Allgather (w+my_first, my_share, MPI_DOUBLE,
					w, my_share, MPI_DOUBLE, MPI_COMM_WORLD);
	
	w[0] = c[0] / b[0];
			
	for (int i = my_first; 
			i > 0 && i < my_first + my_share - 1 && i < size -1; 
			i++)
		w[i] = c[i] / (b[i]  - a[i] * w[i-1]);
			
	
	MPI_Allgather (w+my_first, my_share, MPI_DOUBLE,
					w, my_share, MPI_DOUBLE, MPI_COMM_WORLD);
	MPI_Barrier (MPI_COMM_WORLD);
	
	/*				
	if (my_rank == 0)
		for (int i = 0; i < size; i++)
			if (i % (size/100) == 0)
				printf ("w[%d]=%4.2f,  ", i, w[i]);
	;*/

/* Lower Matrix Solution ---------------------------------------------------- */
	
	d[0] = d[0] / b[0];
	a[0] = 0;
	for (int i = 1; i < size; i++){
		d[i] /= (b[i] - a[i] * w[i-1]);
		a[i] /= (-b[i] + a[i] * w[i-1]);
	}
		
	for (int i = 0; i < log2(size); i++){	
		for (int j = my_first + my_share - 1; 
				j >= (int) pow(2,i) && j >= my_first; j--){
			d[j] += (a[j] * d[j-(int) pow (2.0,i)]);
			a[j] *= a[j-(int) pow (2.0,i)];
		}
		MPI_Barrier (MPI_COMM_WORLD);
		MPI_Allgather (d+my_first, my_share, MPI_DOUBLE,
						d, my_share, MPI_DOUBLE, MPI_COMM_WORLD);
		MPI_Allgather (a+my_first, my_share, MPI_DOUBLE,
						a, my_share, MPI_DOUBLE, MPI_COMM_WORLD);
		MPI_Barrier (MPI_COMM_WORLD);
	}
	

/* Upper Matrix Solution ---------------------------------------------------- */
	
	a[size-1] = 0;
	for (int i = 0; i < size-1; i++)
		a[i] = -w[i];	
	
	for (int i = 0; i < log2(size); i++){
		for (int j = my_first; 
				j + (int) pow(2,i) < size && j < my_first + my_share; j++){
			d[j] += (a[j] * d[j+(int) pow (2.0,i)]);
			a[j] *= a[j+(int) pow (2.0,i)];
		}
		MPI_Barrier (MPI_COMM_WORLD);
		MPI_Allgather (d+my_first, my_share, MPI_DOUBLE,
						d, my_share, MPI_DOUBLE, MPI_COMM_WORLD);
		MPI_Allgather (a+my_first, my_share, MPI_DOUBLE,
						a, my_share, MPI_DOUBLE, MPI_COMM_WORLD);
	}
	
	
	MPI_Barrier (MPI_COMM_WORLD);
	MPI_Allgather (d+my_first, my_share, MPI_DOUBLE,
					w, my_share, MPI_DOUBLE, MPI_COMM_WORLD);
	
	/*			
	if (my_rank == 0){
		for (int i = 0; i < size; i++)
			if (i % (size/100) == 0)
				printf ("y[%4.2f] = %4.2f, ", (double)i*h, d[i]);
		printf ("\n");
	}
	;*/
		
	
	
	// Mean Square Error Calculation Based on the Known Solution y = x
	double MSE = 0.0;
	for (int i = 0; i < size; i++)
		MSE += pow((double) i * h -  d[i], 2.0);
	MSE /= size;
	if (my_rank == 0) printf ("MSE = %4.2e\n\n", MSE);
	
    wall_time = MPI_Wtime() - wall_time;

    if (my_rank == 0){
        printf ( "Wall clock time = %f secs\n\n", wall_time );
        timestamp ();
		printf ("\n");
	}



/* Finalization ------------------------------------------------------------- */

	free (a); 
	free (b);
	free (c);
	free (d);
	free (w);
	
    MPI_Finalize();
	
	return 0;
}





/* Functions ---------------------------------------------------------------- */

/* -------------------------------------------------------------------------- */
void timestamp (){
  static char time_buffer[40];
  const struct tm *tm;
  time_t now;

  now = time ( NULL );
  tm = localtime ( &now );

  strftime ( time_buffer, 40, "%d %B %Y %I:%M:%S %p", tm );

  printf ( "%s\n", time_buffer );

  return;
}



/* -------------------------------------------------------------------------- */
double f1 (double x){
	return x;
}


/* -------------------------------------------------------------------------- */
double f2 (double x){
	return 1;
}


/* -------------------------------------------------------------------------- */
double f3 (double x){
	return 2 * x;
}

