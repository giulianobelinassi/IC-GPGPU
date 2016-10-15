
MODULE MATRIXIO
	IMPLICIT NONE
	CONTAINS
	INTEGER FUNCTION READ_LINSYS_FILE(fpath, A, b) RESULT(n)
		IMPLICIT NONE

		DOUBLE PRECISION, ALLOCATABLE, INTENT(OUT) :: A(:,:), b(:)
		CHARACTER(LEN=*), INTENT(IN) :: fpath
		
		INTEGER :: fd
		INTEGER :: i, j, k
		INTEGER :: iostats
		INTEGER :: garbage

		OPEN (fd, FILE=fpath)
		READ (fd, *, IOSTAT=iostats) n

		ALLOCATE (A(n, n))
		ALLOCATE (b(n))

		DO i = 1, n
			DO j = 1, n
				READ (fd, "(I5, 1X, I5, 1X, ES29.22E2)", IOSTAT=iostats) garbage, garbage, A(i, j)
			ENDDO
		ENDDO

		DO i = 1, n
			READ(fd, "(I5, 1X, ES29.22E2)", IOSTAT=iostats), garbage, b(i)
		ENDDO

		IF (iostats > 0) THEN
			n = 0
		ENDIF
		CLOSE (fd)
	END FUNCTION READ_LINSYS_FILE

	SUBROUTINE WRITE_LINSYS_FILE(fpath, A, b)
		IMPLICIT NONE
		CHARACTER(len=*), INTENT(IN) :: fpath
		DOUBLE PRECISION, INTENT(IN) :: A(:,:), b(:)
		INTEGER :: n, i, j, fd, iostats
		
		n = SIZE(A, 2)
		
		OPEN (fd, FILE=fpath)

		WRITE (fd, "(I5)") n
		DO i = 1, n
			DO j = 1, n
				WRITE (fd, "(I5, 1X, I5, 1X, ES32.24E3)", IOSTAT=iostats) i, j, A(i, j)
			ENDDO
		ENDDO
		
		DO i = 1, n
			WRITE (fd, "(I5, 1X, ES32.24E3)", IOSTAT=iostats) i, b(i)
		ENDDO	
		CLOSE (fd)
	END SUBROUTINE

END MODULE MATRIXIO
