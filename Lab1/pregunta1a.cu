#include <math.h>
#include <time.h>
#include <stdio.h>

float* CPUEuler(float t_0, float y_0, float delta_t){
	int n=10/delta_t + 1;
	float *y = (float*) malloc(sizeof(float)*n);
	for (int i=0;i<n;i++){
		y[i]=y_0;
		for (int j=0;j<i;j++){
			float t_j=t_0+j*delta_t;
			y[i]+=delta_t*(9*powf(t_j,2)-4*t_j+5);
		}
	}
	return y;
}

int main(){ 

	printf("seccion 1.a\n");
	clock_t start, end;
	float *y;
	for(int i=1;i<7;i++){
		float delta_t=pow(10,-i);
		//int n=10/delta_t + 1;
		start=clock();
		y = CPUEuler(0,4,delta_t);
		end=clock();
		double cpu_time_used = 1000 * ((double) (end - start)) / CLOCKS_PER_SEC;
		printf("%f\n",cpu_time_used);
	}
	return 0; 
} 