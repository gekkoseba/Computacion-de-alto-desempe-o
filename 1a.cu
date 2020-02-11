#include <time.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

//Arreglo de estructuras
struct AoS{
	int up;
	int left;
	int right;
	int down;
};
//Estructura de arreglos
struct SoA{
	int* up;
	int* left;
	int* right;
	int* down;
};
//Imprime arreglo de estructuras
void printAoS(struct AoS *array,int size){
	for (int i = 0; i < size; ++i)
	{
		printf("%d ",array[i].right );
		printf("%d ",array[i].up );
		printf("%d ",array[i].left );
		printf("%d\n",array[i].down );
	}
}
//imprime masa del sistema de arreglo de estructuras
void checkMassAoS(struct AoS *array,int size){
	int sum=0;
	for (int i = 0; i < size; ++i)
	{
		sum+=array[i].up +array[i].left+array[i].right+array[i].down;
	}
	printf("%d\n",sum );
}
//Kernel de colision de arreglo de estructura
__global__ void collision_kernel_AoS(struct AoS *array,int size){
	int myID = threadIdx.x + blockDim.x * blockIdx.x;
	if (myID<size)
	{
		if (array[myID].up==1 && array[myID].down==1 && array[myID].right==0 && array[myID].left==0)
		{
			array[myID].up=0;
			array[myID].down=0;
			array[myID].left=1;
			array[myID].right=1;
		}
		else if (array[myID].up==0 && array[myID].down==0 && array[myID].right==1 && array[myID].left==1)
		{
			array[myID].up=1;
			array[myID].down=1;
			array[myID].left=0;
			array[myID].right=0;
		}
	}
}
//Hace todo para arreglo de estructuras
void initAoS(){
	//leer archivo
	FILE* file = fopen ("a.txt", "r");
  	int N = 0;
  	int M = 0;
	fscanf (file, "%d", &N);    
	fscanf (file, "%d", &M);  
	//crea y llena arreglo de estructuras
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
	printAoS(array,M*N);
	//inicia llamada a kernel de colision, ACA HAY ERROR
	int block_size = 256;
	int grid_size = (int)ceil((float)(N * M) / block_size);
	struct AoS* gpuArray;
	struct AoS* array2 =(struct AoS*) malloc(sizeof(struct AoS)*N*M);
	cudaMalloc(&gpuArray, sizeof(struct AoS)*N*M);
	cudaMemcpy(gpuArray,array,sizeof(struct AoS)*N*M,cudaMemcpyHostToDevice);
	collision_kernel_AoS<<<1,1>>>(gpuArray,M*N);
	cudaDeviceSynchronize();
	//collision_kernel_AoS<<<grid_size,block_size>>>(gpuArray,M*N);
	cudaMemcpy(array2,gpuArray,sizeof(struct AoS)*N*M,cudaMemcpyDeviceToHost);
	cudaFree(gpuArray);
	printAoS(array2,M*N);
	return ;
}
//Imprime estructura de arreglo
void printSoA(struct SoA structure,int size){
	for (int i = 0; i < size; ++i)
	{
		printf("%d ",structure.right[i] );
		printf("%d ",structure.up[i] );
		printf("%d ",structure.left[i] );
		printf("%d\n",structure.down[i] );
	}
}
//imprime masa de sistema de estructura de arreglos
void checkMassSoA(struct SoA structure,int size){
	int sum=0;
	for (int i = 0; i < size; ++i)
	{
		sum+=structure.up[i]+structure.left[i] +structure.right[i] +structure.down[i];
	}
	printf("%d\n",sum );
}
//kernel de colision de estructura de arreglos
__global__ void collision_kernel_SoA(struct SoA structure,int size){
	int myID = threadIdx.x + blockDim.x * blockIdx.x;
	if (myID<size)
	{
		if (structure.up[myID]==1 && structure.down[myID]==1 && structure.right[myID]==0 && structure.left[myID]==0)
		{
			structure.up[myID]=0;
			structure.down[myID]=0;
			structure.left[myID]=1;
			structure.right[myID]=1;
		}
		else if (structure.up[myID]==0 && structure.down[myID]==0 && structure.right[myID]==1 && structure.left[myID]==1)
		{
			structure.up[myID]=1;
			structure.down[myID]=1;
			structure.left[myID]=0;
			structure.right[myID]=0;
		}
	}
}
//Hace todo para estructura de arreglos
void initSoA(){
	FILE* file = fopen ("initial.txt", "r");
  	int N = 0;
  	int M = 0;
  	//Leer archivo
	fscanf (file, "%d", &N);    
	fscanf (file, "%d", &M);  
	//Crea y llena estructura de arreglos
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
	checkMassSoA(structure,M*N);
	//AUN NO EMPIEZO LAS LLAMADAS A LOS KERNEL, PRIMERO HARE EL AOS
	return ;
}

int main()
{
	initAoS();
	return 0;
}