CC    = gcc
FC    = gfortran
FLAGS = -g -Wall -O1

pi: pi.o pthread_interface.o
	$(FC) $(FLAGS) -o $@ $^ -lpthread

pthread_interface.o: pthread_interface.c
	$(CC) $(FLAGS) -c $<

pi.o: pi.f95
	$(FC) $(FLAGS) -c $<

clean:
	rm *.o pi
