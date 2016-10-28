#include <stdio.h>

#define N 20*1024*1024

void cpu_vector_add(int* restrict a, int* restrict b, int* restrict c)
{
	int i;

	for (i = 0; i < N; ++i)
		c[i] = a[i] + b[i];
}

int main()
{
	int size = N*sizeof(int);
	int *a = malloc(size);
	int *b = malloc(size);
	int *c = malloc(size);
	int i;
	
	for (i = 0; i< N; ++i)
		a[i] = 42;

	for (i = 0; i< N; ++i)
		a[i] = 1337;

	cpu_vector_add(a, b, c);

	printf("%d", c[0]);

	return 0;
}
