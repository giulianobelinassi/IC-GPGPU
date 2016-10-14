PROGRAM MYMATMUL_PROG
    USE MATRIXIO
    IMPLICIT NONE
    DOUBLE PRECISION, DIMENSION(:,:), ALLOCATABLE :: A, B, C, D
    DOUBLE PRECISION, DIMENSION(:), ALLOCATABLE :: garbage
    CHARACTER(LEN=6) :: fpath = "mat_10"
    REAL :: TICKS, FINISH
    INTEGER :: n

    n = READ_LINSYS_FILE(fpath, A, garbage)
    DEALLOCATE(garbage)
    B = A

    CALL CPU_TIME(TICKS)
    C = MYMATMUL(A, B)
    CALL CPU_TIME(FINISH)
    TICKS = FINISH - TICKS
    WRITE (*, '(A, F8.5)'), "Tempo gasto: ", ticks

    CALL CPU_TIME(TICKS)
    D = MATMUL(A, B)
    CALL CPU_TIME(FINISH)
    TICKS = FINISH - TICKS
    WRITE (*, '(A, F8.5)'), "Tempo gasto: ", ticks
    
    IF (COMPARE_MAT(C, D) .eqv. .FALSE.) THEN
        PRINT *, "Muitos Erros"
    ELSE
        PRINT *, "Tá certo"
    ENDIF

    DEALLOCATE(A)
    DEALLOCATE(C)

    CONTAINS
 
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
