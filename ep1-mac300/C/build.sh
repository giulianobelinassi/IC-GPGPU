#!/bin/sh
gcc -Wall -pedantic -ansi -O3 -funroll-loops -march=native -mfpmath=sse -g -o optimized main.c rowimp.c colimp.c matrixio.c -lm
gcc -Wall -pedantic -ansi -g -O0 -o nonoptimized main.c rowimp.c colimp.c matrixio.c -lm
