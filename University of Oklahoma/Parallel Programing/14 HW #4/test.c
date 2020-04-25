#include	<stdio.h>
#include	<stdlib.h>
#include 	<string.h>



void PrintMatrix(int m, int n, double *A) {
	int i, j;
	for (i = 0; i < m; i++) {
		for (j = 0; j < n; j++) {
			printf("%.02f\t", A[i*n+j]);
		}
		printf("\n");
	}
	printf("\n");
	
}



void Inverse (double A_inv[], double A[], int n){
	
	for (int i = 0; i < n; i++){
		for (int j = 0; j < n; j++){
			if (i == j)
				A_inv[i*n+j] = 1;
			else
				A_inv[i*n+j] = 0;
		}
	}
	
	PrintMatrix(n, n, A_inv);
	
	
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
		//PrintMatrix(n, n, A_inv);
		PrintMatrix(n, n, temp);
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
		//PrintMatrix(n, n, A_inv);
		PrintMatrix(n, n, temp);
	}

}



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









int main (int argc, char* argv[]){

	int w = 4;
	double testVar[w*w];
	for (int i = 0; i < w*w; i++){
		/*
		if (i == 0 || i == 4 || i == 8) 
			testVar[i] = 1;
		else
			testVar[i] = 0;
		*/
		testVar[i] = i+1;
	}
	testVar[8] = -1;
	testVar[w*w-1] = -1;
	
	PrintMatrix(w, w, testVar);
	printf ("\n");
	
	double testVarInv[w*w];
	Inverse (testVarInv, testVar, w);
	PrintMatrix(w, w, testVarInv);
	printf ("\n\n");
	
	printf ("\n %4.2f\n\n", Determinant (testVar, w));
	
	double C[w*w];
	Multiply (C, testVar, testVarInv, w);
	
	PrintMatrix(w, w, C);
	printf ("\n");
	
	
	
	
	/*Get number of threads from command line */
	struct st {
		int x;
		int y;
	};
	
	int n = 10;
	double* I = (double*) malloc (n * n * sizeof(double));
	for (int i = 0; i < n; i++){
		for (int j = 0; j < n; j++){
			if (i == j)
				I[i*n+j] = 1;
			else
				I[i*n+j] = 0;
		}
	}
	
	int d = 0;
	int c = 0;
	printf ("\n%d\n\n", d++);
	printf ("\n%d\n\n", ++c);
	
	
	w = 2;
	n = 8;
	int q = n / w;
	c = 0;
	for (int i = 0; i < q; i++){
		for (int j = 0; j < q; j++){
			for (int p = 0; p < w; p++){
				for (int q = 0; q < w; q++){
					printf ("%d   ", i*w*n+j*w+p*n+q);
				}
			}
		}
	}
	
	
	for (int i = 0; i < 10; i++){
		printf ("%d,  ", rand() % 1000);
	}
	
	struct st a;
	
	a.x = 3;
	
	//int thread_count = strtol(argv[1], NULL, 10);
	//#	pragma omp parallel num_threads (thread_count)
	//Hello();
	return 0;
}  /* main */


void Hello () {
	//int my_rank = omp_get_thread_num();
	//int thread_count = omp_get_num_threads();
	//printf("Hello from thread %d of %d\n", my_rank, thread_count);
}   /* Hello */







