#include "linsys.h"
#include <stdio.h>

/** Print a matrix A of size n*/
void print_matrix(int n, double A[][NMAX])
{
	int i, j;
	
	for (i = 0; i < n; ++i)
	{	for (j = 0; j < n; ++j)
			fprintf(stdout, "%f\t", A[i][j]);
		putchar('\n');
	}
	putchar('\n');
}

/** Print a vector v of size n*/
void print_vector(int n, double v[])
{
	int i;
	
	for (i = 0; i < n; ++i)
		fprintf(stdout, "%f\t", v[i]);
	putchar('\n');
}

/** Lê matriz de arquivo criado pelo gerador disponibilizado
  * pelo professor.
  */
int read_linsys_file(const char* filename, double A[][NMAX], double b[])
{
	int n;
	int i, j;
	int garbage;
	FILE* file = fopen(filename, "r");

	if (file == NULL)
		return 0; /*Arquivo não encontrado.*/

	fscanf(file, "%d", &n);

	for (i = 0; i < n; i++)
		for (j = 0; j < n; j++)
			fscanf(file, "\n%d %d %lf", &garbage, &garbage, &A[i][j]);
			
	for (i = 0; i < n; i++)
		fscanf(file,"\n%d %lf", &garbage, &b[i]);
	
	return n;
}

int write_linsys_file(const char* filename, int n, double A[][NMAX], double b[])
{
	int i, j;
	FILE* file = fopen(filename, "w");

	if (file == NULL)
		return 0; /*Arquivo não encontrado.*/

	fprintf(file, "%d", n);

	for (i = 0; i < n; i++)
		for (j = 0; j < n; j++)
			fprintf(file, "\n%3d %3d % .20e", i, j, A[i][j]);

	for (i = 0; i < n; i++)
		fprintf(file,"\n%3d % .20e", i, b[i]);
	
	return n;
}
