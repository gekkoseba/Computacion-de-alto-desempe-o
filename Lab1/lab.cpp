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
/*float* CPUEuler2(float t_0, float y_0, float delta_t){
	int n=10/delta_t;
	float y[n];
	y[0]=y_0;
	for (int i=1;i<n;i++){
		float t_i=t_0+i*delta_t;
		y[i]=y[i-1]+delta_t*(9*pow(t_i,2)-4*t_i+5);
	}
	return y;
}
*/

int main(){ 
	clock_t start, end;
	for(int i=1;i<7;i++){
		float delta_t=pow(10,-i);
		start=clock();
		CPUEuler(0,4,delta_t);
		end=clock();
		double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
		printf("%f\n",cpu_time_used);
	}
	
	/*for (int i=0;i<10/0.1;i++){
		printf("%f ",CPUEuler(0,4,0.1)[i]);
	}
	return 0; */
} 

