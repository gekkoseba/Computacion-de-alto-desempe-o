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

	int hilos2c[] = {64,128,256,512},bloque2c[4];
	float tiempoGPU2c, t_i2c;
	float *dev_e2c, *hst_y2c;
	cudaEvent_t start2c, end2c;
	printf("seccion 2.c\n");
	for (int j=8;j<9;j++){
		int m=pow(10,j);
		hst_y2c = (float*) malloc(sizeof(float)*m+1);
		cudaMalloc((void**) &dev_e2c,(m+1)*sizeof(float));
		for(int i=0;i<m+1;i++){
			hst_y2c[i]=i;
	 	}
	 	printf("%f y %f\n",hst_y2c[0],hst_y2c[m] );


	 	for(int w= 0; w<4;w++){
			bloque2c[w] = ceil((float) (m+1) /hilos2c[w]);
			cudaEventCreate(&start2c);
			cudaEventCreate(&end2c);
			cudaEventRecord(start2c,0);
			cudaMemcpy(dev_e2c, hst_y2c, (m+1)*sizeof(float), cudaMemcpyHostToDevice);

			float n=powf(10,3);
			for (int i=0;i<n+1;i++){
				t_i2c = i/n;
				GPUEuler2<<<bloque2c[w],hilos2c[w]>>>(dev_e2c,t_i2c,1/n,m+1);
			}
			cudaEventRecord(end2c,0);
			cudaEventSynchronize(end2c);
			cudaEventElapsedTime(&tiempoGPU2c,start2c,end2c);
			printf("%f\n",tiempoGPU2c);
	 	}
		cudaFree(dev_e2c);
		free(hst_y2c);
	}
	return 0; 
} 