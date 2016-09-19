MODULE COLIMP
	IMPLICIT NONE
	CONTAINS
	INTEGER FUNCTION BACKCOL(A, b, trans)
		IMPLICIT NONE
		DOUBLE PRECISION, DIMENSION(:,:), INTENT(IN) :: A
		DOUBLE PRECISION, DIMENSION(:), INTENT(OUT) :: b
		LOGICAL, INTENT(IN) :: trans

		INTEGER :: j, n
		n = SIZE(A, 2)

		IF (trans) THEN
			DO j = n, 1, -1
				b(j) = b(j) - DOT_PRODUCT(A(j+1:n, j), b(j+1:n))
		
				IF (A(j, j) == 0) THEN
					BACKCOL = -1
					RETURN
				ENDIF

				b(j) = b(j)/A(j, j)

			ENDDO

		ELSE	
			DO j = n, 1, -1
				IF (A(j, j) == 0) THEN
					BACKCOL = -1
					RETURN
				ENDIF

				b(j) = b(j)/A(j, j)

				b(1:j-1) = b(1:j-1) - A(1:j-1, j)*b(j)
			ENDDO
		ENDIF
		BACKCOL = 0
	END FUNCTION BACKCOL

	INTEGER FUNCTION FORWCOL(A, b)
		IMPLICIT NONE
		DOUBLE PRECISION, DIMENSION(:,:), INTENT(IN) :: A
		DOUBLE PRECISION, DIMENSION(:), INTENT(OUT) :: b
		INTEGER :: j, n

		n = SIZE(A,2)

		DO j = 1, n
			IF (A(j, j) == 0) THEN
				FORWCOL = -1
				RETURN
			ENDIF
			
			b(j) = b(j)/A(j, j)
			b(j+1:n) = b(j+1:n) - A(j+1:n, j)*b(j)
		ENDDO
		FORWCOL = 0
	END FUNCTION FORWCOL

	INTEGER FUNCTION CHOLCOL(A)
		IMPLICIT NONE
		DOUBLE PRECISION, DIMENSION(:,:), INTENT(OUT) :: A
		INTEGER :: i, j, k, n

		n = SIZE(A, 2)

		DO j = 1, n
			DO k =1, j-1
				A(j:n, j) = A(j:n, j) - A(j:n, k)*A(j, k)
			ENDDO

			IF (A(j, j) <= 0) THEN
				CHOLCOL = -1
			ENDIF

			A(j, j) = SQRT(A(j, j))

			A(j+1:n, j) = A(j+1:n, j)/A(j, j)
		ENDDO
	END FUNCTION CHOLCOL

	INTEGER FUNCTION SYMMCOL(A, b)
		DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT) :: A
		DOUBLE PRECISION, DIMENSION(:), INTENT(INOUT)   :: b
		INTEGER :: stats

		stats = CHOLCOL(A)
		IF (stats == -1) THEN
			SYMMCOL = -1
			RETURN
		ENDIF

		stats = forwcol(A, b)
		IF (stats == -1) THEN
			SYMMCOL = -1
			RETURN
		ENDIF

		stats = backcol(A, b, .TRUE.)
		IF (stats == -1) THEN
			SYMMCOL = -1
			RETURN
		ENDIF
		SYMMCOL = 0
	END FUNCTION SYMMCOL

	INTEGER FUNCTION LUCOL(A, p)
		DOUBLE PRECISION, DIMENSION(:,:), INTENT(OUT) :: A
		INTEGER, DIMENSION(:), INTENT(OUT) :: p
		DOUBLE PRECISION :: temp
		INTEGER :: i, j, k, n, imax
		n = SIZE(A,2)


		DO k = 1, n-1
			imax = k
			DO i = k+1, n
				IF (ABS(A(i, k)) > ABS(A(imax, k))) THEN
					imax = i
				ENDIF
			p(k) = imax

			IF (imax /= k) THEN
				DO j = 1, n
					temp      = A(k, j)
					A(k, j)   = A(imax, j)
					A(imax, j)= temp
				ENDDO
			ENDIF
			
			IF (A(k, k) == 0) THEN
				LUCOL = -1
				RETURN
			ENDIF

			A(k+1:n, k) = A(k+1:n, k)/A(k, k)
			DO j = k+1, n
				A(k+1:n, j) = A(k+1:n, j) - A(k, j)*A(k+1:n, k)
			ENDDO

			ENDDO
		ENDDO
		IF (A(k, k) == 0) THEN
			LUCOL = -1
		ELSE
			LUCOL = 0
		ENDIF
	END FUNCTION LUCOL


	INTEGER FUNCTION SSCOL(A, p, b)
		DOUBLE PRECISION, DIMENSION(:,:), INTENT(INOUT) :: A
		DOUBLE PRECISION, DIMENSION(:), INTENT(OUT) :: b
		INTEGER, DIMENSION(:), INTENT(OUT) :: p
		
		DOUBLE PRECISION :: temp
		INTEGER :: j, res, n
		n = SIZE(A, 2)

		res = LUCOL(A, p)
		IF (res == -1) THEN
			SSCOL = -1
			RETURN
		ENDIF

		DO j = 1, n-1
			temp    = b(j)
			b(j)    = b(p(j))
			b(p(j)) = temp
		ENDDO

		DO j = 1, n
			b(j+1:n) = A(j+1:n, j)*b(j)
		ENDDO

		SSCOL = BACKCOL(A, b, .FALSE.)
	END FUNCTION SSCOL
END MODULE COLIMP


!PROGRAM TEST
!	USE COLIMP
!	IMPLICIT NONE
!	DOUBLE PRECISION, DIMENSION(3,3) :: A
!	DOUBLE PRECISION, DIMENSION(3) :: b
!	DOUBLE PRECISION, DIMENSION(3) :: p
!
!	INTEGER res
!
!	A = TRANSPOSE(RESHAPE((/ 2, 1,  1, &
!				             2, 2, -1, &
!						     4,-1,  6/), SHAPE(A)))
!	res = LUCOL(A, p)
!
!	PRINT *, A
!
!END PROGRAM TEST
