
/* -----------------------------------------------------------------------------
	
	This code solves the folloeing boundary value problem by cyclic reduction
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

		2. form each three rows eliminate yi-1 and yi+1 and come with N/2 
		   equations in total, then do it agian and countinue log(N) time until
	 	   get the answer for yN/2:

				e(i,j) = -a(i,j) / b(i-1,j)
				f(i,j) = -c(i,j) / b(i+1,j)

				a(i,j) = e(i,j) * a(i-1,j-1) 
				b(i,j) = b(i,j-1) + e(i,j) * b(i-1,j-1) + f(i,j) * b(i+1,j-1)
				c(i,j) = f(i,j) * c(i+1,j-1)
				d(i,j) = d(i,j-1) + e(i,j) * d(i-1,j-1) + f(i,j) * d(i+1,j-1)

		   where i is the equation number and j is iteration number.

		3. Back substite and find yi



	author: Saied Hosseinipoor
	email:	saied@ou.edu
	Date:	March 18, 2017
	Modified: March 24, 2017

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

#include <stdarg.h>
#define INDEX(i,j) ((m)*(i)+(j))


void timestamp ();
void printA (double* A, char M, int rows, int cols, int my_rank);
double f1 (double x);
double f2 (double x);
double f3 (double x);

int main (int argc, char *argv[]){
    
    int my_rank, num_procs;

	int m = 10;					// Problem size is 2^m -1
	
	double x_start  = 0.0;		double y_start	= 0.0;
	double x_end	= 1.0;		double y_end	= 1.0;
		

/* MPI initialization  ------------------------------------------------------ */
	
    MPI_Status status;
    int mpi_error_code;     /* Error code returned by MPI call */
	
    mpi_error_code = MPI_Init (&argc, &argv);
    mpi_error_code = MPI_Comm_size (MPI_COMM_WORLD, &num_procs);
    mpi_error_code = MPI_Comm_rank (MPI_COMM_WORLD, &my_rank);
    
    double wall_time = MPI_Wtime ();
    if (my_rank == 0) timestamp ();


/* Problem Initialization --------------------------------------------------- */

	int size = (int) pow(2, m) - 1;			
	
	double h = (x_end - x_start) / (double) (size-1);
	
	if (my_rank == 0){
		printf ("\nSolution Method:\tCycling Reduction\n");
		printf ("Problem size:\t\t%d\n", size);		
		printf ("Number of processes:\t%d\n\n", num_procs);
	}
	
    double* a = (double*) malloc ((size+1) * (m) * sizeof(double));
    for(int i = 0; i < size+1; i++){
	    for(int j = 0; j < m; j++)
	        a[INDEX(i,j)] = 0.0;
	}
	
    double* b = (double*) malloc ((size+1) * (m) * sizeof(double));
    for(int i = 0; i < size+1; i++){
	    for(int j = 0; j < m; j++)
	        b[INDEX(i,j)] = 0.0;
	}
	
	double* c = (double*) malloc ((size+1) * (m) * sizeof(double));
    for(int i = 0; i < size+1; i++){
	    for(int j = 0; j < m; j++)
	        c[INDEX(i,j)] = 0.0;
	}
	
	double* d = (double*) malloc ((size+1) * (m) * sizeof(double));
    for(int i = 0; i < size+1; i++){
	    for(int j = 0; j < m; j++)
	        d[INDEX(i,j)] = 0.0;
	}
	
	
	b[INDEX(1,0)] = 1.0;
	d[INDEX(1,0)] = y_start;
	
	for (int i = 2; i < size; i++){
		a[INDEX(i,0)] = 2.0 - h * f1 (x_start + (double) (i-1) * h );
		b[INDEX(i,0)] = -4.0 + 2.0 * h * h * f2 (x_start + (double) (i-1) * h);
		c[INDEX(i,0)] = 2.0 + h * f1 (x_start + (double) (i-1) * h);
		d[INDEX(i,0)] = 2.0 * h * h * f3 (x_start + (double) (i-1) * h);
	}

	b[INDEX(size,0)] = 1.0;
	d[INDEX(size,0)] = y_end;
	
	MPI_Barrier(MPI_COMM_WORLD);
	

/* Matrix Reduction Phase --------------------------------------------------- */

	for (int j = 1; j < m; j++){
		
		int my_share = (int) round ((pow(2.0, m-j)-1) / (double) num_procs);
		if (my_share == 0) my_share = 1;
		int s = (int) pow(2.0, j-1);
		
		for (int i = (1 + my_share * my_rank) * (int) pow(2.0, j); 
				i < (1 + my_share * (my_rank+1)) * (int) pow(2.0, j) 
				&& i <= (int) pow(2.0, m) - (int) pow(2.0, j); 
				i = i + (int) pow(2.0, j)){
			
			double e = - a[INDEX(i,j-1)] / b[INDEX(i-s,j-1)];
			double f = - c[INDEX(i,j-1)] / b[INDEX(i+s,j-1)];
			
			a[INDEX(i,j)] = e * a[INDEX(i-s,j-1)];
			c[INDEX(i,j)] = f * c[INDEX(i+s,j-1)];
			
			b[INDEX(i,j)] = b[INDEX(i,j-1)] + 
						e * c[INDEX(i-s,j-1)] + f * a[INDEX(i+s,j-1)];
			
			d[INDEX(i,j)] = d[INDEX(i,j-1)] + 
						e * d[INDEX(i-s,j-1)] + f * d[INDEX(i+s,j-1)];
			
			if (my_rank != 0){
	            MPI_Send (&a[INDEX(i,j)], 1, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD);
				MPI_Send (&b[INDEX(i,j)], 1, MPI_DOUBLE, 0, 2, MPI_COMM_WORLD);
				MPI_Send (&c[INDEX(i,j)], 1, MPI_DOUBLE, 0, 3, MPI_COMM_WORLD);
				MPI_Send (&d[INDEX(i,j)], 1, MPI_DOUBLE, 0, 4, MPI_COMM_WORLD);
			} else{
				for (int src = 1; src < num_procs; src++){
					int k = i + my_share * (int) pow(2.0, j) * src;
					if (k <= (int) pow(2.0, m) - (int) pow(2.0, j)){
				        MPI_Recv(&a[INDEX(k,j)], 1, MPI_DOUBLE, src, 1, 
								MPI_COMM_WORLD, &status);
				        MPI_Recv(&b[INDEX(k,j)], 1, MPI_DOUBLE, src, 2, 
								MPI_COMM_WORLD, &status);
				        MPI_Recv(&c[INDEX(k,j)], 1, MPI_DOUBLE, src, 3, 
								MPI_COMM_WORLD, &status);
				        MPI_Recv(&d[INDEX(k,j)], 1, MPI_DOUBLE, src, 4, 
								MPI_COMM_WORLD, &status);
						
					}
				}
			}
		}
		
		MPI_Barrier(MPI_COMM_WORLD);
		
		MPI_Bcast(a, (size+1) * (m), MPI_DOUBLE, 0, MPI_COMM_WORLD);
		MPI_Bcast(b, (size+1) * (m), MPI_DOUBLE, 0, MPI_COMM_WORLD);
		MPI_Bcast(c, (size+1) * (m), MPI_DOUBLE, 0, MPI_COMM_WORLD);
		MPI_Bcast(d, (size+1) * (m), MPI_DOUBLE, 0, MPI_COMM_WORLD);
		
		MPI_Barrier(MPI_COMM_WORLD);
	}
	
	
	
/* Back Substituation Phase ------------------------------------------------- */

	double* y = (double*) malloc ((size+1) * sizeof(double));
				
	int middle = (int) pow(2,m-1);
	y[middle] = d[INDEX(middle,m-1)] / b[INDEX(middle,m-1)];

		
	for (int k = m-1; k > 0; k--){
		
		int my_share = (int) round ((pow(2.0, m-k)) / (double) num_procs);
		if (my_share == 0) my_share = 1;
		
		int s = (int) pow(2.0, k-1);
		
		for (int i = (1 + 2 * my_share * my_rank) * s; 
				(i < (1 + 2 * my_share * (my_rank + 1)) * s) &&
				(i <= (int) pow (2,m) - (int) pow (2,k-1)); 
				i = i + 2 * s){
		
			y[i] = (d[INDEX(i,k-1)] - 
					a[INDEX(i,k-1)] * y[i-s] - c[INDEX(i,k-1)] * y[i+s]) 
					/ b[INDEX(i,k-1)];
			
			if (my_rank != 0){
	            MPI_Send (&y[i], 1, MPI_DOUBLE, 0, i, MPI_COMM_WORLD);
			} else
				for (int src = 1; src < num_procs; src++){
					int t = i + 2 * my_share * src * s;
					if (t <= (int) pow (2,m) - (int) pow (2,k-1)){
				        MPI_Recv(&y[t], 1, MPI_DOUBLE, src, t, 
								MPI_COMM_WORLD, &status);
					}
				}
			}
			
			MPI_Barrier (MPI_COMM_WORLD);
			MPI_Bcast (y, (size+1), MPI_DOUBLE, 0, MPI_COMM_WORLD);		
	}
	
	
	// Results Point
	
	if (my_rank == 0){
		printf ("\n\n");
		for (int i = 1; i < size+1; i++)
			printf ("y[%4.2f]=%4.2f, ", (double) (i-1) * h, y[i]);
		printf ("\n\n");
	}
	
	
	
	// Mean Square Error Calculation Based on the Known Solution y = x
	double MSE = 0.0;
	for (int i = 1; i < size+1; i++)
		MSE += pow((double) (i-1) * h -  y[i], 2.0);
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
	free (y);
	
    MPI_Finalize();
	
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
void printA (double* A, char M, int rows, int cols, int my_rank){
	for (int i = 0; i < rows; i++){
        for (int j = 0; j < cols; j++){
            printf("%c%d[%d,%d]=%6.4f ", M,  my_rank, i, j, A[i*cols+j]);
        }
        printf("\n");
    }
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