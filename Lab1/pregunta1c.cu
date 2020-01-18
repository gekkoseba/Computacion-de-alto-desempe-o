#include <time.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void hybridGPuEuler(float *y, float y_0 ,int N) {
	int myID = threadIdx.x + blockDim.x * blockIdx.x;
	if (myID <N) {
		y[myID] = y[myID] + y_0;
	}

}

float* hybridCPUEuler(float t_0, float delta_t){
	int n=10/delta_t +1;
	float *s = (float*) malloc(sizeof(float)*n);
	s[0]=0;
	for (int i=0;i<n-1;i++){
		s[i+1]=s[i]+delta_t*(9*powf(i*delta_t,2)-4*(i*delta_t)+5);
	}
	return s;
}

int main(int argc, char const *argv[])
{
	printf("seccion 1.c\n");
	int hilos1c = 256,n1c,bloque1c;
	float delta_t1c,tiempoGPU1c;
	float *dev_e1c,*hst_y;
	clock_t startcpu1c, endcpu1c;
	cudaEvent_t startgpu1c, endgpu1c;
	for(int i=1;i<7;i++) {
		delta_t1c=powf(10,-i);
		n1c=10/delta_t1c +1;
		startcpu1c = clock();
		hst_y = hybridCPUEuler(0,delta_t1c);
		endcpu1c = clock();
		bloque1c = ceil((float) n1c /hilos1c);
		cudaEventCreate(&startgpu1c);
		cudaEventCreate(&endgpu1c);
		cudaEventRecord(startgpu1c,0);
		cudaMalloc( (void**) &dev_e1c, n1c*sizeof(float));
		cudaMemcpy(dev_e1c,hst_y,n1c*sizeof(float),cudaMemcpyHostToDevice);
		hybridGPuEuler<<<bloque1c,hilos1c>>>(dev_e1c,4,n1c);
		cudaEventRecord(endgpu1c,0);
		cudaEventSynchronize(endgpu1c);
		cudaEventElapsedTime(&tiempoGPU1c,startgpu1c,endgpu1c);
		cudaMemcpy(hst_y,dev_e1c,n1c*sizeof(float),cudaMemcpyDeviceToHost);
		cudaFree(dev_e1c);
		free(hst_y);
		cudaEventDestroy(startgpu1c);
		cudaEventDestroy(endgpu1c);
		double cpu_time_used = ((double) (endcpu1c - startcpu1c)) * 1000 / CLOCKS_PER_SEC;

		printf("tiempo en CPU: %f ms, tiempo en GPU: %f ms y el tiempo total es: %f ms\n", cpu_time_used ,tiempoGPU1c,cpu_time_used+tiempoGPU1c);
	}

	return 0;
}