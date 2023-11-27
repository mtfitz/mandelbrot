# Mandelbrot Set Generator for CUDA

This is a simple demonstration of NVIDIA CUDA for GPU compute. This program generates an image of a 
Mandelbrot set, where both axes span the interval `[-2,2]`. There are configurable constants in the 
source.

## Building

Run the provided script `build.sh`. Ensure the latest CUDA toolchain including `nvcc` is installed. You 
will also need to install the Git submodule for `libbmp`.

## Using

On any NVIDIA GPU-equipped system, run the resulting `a.out` program. It will generate a bitmap file 
`test.bmp` containing the Mandelbrot set image. Note that some glitches may occur at sufficiently high 
resolutions, and some programs may be unable to read such large bitmap files.

## Configuring

The following constants are configurable in the main source `mand.cu`:

* `NUM_ITER` controls the number of iterations used for the convergence/divergence check.
* `GRID_RES` controls the grid resolution and increments. For example, if the resolution is `0.01`, then 
moving one pixel to the right means moving 0.01 grid units to the right.
* Do NOT touch `GRID_DIM` as it is simply a re-expression of `GRID_RES`.
