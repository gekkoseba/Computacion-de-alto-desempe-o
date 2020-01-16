#include <iostream> 
#include <math.h>
#include <time.h>

float* CPUEuler(float t_0, float y_0, float delta_t){
	int n=10/delta_t;
	float y[n];
	for (int i=0;i<n;i++){
		y[i]=y_0;
		for (int j=0;j<i;j++){
			float t_j=t_0+j*delta_t;
			y[i]+=delta_t*(9*pow(t_j,2)-4*t_j+5);
		}
	}
	return y;
}
float CPUEuler2(int m, float* y_i, float delta_t,float t_i ){
	float n=1/delta_t;
	for (int i=1;i<m;i++){
		y_i[i]=y_i[i]+delta_t*(4*t_i-y_i[i]+3+i);
	}
}

int main(){ 

	/*printf("seccion 1.a\n");
	clock_t start, end;
	for(int i=1;i<7;i++){
		float delta_t=pow(10,-i);
		start=clock();
		CPUEuler(0,4,delta_t);
		end=clock();
		double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
		printf("%f\n",cpu_time_used);
	}
	*/
	
	printf("seccion 2.a\n");
	for (int j=4;j<9;j++){
		int m=pow(10,j);
		float y[m];
		for(int i=0;i<m;i++){
			y[i]=i;
	 	}
		clock_t start, end;
		start=clock();
		float n=pow(10,3);
		for (int i=0;i<n;i++){
			float t_i=i/n;
			CPUEuler2(m,y,1/n,t_i);
		}
		end=clock();
		double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
		printf("%f\n",cpu_time_used);
	}
	return 0; 
} 

