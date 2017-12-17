G=gfortran
mp=-fopenmp
main.out: TASK.o Tester.o
	$(G) $^ -o $@ $(mp)
Tester.o: Tester.f90
	$(G) -c $< $(mp)
TASK.o: TASK.f90
	$(G) -c $< $(mp)
debug: Homeworkdebug maindebug
	$(G) TASK.o Tester.o -o maintest.out $(mp) -g
Homeworkdebug: TASK.f90
	$(G) -c $< $(mp) -g
maindebug: Tester.f90
	$(G) -c $< $(mp) -g
