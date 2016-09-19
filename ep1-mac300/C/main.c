#include "linsys.h"
#include <stdio.h>
#include <string.h>
#include <time.h>

int main(int argc, char* argv[])
{
	static double A[NMAX][NMAX];
	static double b[NMAX];
	static int    p[NMAX];
	static char filestring[16] = "symm/sym_";
	static int n;
	char* strptr = filestring + strlen(filestring);
	int i;
	
	clock_t ticks;
	
	
	for (i = 1; i <= 10; ++i)
	{
		sprintf(strptr, "%02d", i);
		n = read_linsys_file(filestring, A, b);
		printf("Calculando por linhas %s...\n", filestring);
		ticks = clock();
		if(symmrow(n, A, b) == -1)
			fprintf(stdout, "Erro. Matriz não simétrica ou não definida positiva.\n");
		ticks = clock() - ticks;
		fprintf(stdout, "Tempo da CPU gasto: %f\n", ((double) ticks)/CLOCKS_PER_SEC);
		
		if (argc >= 2)
		{	
			strcat(filestring, ".row");
			fprintf(stdout, "Escrevendo para %s...\n", filestring);
			write_linsys_file(filestring, n, A, b);
		}
	}
	
	for (i = 1; i <= 10; ++i)
	{
		sprintf(strptr, "%02d", i);
		n = read_linsys_file(filestring, A, b);
		printf("Calculando por colunas %s...\n", filestring);
		ticks = clock();
		if(symmcol(n, A, b) == -1)
			fprintf(stdout, "Erro. Matriz não simétrica ou não definida positiva.\n");
		ticks = clock() - ticks;
		fprintf(stdout, "Tempo da CPU gasto: %f\n", ((double) ticks)/CLOCKS_PER_SEC);
		
		if (argc >= 2)
		{	
			strcat(filestring, ".col");
			fprintf(stdout, "Escrevendo para %s...\n", filestring);
			write_linsys_file(filestring, n, A, b);
		}
	}
	
	
	/*PARTE 2*/
	strcpy(filestring, "matr/mat_");
	strptr = filestring + strlen(filestring);
	fprintf(stdout, "\n\nParte 2: Eliminação de Gauss\n\n");
	for (i = 1; i <= 10; ++i)
	{
		sprintf(strptr, "%02d", i);
		n = read_linsys_file(filestring, A, b);
		printf("Calculando por linhas %s...\n", filestring);
		ticks = clock();
		if(ssrow(n, A, p, b) == -1)
			fprintf(stdout, "Erro: Matriz singular.\n");
		ticks = clock() - ticks;
		fprintf(stdout, "Tempo da CPU gasto: %f\n", ((double) ticks)/CLOCKS_PER_SEC);
		
		if (argc >= 2)
		{	
			strcat(filestring, ".row");
			fprintf(stdout, "Escrevendo para %s...\n", filestring);
			write_linsys_file(filestring, n, A, b);
		}
	}
	
	for (i = 1; i <= 10; ++i)
	{
		sprintf(strptr, "%02d", i);
		n = read_linsys_file(filestring, A, b);
		printf("Calculando por colunas %s...\n", filestring);
		ticks = clock();
		if(sscol(n, A, p, b) == -1)
			fprintf(stdout, "Erro: Matriz singular.\n");
		ticks = clock() - ticks;
		fprintf(stdout, "Tempo da CPU gasto: %f\n", ((double) ticks)/CLOCKS_PER_SEC);
		
		if (argc >= 2)
		{	
			strcat(filestring, ".col");
			fprintf(stdout, "Escrevendo para %s...\n", filestring);
			write_linsys_file(filestring, n, A, b);
		}
	}
/*
	n = read_linsys_file("symm/sim_01", A, b);
	print_vector(n, b);
	symmcol(n, A, b);
	write_linsys_file("hue", n, A, b);
*/	
	
	return 0;
}
