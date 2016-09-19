PROGRAM MAIN
	USE MATRIXIO
	USE COLIMP
	IMPLICIT NONE
	DOUBLE PRECISION, DIMENSION(100, 100) :: A, A2
	DOUBLE PRECISION, DIMENSION(100) :: b, b2
	DOUBLE PRECISION :: sum_err
	INTEGER, DIMENSION(100) :: p
	CHARACTER(len=*), PARAMETER :: fin  = "sym_01"
	CHARACtER(len=*), PARAMETER :: fout = "out_01"
	INTEGER :: n, stats, j
	
	n = READ_LINSYS_FILE(fin, A, b)

	A2 = A ! Fortran faz deep-copy :-)

!	stats = CHOLCOL(A)
!	IF (stats == -1) THEN
!		PRINT *, "Error: CHOLCOL"
!	ENDIF
!
!	stats = FORWCOL(A, b)
!	IF (stats == -1) THEN
!		PRINT *, "ERROR: FORWCOL"
!	ENDIF
!
!	stats = BACKCOL(A, b, .true.)
!	IF (stats == -1) THEN
!		PRINT *, "ERROR: BACKCOL"
!	ENDIF
!
!	b2 = MATMUL(A2, b)
!
!	PRINT *, b2

	stats = SSCOL(A, p, b)
	b2 = MATMUL(A2, b)

	sum_err = 0

	n = READ_LINSYS_FILE(fin, A, b)


	DO j = 1, n
		PRINT *, ABS(b2(j) - b(j))
	ENDDO
	
	PRINT *, "Soma dos erros: ", sum_err

	!CALL WRITE_LINSYS_FILE(fout, A, b2)
	

END PROGRAM MAIN
