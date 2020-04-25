/*
 * This code is adopted from
 *		https://github.com/shwhyman/Navier_Stokes_3D/blob/master/parallel.c
 *		https://people.sc.fsu.edu/~jburkardt/c_src/poisson_mpi/poisson_mpi.html
 *		https://people.eecs.berkeley.edu/~demmel/cs267/lecture24/lecture24.html
 *
 * poisson.c -- Find the solution for 2D poisson eqauation:
 * 			
 *		uxx + uyy == 6xy
 *			u(x,0)=0; u(x,1)=x 
 *			u(0,y)=0; u(1,y)=y3
 *
 * This program solve the possion equation with given I.C. and B.C by 3 methods:
 * 			0:		Jaccobi
 *			1:		JOR
 *			2:		SOR
 *
 *
 * Input: 	N		grid size
			tol		error tolorance
 * 			method	solver method
 *
 * Output: the estimation of u function distribution along page [0,1]2.
 *
 *
 * Created by Saeid Hosseinipoor (saied@ou.edu).
 * Febraury 2017
 */
 
# include <math.h>
# include <mpi.h>
# include <stdio.h>
# include <stdlib.h>
# include <time.h>

double L = 1.0;			/* linear size of square region */
int m = 6;				/* easy way to calculate N = 2^m. */
int N;					/* number of interior points per dim */
double 	tol = 1.0E-03;	/* error tolorance */
int method = 1;			/* solver method definition */


double *u, *u_new;		/* linear arrays to hold solution */
//double **U, **U_new;

/* macro to index into a 2-D (N+2)x(N+2) array */
#define INDEX(i,j) ((N+2)*(i)+(j))

int my_rank;			/* rank of this process */
int *proc;				/* process indexed by vertex */
int *i_min, *i_max;		/* min, max vertex indices of processes */
int *left_proc, 
	*right_proc;		/* processes to left and right */

	
// Functions:
int main ( int argc, char *argv[] );
double* allocate_arrays_NULL ( int size );
void set_boundry_conditions ( double* mat, double Lenght, int size );
void solver ( double* u, double* u_new, double f[], int num_procs, 
				int method, double omega);
void make_domains ( int num_procs, int N, int* proc, int* i_min, int* i_max, 
					int* left_proc, int* right_proc );
double *source_function ( double Length, int size );
void timestamp ( );

/******************************************************************************/

int main ( int argc, char *argv[] ) 

/******************************************************************************/
/*
  Purpose:

    MAIN is the main program for poisson.

  Discussion:

    This program solves Poisson's equation in a 2D region.

    The Jacobi, JOR, and SOR iterative methods are used to solve the linear system.

    MPI is used for parallel execution, with the domain divided
    into strips.

  Modified:

    26 Feb 2017

  Local parameters:

    Local, double F[(N+2)x(N+2)], the source term.

    Local, int N, the number of interior vertices in one dimension.

    Local, int NUM_PROCS, the number of MPI processes.

    Local, double U[(N+2)*(N+2)], a solution estimate.

    Local, double U_NEW[(N+2)*(N+2)], a solution estimate.
*/
{
	double 	total_error;
	double 	max_error;
	double 	omega = 0.5;
	double 	*f;
	double 	local_error;
	double 	local_max_error;
	int 	local_grid_points;
	int 	grid_points;
	int		num_procs;
	int		mpi_error_code;		/* Error code returned by MPI call */
	int 	iteration;
	double 	*swap;
	double 	wall_time;
	int	max_iteration = 100000;
  
  
	// MPI initialization.
	mpi_error_code = MPI_Init(&argc, &argv);

	// Query this MPI process's rank.
	mpi_error_code = MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

	// Query the number of MPI processes in this run.
	mpi_error_code = MPI_Comm_size(MPI_COMM_WORLD, &num_procs);
		
	mpi_error_code = MPI_Barrier(MPI_COMM_WORLD);


	// Read commandline arguments, if present.
	if ( 1 < argc ){
		sscanf ( argv[1], "%d", &m );
	}

	N = (int) pow(2, m);

	if ( 2 < argc ){
		sscanf ( argv[2], "%lf", &tol );
	}
	
	if ( 3 < argc ){
		sscanf ( argv[3], "%d", &method );
	}
	  
	if ( my_rank == 0 ) {
		timestamp ( );
		printf ( "\n" );
		printf ( "POISSON_MPI:\n" );
		printf ( "  C version\n" );
		switch (method){
			case 0:
				printf ( "  2-D Poisson equation using Jacobi algorithm\n" );
				break;
			case 1:
				printf ( "  2-D Poisson equation using JOR algorithm\n" );
				break;
			case 2:
				printf ( "  2-D Poisson equation using SOR algorithm\n" );
				break;
		}
		printf ( "  ===================================================\n" );
		printf ( "  MPI version: 2-D domains, non-blocking send/receive\n" );
		printf ( "  Number of processes         = %d\n", num_procs );
		printf ( "  Number of interior vertices = %d\n", N );
		printf ( "  Desired fractional accuracy = %f\n", tol );
		printf ( "\n" );
	}

	
	u = allocate_arrays_NULL ( N );
	set_boundry_conditions ( u, L, N );
	u_new = allocate_arrays_NULL ( N );
	set_boundry_conditions ( u_new, L, N );
	
	f = source_function ( L, N );
	  
	proc = ( int * ) malloc ( ( N + 2 ) * sizeof ( int ) );
	i_min = ( int * ) malloc ( num_procs * sizeof ( int ) );
	i_max = ( int * ) malloc ( num_procs * sizeof ( int ) );
	left_proc = ( int * ) malloc ( num_procs * sizeof ( int ) );
	right_proc = ( int * ) malloc ( num_procs * sizeof ( int ) );
	
	make_domains ( num_procs, N, proc, i_min, i_max, left_proc, right_proc );

	// Begin timing.
	wall_time = MPI_Wtime ( );
	
	// Begin iteration.
	iteration = 0;
	MPI_Status unew_status;
	MPI_Status u_status;
	do {
		//if (iteration % 100 == 0){printf("%d: iteration loop stareted. iteration = %d;\n", my_rank, iteration);}
		if(my_rank != 0){
			MPI_Send(u_new + INDEX(i_min[my_rank], 0), (i_max[my_rank] - i_min[my_rank] + 1)*(N + 2),
					MPI_DOUBLE, 0, 43, MPI_COMM_WORLD);  
			MPI_Send(u + INDEX(i_min[my_rank], 0), (i_max[my_rank] - i_min[my_rank] + 1)*(N + 2),
					MPI_DOUBLE, 0, 44, MPI_COMM_WORLD);  					
		}
	
		if((my_rank == 0) && (num_procs > 1)){
			for(int sender = 1; sender < num_procs; sender++){
				MPI_Recv(u_new + INDEX(i_min[sender], 0), (i_max[sender] - i_min[sender] + 1)*(N + 2),
						MPI_DOUBLE, sender, 43, MPI_COMM_WORLD, &unew_status);
				MPI_Recv(u + INDEX(i_min[sender], 0), (i_max[sender] - i_min[sender] + 1)*(N + 2),
						MPI_DOUBLE, sender, 44, MPI_COMM_WORLD, &u_status);
			}
		}

		MPI_Barrier(MPI_COMM_WORLD);

		solver (u, u_new, f, num_procs, method, omega);
		++iteration;
		
	// Estimate the error 

		total_error = 0.0;
		grid_points = 0;
		max_error = 0.0;

		local_error = 0.0;
		local_grid_points = 0;
		local_max_error = 0.0;

		for ( int i = i_min[my_rank]; i <= i_max[my_rank]; i++ ){
			for ( int j = 1; j <= N; j++ ){
				if ( u_new[INDEX(i,j)] != 0.0 ) {
					local_error = local_error +
						fabs ( 1.0 - u[INDEX(i,j)] / u_new[INDEX(i,j)] );
						
					if (local_error > local_max_error) {
						local_max_error = local_error;
					}
				local_grid_points++;
				}
			}
		}
		
		MPI_Allreduce ( &local_error, &total_error, 1, MPI_DOUBLE, MPI_SUM,
		  MPI_COMM_WORLD );
		
		MPI_Allreduce ( &local_max_error, &max_error, 1, MPI_DOUBLE, MPI_MAX,
		  MPI_COMM_WORLD );

		MPI_Allreduce ( &local_grid_points, &grid_points, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD );

		if ( grid_points != 0 )
		{
		  total_error = total_error / grid_points;
		}
		// Check the path
		/*if ( my_rank == 0 && ( iteration % 100 ) == 0 ) 
		{
		  printf ( "  N = %d, grid_points = %d, local_grid_points = %d, iteration %4d,  Error = %g, Max Error = %g\n", 
			N, grid_points, local_grid_points, iteration, total_error, max_error );
		}*/
	
	//  Interchange U and U_NEW.
		swap = u;
		u = u_new;
		u_new = swap;
		
	} while ( (total_error > tol || max_error > tol) && iteration < max_iteration);
	  

	// Report on wallclock time.
	wall_time = MPI_Wtime() - wall_time;
	  
	  
	if ( my_rank == 0 ){
		printf ( "\n" );
		printf ( "  Wall clock time = %f secs\n", wall_time );
	}
	  
	 
	// Terminate MPI. 
	MPI_Finalize ( );
	  
	
	// test cases:
	/*double NN = (double) N;
	if (my_rank == 0){
	printf ("%d: u[0.5,0.5] = %f\n", my_rank, u_new[INDEX(N/2, N/2)]);
	printf ("%d: u[%f,%f] = %f --- %f\n", my_rank, (double)((NN)/(NN+1)), (double)((NN)/(NN+1)), u_new[INDEX(N, N)], 1.0/((NN+1)*(NN+1)*(NN+1)*(NN+1)) * (double)((NN)*(NN)*(NN)*(NN)));
	printf ("%d: u[%f,%f] = %f --- %f\n", my_rank, (double)((NN-10)/(NN+1)), (double)((NN-10)/(NN+1)), u_new[INDEX(N-10, N-10)], 1.0/((NN+1)*(NN+1)*(NN+1)*(NN+1)) * (double)((NN-10)*(NN-10)*(NN-10)*(NN-10)));
	printf ("%d: u[%f,%f] = %f --- %f\n", my_rank, (double)((NN-50)/(NN+1)), (double)((NN-50)/(NN+1)), u_new[INDEX(N-50, N-50)], 1.0/((NN+1)*(NN+1)*(NN+1)*(NN+1)) * (double)((NN-50)*(NN-50)*(NN-50)*(NN-50)));
	printf ("%d: u[%f,%f] = %f --- %f\n", my_rank, (double)((10)/(NN+1)), (double)((10)/(NN+1)), u_new[INDEX(10, 10)], 1.0/((NN+1)*(NN+1)*(NN+1)*(NN+1)) * (double)((10)*(10)*(10)*(10)));
	}*/

	if ( my_rank == 0 ){
		printf ( "\n" );
		printf ( "POISSON_MPI:\n" );
		printf ( "  ===================================================\n" );
		printf ( "  Normal end of execution.\n" );
		printf ( "  Number of iteration = %d\n", iteration );
		printf ( "\n" );
		timestamp ( );
	}
	  	
	// Free memories
	free ( f );
	free ( u );
	free ( u_new );
	free ( proc );
	free ( i_min );
	free ( i_max );
	free ( left_proc );
	free ( right_proc );
	
  return 0;
}


/******************************************************************************/
double* allocate_arrays_NULL ( int size ) 
/******************************************************************************/
/*
  Purpose:

    ALLOCATE_ARRAYS_NULL: 
		creates and zeros out the arrays of double with given size+2.

  Modified:
  
    24 Feb. 2017
	
*/
{
  int ndof;
  double* arr;

  ndof = ( size + 2 ) * ( size + 2 );

  arr = ( double * ) malloc ( ndof * sizeof ( double ) );

  for ( int i = 0; i < ndof; i++){
    arr[i] = 0.0;
  }

  return arr;
}
/******************************************************************************/


/******************************************************************************/
double* source_function ( double Length, int size ) 
/******************************************************************************/
/*
  Purpose:

    MAKE_SOURCE sets up the source term for the Poisson equation.
		this will be modified for different problems.
		here the function is 6*x*y

  Modified:

    24 Feb 2017
	
  Parameters:
  
	Size of 2D array
    Output, double *MAKE_SOURCE, a pointer to the (N+2)*(N+2) source term
    array.
*/
{
	double* f;
	double h;

	h = Length / ( double ) ( size + 1 );

	f = allocate_arrays_NULL ( size );

	for ( int i = 0; i < size + 2; i++){
	  for (int j = 0; j < size + 2; j++){
		  f[INDEX(i,j)] = 6.0 * (h*h) * ((double) (i * j));
	  }
	}

  return f;
}


/******************************************************************************/
void set_boundry_conditions ( double* mat, double Length, int size ) 
/******************************************************************************/
/*
  Purpose:

    MAKE_SOURCE sets up the source term for the Poisson equation.

  Modified:

    24 Feb 2017
	
  Parameters:
		Size of 2D array
    Output, double *MAKE_SOURCE, a pointer to the (N+2)*(N+2) source term
    array.
*/
{
  double h;
  h = Length / ( double ) ( size + 1 );
  
  for (int j = 0; j < size + 2; j++){
	mat[INDEX(size+1,j)] = (h*h*h) * ((double) (j*j*j));
  }
  
  for ( int i = 0; i < size + 2; i++){
	mat[INDEX(i,size+1)] = h * ((double) (i)); 
  }
  
  return;
}


/******************************************************************************/
void make_domains ( int num_procs, int N, int* proc, int* i_min, int* i_max, 
					int* left_proc, int* right_proc ) 
/******************************************************************************/
/*
  Purpose:

    MAKE_DOMAINS sets up the information defining the process domains.

  Modified:

    25 Feb 2017

  Parameters:

    Input:
		int NUM_PROCS:		the number of processes,
		int N:				size of the mesh,
		int* proc:			process assigned to a point,
		int* i_min:			start point for a process,
		int* i_max:			end point for a process,
		int* left_process:	left process to current process,
		int* right_process:	right process to curret process.
*/
{
	double d;
	double eps;
	double x_max;
	double x_min;
	
	// Divide the range [(1-eps)..(N+eps)] evenly among the processes.
	eps = 0.0001;
	d = ( N - 1.0 + 2.0 * eps ) / ( double ) num_procs;

	for ( int p = 0; p < num_procs; p++ ){
	// The I indices assigned to domain P will satisfy X_MIN <= I <= X_MAX.
    x_min = - eps + 1.0 + ( double ) ( p * d );
    x_max = x_min + d;
	
	// For the node with index I, store in PROC[I] the process P it belongs to.	
		for ( int i = 1; i <= N; i++ ){
			if ( x_min <= i && i < x_max ){
				proc[i] = p;
			}
		}
	}
	
	// Now find the lowest index I associated with each process P.
	for ( int p = 0; p < num_procs; p++ ){
		for ( int i = 1; i <= N; i++ ){
			if ( proc[i] == p ){
				i_min[p] = i;
				break;
			}
		}
    
	// Find the largest index associated with each process P.
		for ( int i = N; 1 <= i; i-- ){
			if ( proc[i] == p ){
				i_max[p] = i;
				break;
			}
		}
    
	// Find the processes to left and right. 
		left_proc[p] = - 1;
		right_proc[p] = -1;

		if ( proc[p] != -1 ) {
			if ( 1 < i_min[p] && i_min[p] <= N ){
				left_proc[p] = proc[i_min[p] - 1];
			}
			if ( 0 < i_max[p] && i_max[p] < N ){
				right_proc[p] = proc[i_max[p] + 1];
			}
		}
    }

	return;
}

/******************************************************************************/
void solver ( double* u, double* u_new, double f[], int num_procs, 
				int method, double omega ) 
/******************************************************************************/
/*
  Purpose:

    SOLVER carries out the Jacobi, JOR, or SOR iteration for the linear system.

  Modified:

    26 Feb 2017

  Parameters:

    Input:
		int NUM_PROCS:			number of processes,
		double* u:				solution matrix at iteration t,
		double* u_new:			solution matrix at iteration t+1,
		double f[]:				source function f as a matrix,
		int method:				implemetation methods:
										0 for Jaccobi,
										1 for JOR,
										2 for SOR,
		double omega:			relaxation factor for JOR and SOR.

    Output:
		double *u:				manipulate the input u,
		double* u_new:			manipulate the input u_new.
*/
{
	double h;
	MPI_Request request[4];
	int requests;
	MPI_Status status[4];
	// H is the lattice spacing.
	h = L / ( double ) ( N + 1 );
  
	requests = 0;

	if ( left_proc[my_rank] >= 0 && left_proc[my_rank] < num_procs ) {
		MPI_Irecv ( u + INDEX(i_min[my_rank] - 1, 1), N, MPI_DOUBLE,
		  left_proc[my_rank], 0, MPI_COMM_WORLD,
		  request + requests++ );

		MPI_Isend ( u + INDEX(i_min[my_rank], 1), N, MPI_DOUBLE,
		  left_proc[my_rank], 1, MPI_COMM_WORLD,
		  request + requests++ );
	}

	if ( right_proc[my_rank] >= 0 && right_proc[my_rank] < num_procs ) {
		MPI_Irecv ( u + INDEX(i_max[my_rank] + 1, 1), N, MPI_DOUBLE,
		  right_proc[my_rank], 1, MPI_COMM_WORLD,
		  request + requests++ );

		MPI_Isend ( u + INDEX(i_max[my_rank], 1), N, MPI_DOUBLE,
		  right_proc[my_rank], 0, MPI_COMM_WORLD,
		  request + requests++ );
	}
  
    
	// Jacobi update for internal vertices in my domain.
	if (method == 0){
		for ( int i = i_min[my_rank] + 1; i < i_max[my_rank]; i++ ){
			for ( int j = 1; j <= N; j++ ){
			  u_new[INDEX(i,j)] = 
				0.25 * ( u[INDEX(i-1,j)] + u[INDEX(i+1,j)] +
						 u[INDEX(i,j-1)] + u[INDEX(i,j+1)] -
						 h * h * f[INDEX(i,j)] );
			}
		}
	
		// Wait for all non-blocking communications to complete.
		MPI_Waitall ( requests, request, status );
		
		// Jacobi update for boundary vertices in my domain.
		int i = i_min[my_rank];
		for ( int j = 1; j <= N; j++ ){
			u_new[INDEX(i,j)] =
			  0.25 * ( u[INDEX(i-1,j)] + u[INDEX(i+1,j)] +
					   u[INDEX(i,j-1)] + u[INDEX(i,j+1)] -
					   h * h * f[INDEX(i,j)] );
		}

		i = i_max[my_rank];
		if (i != i_min[my_rank]){
			for (int j = 1; j <= N; j++){
			  u_new[INDEX(i,j)] =
				0.25 * ( u[INDEX(i-1,j)] + u[INDEX(i+1,j)] +
						 u[INDEX(i,j-1)] + u[INDEX(i,j+1)] -
						 h * h * f[INDEX(i,j)] );
			}
		}	  
	}
  
  
	// JOR update for internal vertices in my domain.
	if (method == 1){
		for ( int i = i_min[my_rank] + 1; i < i_max[my_rank]; i++ ){
			for ( int j = 1; j <= N; j++ ){
			  u_new[INDEX(i,j)] = (1-omega) * u[INDEX(i,j)] + omega *
				0.25 * ( u[INDEX(i-1,j)] + u[INDEX(i+1,j)] +
						 u[INDEX(i,j-1)] + u[INDEX(i,j+1)] -
						 h * h * f[INDEX(i,j)] );
			}
		}
		
		// Wait for all non-blocking communications to complete.
		MPI_Waitall ( requests, request, status );
 
		// JOR update for boundary vertices in my domain.
		int i = i_min[my_rank];
		for ( int j = 1; j <= N; j++ ){
			u_new[INDEX(i,j)] = (1-omega) * u[INDEX(i,j)] + omega *
			  0.25 * ( u[INDEX(i-1,j)] + u[INDEX(i+1,j)] +
					   u[INDEX(i,j-1)] + u[INDEX(i,j+1)] -
					   h * h * f[INDEX(i,j)] );
		}

		i = i_max[my_rank];
		if (i != i_min[my_rank]){
			for (int j = 1; j <= N; j++){
			  u_new[INDEX(i,j)] = (1-omega) * u[INDEX(i,j)] + omega *
				0.25 * ( u[INDEX(i-1,j)] + u[INDEX(i+1,j)] +
						 u[INDEX(i,j-1)] + u[INDEX(i,j+1)] -
						 h * h * f[INDEX(i,j)] );
			}
		}	  
	}
 

  
	// SOR update for internal vertices in my domain.
	if (method == 2){
			
		for ( int i = i_min[my_rank] + 1; i < i_max[my_rank]; i++ ){
			for ( int j = 1; j <= N; j++ ){
			  u_new[INDEX(i,j)] = (1-omega) * u[INDEX(i,j)] + omega *
				0.25 * ( u_new[INDEX(i-1,j)] + u[INDEX(i+1,j)] +
						 u_new[INDEX(i,j-1)] + u[INDEX(i,j+1)] -
						 h * h * f[INDEX(i,j)] );
			}
		}
		
		// Wait for all non-blocking communications to complete.
		MPI_Waitall ( requests, request, status );
 
		// SOR update for boundary vertices in my domain.
		int i = i_min[my_rank];
		for ( int j = 1; j <= N; j++ ){
			u_new[INDEX(i,j)] = (1-omega) * u[INDEX(i,j)] + omega *
			  0.25 * ( u_new[INDEX(i-1,j)] + u[INDEX(i+1,j)] +
					   u_new[INDEX(i,j-1)] + u[INDEX(i,j+1)] -
					   h * h * f[INDEX(i,j)] );
		}

		i = i_max[my_rank];
		if (i != i_min[my_rank]){
			for (int j = 1; j <= N; j++){
			  u_new[INDEX(i,j)] = (1-omega) * u[INDEX(i,j)] + omega *
				0.25 * ( u_new[INDEX(i-1,j)] + u[INDEX(i+1,j)] +
						 u_new[INDEX(i,j-1)] + u[INDEX(i,j+1)] -
						 h * h * f[INDEX(i,j)] );
			}
		}	  
	}
 
 
	return;
}


/******************************************************************************/
void timestamp ( )
/******************************************************************************/
/*
  Purpose:

    TIMESTAMP prints the current YMDHMS date as a time stamp.

  Example:

    31 May 2001 09:45:54 AM

  Licensing:

    This code is distributed under the GNU LGPL license. 

  Modified:

    24 September 2003

  Author:

    John Burkardt

  Parameters:

    None
*/
{
# define TIME_SIZE 40

  static char time_buffer[TIME_SIZE];
  const struct tm *tm;
  time_t now;

  now = time ( NULL );
  tm = localtime ( &now );

  strftime ( time_buffer, TIME_SIZE, "%d %B %Y %I:%M:%S %p", tm );

  printf ( "%s\n", time_buffer );

  return;
# undef TIME_SIZE
}
