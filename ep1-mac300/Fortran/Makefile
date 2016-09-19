FC     = gfortran
FFLAGS = -g -O0

main: matrixio.o colimp.o main.o
	$(FC) $(FFLAGS) -o $@ $^

main.o: main.f95
	$(FC) $(FFLAGS) -c $<

matrixio.o: matrixio.f95
	$(FC) $(FFLAGS) -c $<
	
colimp.o: colimp.f95
	$(FC) $(FFLAGS) -c $<

clean:
	rm -f *.o *.mod main


