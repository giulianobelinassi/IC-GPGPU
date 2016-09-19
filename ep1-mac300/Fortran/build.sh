gfortran -Ofast -march=native -g -o ../Ffast colimp.f95 matrixio.f95 main.f95
gfortran -O4 -march=native -g -o ../F4 colimp.f95 matrixio.f95 main.f95
gfortran -O3 -march=native -g -o ../F3 colimp.f95 matrixio.f95 main.f95
gfortran -O2 -march=native -g -o ../F2 colimp.f95 matrixio.f95 main.f95
gfortran -O1 -march=native -g -o ../F1 colimp.f95 matrixio.f95 main.f95
gfortran -O0 -march=native -g -o ../F0 colimp.f95 matrixio.f95 main.f95
