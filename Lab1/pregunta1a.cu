#include <time.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>


void CPUEuler(float t_0, float y_0, float delta_t){
	int n=10/delta_t +1;
	float *y = (float*) malloc(sizeof(float)*n);
	y[0]=y_0;
	for (int i=0;i<n-1;i++){
		y[i+1]=y[i]+delta_t*(9*powf(i*delta_t,2)-4*(i*delta_t)+5);
		/*
		for (int j=0;j<i;j++){
			float t_j=t_0+j*delta_t;
			y[i]+=delta_t*(9*pow(t_j,2)-4*t_j+5);
		}
		*/
	}
	free(y);
	//return y;
}

int main(int argc, char const *argv[]) {
	
	printf("seccion 1.a\n");
	clock_t start, end;
	for(int i=1;i<7;i++) {
		float delta_t=powf(10,-i);
		start=clock();
		CPUEuler(0,4,delta_t);
		end=clock();
		double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
		printf("%f\n",cpu_time_used);
	}

	return 0;
}