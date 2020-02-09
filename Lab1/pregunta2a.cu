#include <time.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

void CPUEuler2(int m, float* y_i, float delta_t,float t_i ){
	for (int i=0;i<m+1;i++){
		y_i[i]=y_i[i]+delta_t*(4*t_i-y_i[i]+3+i);
	}
}


int main(int argc, char const *argv[])
{
	printf("seccion 2.a\n");
	for (int j=4;j<9;j++){
		int m=pow(10,j);
		float *y;
		y = (float*) malloc(sizeof(float)*m+1);
		for(int i=0;i<m+1;i++){
			y[i]=i;
	 	}

		clock_t start, end;
		start=clock();
		float n=pow(10,3);
		for (int i=0;i<n+1;i++){
			float t_i=i/n;
			CPUEuler2(m,y,1/n,t_i);
		}
		end=clock();
		double cpu_time_used = ((double) (end - start)) *1000 / CLOCKS_PER_SEC;
		printf("%f\n",cpu_time_used);
	}
	return 0; 
}