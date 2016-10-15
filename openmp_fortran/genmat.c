#include <stdio.h>
#include <stdlib.h>

#define A(i, j) (A[i*n + j])

double rand_in_range(double min, double max)
{
	  return min + (rand() / (double) (RAND_MAX)) * (max - min);
}

int main(int argc, char* argv[])
{
	int n;	
	char* fpath;
	int i, j;

	double* A;
	double* b; 

	FILE* file;

	if (argc < 3)
	{	fprintf(stdout, "USO: %s <tamanho> <arq_de_saida>\n", argv[0]);
		return 1;
	}

	n = atoi(argv[1]);
	fpath = argv[2];

	file = fopen(fpath, "w");
	if (file == NULL)
		return 1;
	
	A = malloc(n*n*sizeof(double));
	b = malloc(n*sizeof(double));

	for (i = 0; i < n; ++i)
		for (j = 0; j < n; ++j)
			A(i, j) = rand_in_range(-5, 5);

	for (i = 0; i < n; ++i)
		b[i] = rand_in_range(-5, 5);

	fprintf(file, "%d", n);
	for (i = 0; i < n; ++i)
		for (j = 0; j < n; ++j)
			fprintf(file, "\n%5d %5d % .20e", i, j, A(i, j));
	for (i = 0; i < n; ++i)
			fprintf(file, "\n%5d %5d % .20e", i, j, b[i]);

	free(A); free(b);

	return 0;
}
