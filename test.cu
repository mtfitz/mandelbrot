#include <stdio.h>

int main()
{
    size_t free, total;
    cudaMemGetInfo(&free, &total);
    printf("%d KiB free, %d KiB total\n", free/1024, total/1024);
    return 0;
}