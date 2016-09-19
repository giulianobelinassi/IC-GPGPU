#!/bin/sh
gcc -Wall -pedantic -ansi -Ofast -march=native -g -o ../Cfast main.c rowimp.c colimp.c matrixio.c -lm
gcc -Wall -pedantic -ansi -O3 -march=native -g -o ../C3 main.c rowimp.c colimp.c matrixio.c -lm
gcc -Wall -pedantic -ansi -O2 -march=native -g -o ../C2 main.c rowimp.c colimp.c matrixio.c -lm
gcc -Wall -pedantic -ansi -O1 -march=native -g -o ../C1 main.c rowimp.c colimp.c matrixio.c -lm
gcc -Wall -pedantic -ansi -g -O0 -o ../C0 main.c rowimp.c colimp.c matrixio.c -lm
