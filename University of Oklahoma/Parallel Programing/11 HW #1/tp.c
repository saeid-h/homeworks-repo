

/*
 * trapezoidal_integration.c -- Trapizoidal program
 *
 * solve the trapizoidal integral  for given fuction which is sin(x) here
 *
 * Input: n.
 * 		function f and integral bounds are given in the 
 * Output: the estimation of interal and elapsed time to calculate.
 *
 *
 * Created by Saeid Hosseinipoor (saied@ou.edu).
 */

#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"
#include "math.h"


double Trapizoidal(double local_a, double local_b, int local_n,
           double h);    /* Calculate local area  */

double f(double x); 	/* function we're integrating */


int main (int argc, char* argv[])
{ /* main */

    /*
	* vaiable declariation section
	*/
	
	/* MPI variables */
	const int maximum_message_length = 100;
    const int first_rank  = 0;       /* Ranks run 0..number_of_processes-1 */
    const int master_rank = 0;       /* Rank of master process             */
    const int tag         = 0;       /* Tag for messages                   */

    MPI_Status status;          	 /* Return status for receive          */

    int        number_of_processes;  /* Number of processes in this run    */
    int        my_rank;              /* Rank of this process               */
    int        source;               /* Rank of sender                     */
	int        destination = 0;      /* Rank of receiver                   */
    int        mpi_error_code;       /* Error code returned by MPI call    */

	
	/* Program variables */
    double      a;         /* Left endpoint             */
    double      b;         /* Right endpoint            */
    long int    n;    	   /* Number of trapezoids      */
	int 		m;		   /* n = 2^m, m is our input	*/
    double      h;         /* Trapezoid base length     */
    double      local_a;   /* Left endpoint my process  */
    double      local_b;   /* Right endpoint my process */
    int         local_n;   /* Number of trapezoids for  */
                           /* my calculation            */
    double      local_int; /* Integral over my interval */
    double      r_int;     /* Received integral         */
    double      total;     /* Total integral            */

    double      start_time, 
				finish_time, 
				elapsed_time;

	
	
   /*
    * Start up MPI.
    */
	
	a = 0;
	b = 2*acos(0);
	m = 24;
	
    mpi_error_code =
        MPI_Init(&argc, &argv);

   /*
    * Query this MPI process's rank.
    */
    mpi_error_code =
        MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

   /*
    * Query the number of MPI processes in this run.
    */
    mpi_error_code =
        MPI_Comm_size(MPI_COMM_WORLD, &number_of_processes);
		
	mpi_error_code = MPI_Barrier(MPI_COMM_WORLD);

	/*
	loop to for different cases.
	*/
	for (m = 20; m < 25; m++) {

		start_time = MPI_Wtime();			/* Record the time when process started	*/
		
		n = (long int) powl(2, m);

	   if (my_rank == master_rank) {
		  
		  for (source = 1; source < number_of_processes; source++) {
			 MPI_Send(&a, 1, MPI_DOUBLE, source, tag, MPI_COMM_WORLD);
			 MPI_Send(&b, 1, MPI_DOUBLE, source, tag, MPI_COMM_WORLD);
			 MPI_Send(&n, 1, MPI_INT, source, tag, MPI_COMM_WORLD);
		  }
	   } else {
		  MPI_Recv(&a, 1, MPI_DOUBLE, master_rank, tag, MPI_COMM_WORLD, &status);
		  MPI_Recv(&b, 1, MPI_DOUBLE, master_rank, tag, MPI_COMM_WORLD, &status);
		  MPI_Recv(&n, 1, MPI_INT, master_rank, tag, MPI_COMM_WORLD, &status);
	   }
		
		
		h = (b - a ) / n;     				/* h is the same for all processes */
		local_n = n / number_of_processes;  /* So is the number of trapezoids */

		/* Length of each process' interval of
		 * integration = local_n*h.  So my interval
		 * starts at: */
		local_a = a + my_rank * local_n * h;
		local_b = local_a + local_n * h;
		local_int = Trapizoidal(local_a, local_b, local_n, h);
			
			

	   /*
		* What to do depends on which rank this is.
		*   Non-master rank: Calculate a trapizoidal area on given portion 
		*	and send it to the master rank.
		*
		*   Master rank: Loop over all the ranks, skipping itself,
		*     receive a partial area from each such rank, and add them up.
		*/
			
		if (my_rank == master_rank) {
			
			total = local_int;
			for (source = 1; source < number_of_processes; source++) {
				mpi_error_code = 
					MPI_Recv(&r_int, 1, MPI_DOUBLE, source, tag,
						MPI_COMM_WORLD, &status);
				total += r_int;
			}


		} /* if (my_rank == master_rank) */

		else {

			mpi_error_code = 
				MPI_Send(&local_int, 1, MPI_DOUBLE, destination,
					tag, MPI_COMM_WORLD);
		
		} /* if (my_rank == master_rank)...else */

		/* Get the time and calculate elapse time for parallel processes.	*/
		finish_time = MPI_Wtime();
		elapsed_time = finish_time - start_time;

		 /* Print the result */
		if (my_rank == master_rank) {
			printf("With n = %d (=2^%d) trapezoids and %d parallel processes, our estimate of the \n",
				n, m, number_of_processes);
			printf("integral from %4.4f to %4.4f = %.20f\n\n",
				a, b, total);
			printf("Elapsed time = %e seconds\n\n\n", elapsed_time);
		}
	
    } /* for m */

   /*
    * Shut down MPI.
    */
	
    mpi_error_code =
        MPI_Finalize();
		
	
	return 0;

} /* main */



/*------------------------------------------------------------------
 * Function:    f
 * Purpose:     Compute value of function to be integrated
 * Input args:  x
 */
double f(double x) {
    double return_val;

    return_val = sin(x);

    return return_val;
} /* f */


/*------------------------------------------------------------------
 * Function:     Trapizoidal
 * Purpose:      Estimate a definite integral using the trapezoidal
 *               rule
 * Input args:   local_a (left endpoint)
 *               local_b (right endpoint)
 *               local_n (number of trapezoids)
 *               h (stepsize = length of base of trapezoids)
 * Return val:   Trapezoidal rule estimate of integral from
 *               local_a to local_b
 */
double Trapizoidal(
          double  local_a   /* in */,
          double  local_b   /* in */,
          int     local_n   /* in */,
          double  h         /* in */) {
    double integral;   /* Store result in integral  */
    double x;
    int i;

    integral = (f(local_a) + f(local_b)) / 2.0;
    for (i = 1; i <= local_n - 1; i++) {
        x = local_a + i*h;
        integral += f(x);
    }
    integral = integral * h;

    return integral;
} /*  Trapizoidal  */


