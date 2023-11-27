#include <iostream>
#include "libbmp/CPP/libbmp.h"

#define NUM_ITER 1000
#define GRID_RES 0.001
#define GRID_DIM ((int) (4 / GRID_RES) + 1)

__device__ int solve(float x, float y)
{
    float z_a = 0, z_b = 0;
    for (int i = 0; i < NUM_ITER; i++) {
	if (z_a * z_a + z_b * z_b > 4) {
	    int val = (int) (255 * ((float) i / 16));
	    return (val > 255) ? 255 : val;
	}

	float w_a = (z_a*z_a - z_b*z_b) + x;
	float w_b = 2 * z_a * z_b + y;
	z_a = w_a;
	z_b = w_b;
    }

    return 0;
}

__global__ void mandelbrot(int* grid, int n, float res)
{    
    int origin = n / 2;
    //float res2 = res / 2;
    int stride = blockDim.x;
    for (int row = threadIdx.x; row < n; row += stride) {
	float y = (row - origin) * res;
	for (int col = 0; col < n; col++) {
	    float x = (col - origin) * res;
	    //printf("(x=%f,y=%f)\n", x, y);
	    grid[row*n+col] = solve(x,y);
	}
    }
}

int main()
{
    int* grid = (int*) malloc(GRID_DIM * GRID_DIM * sizeof(int));
    int* grid_dev;
    if (cudaMalloc(&grid_dev, GRID_DIM*GRID_DIM*sizeof(int)) != cudaSuccess) {
	printf("Could not allocate enough memory\n");
	return 1;
    }
    mandelbrot<<<1, 256>>>(grid_dev, GRID_DIM, GRID_RES);
    cudaMemcpy(grid, grid_dev, GRID_DIM*GRID_DIM*sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(grid_dev);

    BmpImg img(GRID_DIM, GRID_DIM);
    //bmp_img_init_df(&img, GRID_DIM, GRID_DIM);
    for (int i = 0; i < GRID_DIM; i++) {
	for (int j = 0; j < GRID_DIM; j++) {
	    int val = grid[i*GRID_DIM+j];
	    img.set_pixel(j, i, 0, 0, val);
	    //printf("(%d,%d): %d\n", i, j, (&grid[i])[j]);
//img.set_pixel(j, i, 255, 255, 255);
	}
    }
    //bmp_img_write(&img, "mandelbrot.bmp");
    //bmp_img_free(&img);
    img.write("test.bmp");
    free(grid);
    return 0;
}