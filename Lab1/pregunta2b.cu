#include <time.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ void GPUEuler2(float *y, float t_i, float delta,int N) {
	int myID = threadIdx.x + blockDim.x * blockIdx.x;
	if(myID < N) {
		y[myID] = y[myID] + delta * (4*t_i - y[myID]+3+myID);
	}
}

int main(int argc, char** argv) { 

	int hilos2b = 256,bloque2b;
	float tiempoGPU2b, t_i2b;
	float *dev_e2b, *hst_y2b;
	cudaEvent_t start2b, end2b;
	printf("seccion 2.b\n");
	for (int j=4;j<9;j++){
		int m=pow(10,j);
		hst_y2b = (float*) malloc(sizeof(float)*m+1);
		cudaMalloc((void**) &dev_e2b,(m+1)*sizeof(float));
		bloque2b = ceil((float) (m+1) /hilos2b);
		for(int i=0;i<m+1;i++){
			hst_y2b[i]=i;
	 	}
	 	cudaEventCreate(&start2b);
		cudaEventCreate(&end2b);
		cudaEventRecord(start2b,0);
		cudaMemcpy(dev_e2b, hst_y2b, (m+1)*sizeof(float), cudaMemcpyHostToDevice);

		float n=powf(10,3);
		for (int i=0;i<n+1;i++){
			t_i2b = i/n;
			GPUEuler2<<<bloque2b,hilos2b>>>(dev_e2b,t_i2b,1/n,m+1);
		}
		cudaEventRecord(end2b,0);
		cudaEventSynchronize(end2b);
		cudaEventElapsedTime(&tiempoGPU2b,start2b,end2b);
		printf("%f\n",tiempoGPU2b);
		cudaFree(dev_e2b);
		free(hst_y2b);
	}
	return 0; 
} 
