#include "linsys.h"
#include "math.h"

int cholcol(int n, double A[][NMAX])
{
	int i, j, k;
 	

	/* Note que se separarmos esse "for encaixado triplo"
	 * teremos a implementação via linha.
	 */
 	for (j = 0; j < n; ++j)
	{
		for (k = 0; k < j; ++k)
			for (i = j; i < n; ++i)
				A[i][j] -= A[i][k]*A[j][k];
		
		if (A[j][j] <= 0)
			return -1;
			
		A[j][j] = sqrt(A[j][j]);
		
		for (i = j+1; i < n; ++i)
			A[i][j] /= A[j][j];
	}
	 
	return 0;
	
}

int forwcol(int n, double A[][NMAX], double b[])
{
	int i, j;
	
	for (j = 0; j < n; ++j)
	{
		if (A[j][j] == 0)
			return -1;
		
		b[j] /= A[j][j];
		
		for (i = j+1; i < n; ++i)
			b[i] -= A[i][j]*b[j];
	}	
	return 0;
}

int backcol(int n, double A[][NMAX], double b[], int trans)
{
	int i, j;
	
	if (trans == 1)
	{
		
		/* Implementemos aqui uma versão modificada da orientada a linhas,
		 * pois transpor uma matriz e percorrer por linhas é o mesmo que
		 * percorrer a original por colunas.
		 */
		for (j = n-1; j >= 0; --j)
		{
			for (i = j+1; i < n; ++i)
				b[j] -= A[i][j]*b[i];
		
			if (A[j][j] == 0)
				return -1;
			
			b[j] /= A[j][j];
		}
	
		return 0;
	}
	
	for (j = n-1; j >= 0; --j)
	{
		if (A[j][j] == 0)
			return -1;
		
		b[j] /= A[j][j];
		
		for (i = 0; i < j; ++i)
			b[i] -= A[i][j]*b[j];
	}
	
	return 0;
}

int symmcol(int n, double A[][NMAX], double b[])
{
	if (!cholcol(n, A) && !forwcol(n, A, b) && !backcol(n, A, b, 1))
		return 0;
	return -1;
}

int lucol(int n, double A[][NMAX], int p[])
{
	int i, j, k;
	int imax;
	double temp;
	
	for (k = 0; k < n-1; ++k)
	{
		/* Procure pelo maior elemento*/
		imax = k;
		for (i = k+1; i < n; ++i)
			if (fabs(A[i][k]) > fabs(A[imax][k]))
				imax = i;
		p[k] = imax;
		
		if (imax != k)
			for (j = 0; j < n; ++j)
			{
				temp       = A[k][j];
				A[k][j]    = A[imax][j];
				A[imax][j] = temp;
			}
		
		if (A[k][k] == 0)
			return -1;
		
		/*Gauss*/
		for (i = k+1; i < n; ++i)
			A[i][k] /= A[k][k]; 
		for (j = k+1; j < n; ++j) 
			for (i = k+1; i < n; ++i) 
				A[i][j] -= A[k][j]*A[i][k];
	}
	return (A[k][k] == 0)? -1: 0;
}

int sscol(int n, double A[][NMAX], int p[], double b[])
{
	int i, j;
	double temp;
	
	if (lucol(n, A, p) == -1)
		return -1;
	/*P*b*/
	for (i = 0; i < n-1; ++i)
	{
		temp    = b[i];
		b[i]    = b[p[i]];
		b[p[i]] = temp;
	}
	
	/*Ly = Pb*/
	for (j = 0; j < n; ++j)
		for (i = j+1; i < n; ++i)
			b[i] -= A[i][j]*b[j];
	
	/*Ux = y*/
	/* Eu sei que se o algorítimo chegou aqui,
	 * então a matriz é não singular, logo não
	 * preciso das checagens de singularidade 
	 * da função abaixo, porém assim deixarei
	 * para tentar deixar o código mais
	 * reutilizável.
	 */
	return backcol(n, A, b, 0);
}

