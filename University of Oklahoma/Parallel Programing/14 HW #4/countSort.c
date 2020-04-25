

/* -----------------------------------------------------------------------------
	author: Saied Hosseinipoor
	email:	saied@ou.edu
	Date:	April 27, 2017
	Modified: April 29, 2017

----------------------------------------------------------------------------- */


#include	<stdio.h>
#include	<stdlib.h>
#include	<omp.h>
#include	<string.h>


int main (int argc, char* argv[]){
	/*Get number of threads from command line */

	//printf ("%d\n", argc);
	
	int thread_count;
	if (argc > 1)
		thread_count = strtol(argv[1], NULL, 10);
	else
		thread_count = 4;
			
	int n;
	if (argc > 2) 
		n = strtol(argv[2], NULL, 10);
	else
		n = 40000;
			
	int a[n];
	
	for (int i = 0; i < n; i++) a[i] = rand() % 1000;
	
	/*
	printf ("\n\n");
	for (int i = 0; i < n; i++){
		printf ("%d,  ", a[i]);
	}
	printf ("\n\n\n");
	*/
	
	int i, j, count;
	int* tmp = malloc(n* sizeof (int));
	
	double startTime = omp_get_wtime( ); 
	
#	pragma omp parallel num_threads (thread_count) \
	default (none) private (count, i, j) shared (n, a, tmp)
		
	for (i=0; i<n; i++){
	    count = 0;
	    for (j = 0; j < n; j++)
			if (a[j] < a[i]) 
				count++;
			else if 
				(a[j] == a[i] && j < i) 
					count++;
	   tmp[count] = a[i];
	}
	double endTime = omp_get_wtime( ); //start the timer
	printf ("The total time for sorting %d numbers by %d threads  is %f \n", \
		n, thread_count, endTime - startTime );
 	
	memcpy (a, tmp, n*sizeof(int));
	free (tmp);
	
	
	printf ("\n\n\n");
	printf ("The first 100 elements of sorted matrix: \n");
	for (int i = 0; i < 100; i++){
		printf ("%d,  ", a[i]);
	}
	printf ("\n\n\n");
	
	
	return 0;
}  /* main */


