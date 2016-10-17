PROGRAM MYMATMUL_PROG
    USE MATRIXIO
    USE OMP_LIB
    IMPLICIT NONE
    DOUBLE PRECISION, DIMENSION(:,:), ALLOCATABLE :: A, B, C, D
    DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE :: garbage
    CHARACTER(LEN=16) :: fpath = 'mat_10'
    DOUBLE PRECISION :: TICKS, FINISH
    INTEGER :: n


    !PRINT *, "Lendo matriz do disco..."
    n = READ_LINSYS_FILE(fpath, A, garbage)
    DEALLOCATE(garbage)
 
    PRINT *, "Realizando cópia de A para B..."
    B = A

!    PRINT *, "Multiplicando A por B usando MATMUL..."
!    TICKS = OMP_GET_WTIME()
!    C = MATMUL(A, B)
!    FINISH = OMP_GET_WTIME()
!    TICKS = FINISH - TICKS
!	PRINT *, "Tempo gasto FORTRAN_MATMUL: ", ticks


    PRINT *, "Multiplicando A por B usando MYMATMUL..."
    TICKS = OMP_GET_WTIME()
    D = MYMATMUL2(A, B)
    FINISH = OMP_GET_WTIME()
    TICKS = FINISH - TICKS
    PRINT *, "Tempo gasto MYMATMUL: ", ticks

    !WRITE (*, '(A, F8.5)'), "Tempo gasto: ", ticks
    
    IF (COMPARE_MAT(C, D) .eqv. .FALSE.) THEN
        PRINT *, "Muitos Erros"
    ELSE
        PRINT *, "Tá certo"
    ENDIF

    DEALLOCATE(A)
    !DEALLOCATE(C)
	DEALLOCATE(D)

    CONTAINS
 
    FUNCTION MYMATMUL2(A, B) RESULT(C)
        IMPLICIT NONE
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(IN) :: A, B
        INTEGER :: m, n, p
        INTEGER :: i, j, k
		INTEGER :: windm, windn, windp
		INTEGER :: windi_low, windj_low, windk_low, windi_high, windj_high, windk_high
        DOUBLE PRECISION, DIMENSION(:,:), ALLOCATABLE :: C

        m = SIZE(A, 1)
        n = SIZE(A, 2)
        p = SIZE(B, 2)

        IF (SIZE(B, 1) /= n) THEN
            RETURN
        ENDIF

        ALLOCATE (C(m, p))
        C = 0

		windn = n/2
		windm = m/2
		windp = p/2

		!OMP PARALLEL DO COLLAPSE(3) PRIVATE(windi_low, windi_high, windj_low, windj_high, windk_low, windk_high)
        DO k = 1, MODULO(p, 2)
            DO j = 1, MODULO(n, 2)
                DO i = 1, MODULO(m, 2)
                    windi_low  = (i-1)*windm + 1
					windj_low  = (j-1)*windn + 1
					windk_low  = (k-1)*windp + 1
					windi_high = i*windm
					windj_high = j*windn
					windk_high = k*windp
					C(windi_low:windi_high, windk_low:windk_high) = C(windi_low:windi_high, windk_low:windk_high) + & 
					MATMUL(A(windi_low:windi_high, windj_low:windj_high), B(windj_low:windj_high, windk_low:windk_high))
				ENDDO
			ENDDO
		ENDDO
		!OMP END PARALLEL DO
    END FUNCTION MYMATMUL2
    

	FUNCTION MYMATMUL(A, B) RESULT(C)
        IMPLICIT NONE
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(IN) :: A, B
        INTEGER :: m, n, p
        INTEGER :: i, j, k
        DOUBLE PRECISION, DIMENSION(:,:), ALLOCATABLE :: C

        m = SIZE(A, 1)
        n = SIZE(A, 2)
        p = SIZE(B, 2)

        IF (SIZE(B, 1) /= n) THEN
            RETURN
        ENDIF

        ALLOCATE (C(m, p))
        C = 0

        !$OMP PARALLEL DO
        DO k = 1, p
            C(1:m, k) = MATMUL(A, B(1:n, k)) 
        ENDDO
        !$OMP END PARALLEL DO
     END FUNCTION MYMATMUL

!    FUNCTION MYMATMUL(A, B) RESULT(C)
!        IMPLICIT NONE
!        DOUBLE PRECISION, DIMENSION(:,:), INTENT(IN) :: A, B
!        INTEGER :: m, n, p
!        INTEGER :: i, j, k
!        DOUBLE PRECISION, DIMENSION(:,:), ALLOCATABLE :: C
!
!        m = SIZE(A, 1)
!        n = SIZE(A, 2)
!        p = SIZE(B, 2)
!
!        IF (SIZE(B, 1) /= n) THEN
!            RETURN
!        ENDIF
!
!        ALLOCATE (C(m, p))
!        C = 0
!
!        DO k = 1, p
!            DO j = 1, n
!                DO i = 1, m
!                    C(i, k) = C(i, k) + A(i, j)*B(j, k)
!                ENDDO
!            ENDDO
!        ENDDO
!    END FUNCTION MYMATMUL

    LOGICAL FUNCTION COMPARE_MAT(A, B)
        IMPLICIT NONE
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(IN) :: A, B
        DOUBLE PRECISION :: eps = 10E-10
        INTEGER :: m, n, i, j
    
        m = SIZE(A, 1)
        n = SIZE(A, 2)

        DO j = 1, n
            DO i = 1, m
                IF (ABS(A(i, j) - B(i, j)) > eps) THEN
                    COMPARE_MAT = .FALSE.
                    RETURN
                ENDIF
            ENDDO
        ENDDO
        COMPARE_MAT = .TRUE.
    END FUNCTION COMPARE_MAT

END PROGRAM MYMATMUL_PROG
