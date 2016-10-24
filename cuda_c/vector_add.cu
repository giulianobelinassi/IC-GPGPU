#include <stdio.h>
#include <cuda_runtime.h>
#include <unistd.h>

#define N 10*1024*1024

__global__ void gpu_vector_add(int* a, int* b, int* c)
{
	c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

int main()
{
	//static int a[N], b[N], c[N];   /*Variáveis na memória principal*/
	int *a, *b, *c;
	int *d_a, *d_b, *d_c; /*Variáveis que alocaremos na memória da GPU*/
	int i;
	size_t size = N*sizeof(int);
	int err;

	a = (int*) malloc(size);
	b = (int*) malloc(size);
	c = (int*) malloc(size);

	err = cudaMalloc((void **)&d_a, size); /*Aloque um inteiro na memória de vídeo e faça d_a apontar para ele.*/
	if (err != cudaSuccess)
	{
		return 1;
	}
	err = cudaMalloc((void **)&d_b, size);
	if (err != cudaSuccess)
	{
		return 1;
	}
	err = cudaMalloc((void **)&d_c, size);
	if (err != cudaSuccess)
	{
		return 1;
	}

	for (i = 0; i < N; ++i)
		a[i] = 42;

	for (i = 0; i < N; ++i)
		b[i] = 1337;

	/*Copie a e b para os seus respectivos espaços alocados na GPU*/
	cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
	                                       /* O que é isso?
											* a flag cudaMemcpyHostToDevice 
											* é parte de uma enum que especifica
											* o fluxo de dados. HostToDevice
											* especifica que copiaremos os
											* dados da RAM para a GRAM
											*/
	
	cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
	
	gpu_vector_add<<<N,1>>>(d_a, d_b, d_c);
	       /*N = número de blocos. 1 bloco = um conjunto de threads*/

	usleep(1000000);
	cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
	printf("Resultado: %d\n", c[0]);
	/*Libera a memória na placa. E se eu não liberar?*/
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	free(a); free(b); free(c);
	return 0;
}
