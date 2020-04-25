#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
double begin, end;
int ARRAYSIZE = 16;
#define INDEX(i,j) i*ARRAYSIZE+j
struct rec
{
	int x,y,z;
};
double *u;

void ludecomp(int n,double *a){
    int i,j,k;
	#pragma omp parallel shared(a,n) private(i,j,k)
	{
		for(k = 0; k < n - 1; ++k) {
			#pragma omp for schedule(guided)
			for(i = k + 1; i < n; i++) {
				const double aik = a[INDEX(i,k)] / a[INDEX(k,k)];
				for(j = k + 1; j < n; j++) {
					a[INDEX(i,j)] -= aik * a[INDEX(k,j)];
				}
			}
		}
	}
}

int main (int argc, char *argv[]) 
{
	printf("Cores available: %i\n",omp_get_num_procs());
	omp_set_num_threads(omp_get_max_threads());

	begin =omp_get_wtime();
    int i,j;
	
	int nthreads, tid;
    char f_name[50];
	
	if (argc > 1){
		printf("Receiving: %s\n", argv[1]); 
		ARRAYSIZE = atoi(argv[1]);
	}
	
	double *a;
	a = (double*)calloc(ARRAYSIZE*ARRAYSIZE, sizeof(double));
	
    double det;
	double logsum;
    //Create filename
    sprintf(f_name,"%d.bin",ARRAYSIZE);
    printf("Reading array file %s of size %dx%d\n",f_name,ARRAYSIZE,ARRAYSIZE);
	
    //Open file
    FILE *datafile=fopen(f_name,"rb");
    //Read elelements
    for (i=0; i< ARRAYSIZE; i++)
        for (j=0; j< ARRAYSIZE; j++)
        {
		fread(&a[INDEX(i,j)],sizeof(double),1,datafile);
        }
		printf("Matrix has been read.\n");

		
	printf("Performing LU decomp.\n");
	ludecomp(ARRAYSIZE,a);	
	
	//Calculate determinant
	int neg_nums = 0;
	det = a[INDEX(0,0)];
	logsum = log10(fabs(a[INDEX(0,0)]));
	for (i = 1; i < ARRAYSIZE; i++){
		if (a[INDEX(i,i)] > 0){
			neg_nums++;
			logsum += log10(a[INDEX(i,i)]);
		}
		else
			logsum += log10(fabs(a[INDEX(i,i)]));
	}
	det = pow(10.0, logsum);
	if (neg_nums % 2 != 0)
		det = -det;
	
	printf("Determinant: %f\n",det);
	printf("log10(fabs(det)): %f\n",logsum);
	end = omp_get_wtime();
	printf("%i, %f\n",omp_get_max_threads(), (double)(end - begin) / CLOCKS_PER_SEC);
}