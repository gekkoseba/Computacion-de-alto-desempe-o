#include <time.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void GPuEuler(float *y, float t_0, float y_0 ,int N, float delta) {
	int myID = threadIdx.x + blockDim.x * blockIdx.x;
	if (myID <N) {
		y[myID] = y_0;
	    for(int i=0;i<myID;i++){
	        float j_del = delta * i+ t_0;
	        y[myID] =y[myID]+ delta * (9*j_del*j_del-4*j_del+5);
	    }
	}

}

int main(int argc, char const *argv[])
{
	printf("seccion 1.b\n");
	int hilos1b = 256,n1b,bloque1b;
	float delta_t1b,tiempoGPU1b;
	float *dev_e1b,*hst_y;
	cudaEvent_t start1b, end1b;
	for(int i=1;i<5;i++) {
		delta_t1b=powf(10,-i);
		n1b=10/delta_t1b +1;
		hst_y = (float*) malloc(n1b*sizeof(float));
		bloque1b = ceil((float) n1b /hilos1b);
		cudaEventCreate(&start1b);
		cudaEventCreate(&end1b);
		cudaEventRecord(start1b,0);
		cudaMalloc( (void**) &dev_e1b, n1b*sizeof(float));
		GPuEuler<<<bloque1b,hilos1b>>>(dev_e1b,0,4,n1b,delta_t1b);
		cudaEventRecord(end1b,0);
		cudaEventSynchronize(end1b);
		cudaEventElapsedTime(&tiempoGPU1b,start1b,end1b);
		cudaMemcpy(hst_y,dev_e1b,n1b*sizeof(float),cudaMemcpyDeviceToHost);
		cudaFree(dev_e1b);
		free(hst_y);
		cudaEventDestroy(start1b);
		cudaEventDestroy(end1b);
		printf("%f\n",tiempoGPU1b);
	}

	return 0;
}