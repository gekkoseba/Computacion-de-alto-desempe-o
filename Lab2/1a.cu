#include <time.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>


struct AoS{
	int up;
	int left;
	int right;
	int down;
};

struct SoA{
	int* up;
	int* left;
	int* right;
	int* down;
};

void printAoS(struct AoS *array,int size){
	for (int i = 0; i < size; ++i)
	{
		printf("%d ",array[i].up );
		printf("%d ",array[i].left );
		printf("%d ",array[i].right );
		printf("%d\n",array[i].down );
	}
}
void printSoA(struct SoA structure,int size){
	for (int i = 0; i < size; ++i)
	{
		printf("%d ",structure.up[i] );
		printf("%d ",structure.left[i] );
		printf("%d ",structure.right[i] );
		printf("%d\n",structure.down[i] );
	}
}
void initSoA(){
	FILE* file = fopen ("initial.txt", "r");
  	int N = 0;
  	int M = 0;
	fscanf (file, "%d", &N);    
	fscanf (file, "%d", &M);  
	struct SoA structure;
	structure.up =(int*) malloc(sizeof(int)*N*M); 
	structure.down =(int*) malloc(sizeof(int)*N*M); 
	structure.left =(int*) malloc(sizeof(int)*N*M); 
	structure.right =(int*) malloc(sizeof(int)*N*M); 
	for (int i = 0; i < N*M; ++i)
	{
		fscanf (file, "%d", &structure.right[i]);
	}
	for (int i = 0; i < N*M; ++i)
	{
		fscanf (file, "%d", &structure.up[i]);
	}
	for (int i = 0; i < N*M; ++i)
	{
		fscanf (file, "%d", &structure.left[i]);
	}
	for (int i = 0; i < N*M; ++i)
	{
		fscanf (file, "%d", &structure.down[i]);
	}
	fclose (file);   
	printSoA(structure,5);
	return ;
}
void initAoS(){
	FILE* file = fopen ("initial.txt", "r");
  	int N = 0;
  	int M = 0;
	fscanf (file, "%d", &N);    
	fscanf (file, "%d", &M);  
	struct AoS* array =(struct AoS*) malloc(sizeof(struct AoS)*N*M);
	for (int i = 0; i < N*M; ++i)
	{
		fscanf (file, "%d", &array[i].right);
	}
	for (int i = 0; i < N*M; ++i)
	{
		fscanf (file, "%d", &array[i].up);
	}
	for (int i = 0; i < N*M; ++i)
	{
		fscanf (file, "%d", &array[i].left);
	}
	for (int i = 0; i < N*M; ++i)
	{
		fscanf (file, "%d", &array[i].down);
	}
	fclose (file);   
	printAoS(array,5);
	return ;
}

int main()
{
	initAoS();
	initSoA();
	return 0;
}