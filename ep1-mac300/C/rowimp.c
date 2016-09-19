#include "linsys.h"
#include "math.h"

int cholrow(int n, double A[][NMAX])
{
	int i, j, k;
	
	for (j = 0; j < n; ++j)
	{
		for (k = 0; k < j; ++k)
			A[j][j] -= A[j][k]*A[j][k];
		
		if (A[j][j] <= 0)
			return -1;
			
		A[j][j] = sqrt(A[j][j]);
		
		for (i = j+1; i < n; ++i)
		{
			for (k = 0; k < j; ++k)
				A[i][j] -= A[i][k]*A[j][k];
			A[i][j] /= A[j][j];
		}
	}
	
	return 0;
}

int forwrow(int n, double A[][NMAX], double b[])
{
	int i, j;
	
	for (i = 0; i < n; ++i)
	{
		for (j = 0; j < i; ++j)
			b[i] -= A[i][j]*b[j];
		
		if (A[i][i] == 0)
			return -1;
			
		b[i] /= A[i][i];
	}
	
	return 0;
}

int backrow(int n, double A[][NMAX], double b[], int trans)
{
	int i, j;

	if (trans == 1)
	{
		/* Implementemos aqui uma versão modificada da orientada a colunas,
		 * pois transpor uma matriz e percorrer por colunas é o mesmo que
		 * percorrer a original por linhas.
		 */
		for (i = n-1; i >= 0; --i)
		{
			b[i] /= A[i][i];
			
			for (j = 0; j < i; ++j)
				b[j] -= A[i][j]*b[i];
	 
	 	}
	 	return 0;
	}
	
	
	for (i = n-1; i >= 0; --i)
	{
		if (A[i][i] == 0)
			return -1;
		
		for (j = i+1; j < n; ++j)
			b[i] -= A[i][j]*b[j];
		
		b[i] /= A[i][i];
	}
	
	return 0;
}

int symmrow(int n, double A[][NMAX], double b[])
{
	if (!cholrow(n, A) && !forwrow(n, A, b) && !backrow(n, A, b, 1))
		return 0;
	return -1;
}

int lurow(int n, double A[][NMAX], int p[])
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
		{
			A[i][k] /= A[k][k]; 
			for (j = k+1; j < n; ++j) 
				A[i][j] -= A[k][j]*A[i][k];
		}
	}
	
	return (A[k][k] == 0)? -1: 0;
}

int ssrow(int n, double A[][NMAX], int p[], double b[])
{
	int i, j;
	double temp;
	
	if (lurow(n, A, p) == -1)
		return -1;
	/*P*b*/
	for (i = 0; i < n-1; ++i)
	{
		temp    = b[i];
		b[i]    = b[p[i]];
		b[p[i]] = temp;
	}
	
	/*Ly = Pb*/
	for (i = 1; i < n; ++i)
		for (j = 0; j < i; ++j)
			b[i] -= A[i][j]*b[j];
	
	/*Ux = y*/
	/* Eu sei que se o algorítimo chegou aqui,
	 * então a matriz é não singular, logo não
	 * preciso das checagens de singularidade 
	 * da função abaixo, porém assim deixarei
	 * para tentar deixar o código mais
	 * reutilizável.
	 */
	return backrow(n, A, b, 0);
}

