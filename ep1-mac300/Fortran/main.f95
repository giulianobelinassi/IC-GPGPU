PROGRAM MAIN
	USE MATRIXIO
	USE COLIMP
	IMPLICIT NONE
	DOUBLE PRECISION, ALLOCATABLE, DIMENSION(:,:) :: A
	DOUBLE PRECISION, ALLOCATABLE, DIMENSION(:) :: b
	DOUBLE PRECISION :: sum_err
	INTEGER, ALLOCATABLE,  DIMENSION(:) :: p
	CHARACTER(len=16) :: filestring
!	CHARACtER(len=*), PARAMETER :: fout = "out_01"
	INTEGER :: n, stats, i

	REAL :: ticks, finish


	ALLOCATE(p(n))

	!Cholesky
	DO i = 1, 10
		WRITE (filestring, '(A,I2.2)'), 'symm/symm_', i
		n = READ_LINSYS_FILE(filestring, A, b)
		PRINT *, "Calculando por Colunas: ", filestring
		CALL CPU_TIME(ticks)
		stats = SYMMCOL(A, b)
		IF (stats == -1) THEN
			PRINT *, "Erro. Matriz singular ou não definida positiva"
		ENDIF
		CALL CPU_TIME(finish)
		ticks = finish-ticks
		PRINT *, "Tempo gasto: ", ticks
		DEALLOCATE(A)
		DEALLOCATE(b)
	ENDDO

	PRINT *, "PARTE 2: Eliminação de Gauss"

	!Decomposição LU
	DO i = 1, 10
		WRITE (filestring, '(A,I2.2)'), 'matr/matr_', i
		n = READ_LINSYS_FILE(filestring, A, b)
		ALLOCATE(p(n))
		PRINT *, "Calculando por Colunas: ", filestring
		CALL CPU_TIME(ticks)
		stats = SSCOL(A, p, b)
		IF (stats == -1) THEN
			PRINT *, "Erro. Matriz singular"
		ENDIF
		CALL CPU_TIME(finish)
		ticks = finish-ticks
		PRINT *, "Tempo gasto: ", ticks
		DEALLOCATE(A)
		DEALLOCATE(b)
		DEALLOCATE(p)
	ENDDO



END PROGRAM MAIN
