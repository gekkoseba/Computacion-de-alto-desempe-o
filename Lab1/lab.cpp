#include <iostream> 
#include <math.h>


float* CPUEuler(float t_0, float y_0, float delta_t){
	int n=10/delta_t;
	float y[n];
	for (int i=0;i<n;i++){
		y[i]=y_0;
		for (int j=0;j<i;j++){
			int t_j=t_0+j*delta_t;
			y[i]+=delta_t*(9*pow(t_j,2)-4*t_j+5);
		}
	}
	return y;
}

int main(){ 
	for (int i=0;i<10/0.1;i++){
		printf("%f\n",CPUEuler(0,4,0.1)[i]);	
	}
	return 0; 
} 

