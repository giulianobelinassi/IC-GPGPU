#include <stdio.h>
#include <cuda_runtime.h>

int main()
{
	size_t m_free, m_total;
	double* array;
	
	cudaMemGetInfo(&m_free, &m_total);
	cudaMalloc((void **)&array, 20*1024*1024*sizeof(double));

	cudaMemGetInfo(&m_free, &m_total);
	printf("Livre: %ld, Total %ld\n", m_free, m_total);

	return 0;
}
