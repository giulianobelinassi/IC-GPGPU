#include <stdio.h>
#include <cuda_runtime.h>

__global__ void gpu_add(int* a, int* b, int* c)
{
	*c = *a + *b;
}

int main()
{
	int a, b, c;          /*Variáveis na stack desse programa (na memória principal)*/
	int *d_a, *d_b, *d_c; /*Variáveis que alocaremos na memória da GPU*/

	cudaMalloc((void **)&d_a, sizeof(int)); /*Aloque um inteiro na memória de vídeo e faça d_a apontar para ele.*/
	cudaMalloc((void **)&d_b, sizeof(int));
	cudaMalloc((void **)&d_c, sizeof(int));
	
	a = 42;
	b = 1337;

	/*Copie a e b para os seus respectivos espaços alocados na GPU*/
	cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
	                                       /* O que é isso?
											* a flag cudaMemcpyHostToDevice 
											* é parte de uma enum que especifica
											* o fluxo de dados. HostToDevice
											* especifica que copiaremos os
											* dados da RAM para a GRAM
											*/
	
	cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);
	
	gpu_add<<<1,1>>>(d_a, d_b, d_c);
	       /*pq eu preciso dessa template ainda é um mistério.*/

	cudaMemcpy(&c, d_c, sizeof(int), cudaMemcpyDeviceToHost);

	printf("Resultado: %d\n", c);
	/*Libera a memória na placa. E se eu não liberar?*/
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	return 0;
}
