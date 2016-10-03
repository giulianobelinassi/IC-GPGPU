PROGRAM PI
    USE ISO_C_BINDING
    IMPLICIT NONE
    INTEGER :: i, n
    DOUBLE PRECISION :: resp, s
    INTEGER, DIMENSION (2) :: sumrange = (/1, 100000000/)
    INTEGER, VOLATILE :: thread, attr
    
    s = 0
    resp = 0
    n = sumrange(2)
    
    CALL pthread_attr_init(attr)
    CALL pthread_create(thread, attr, PI_THREAD, sumrange)
    CALL pthread_join(thread)
    CALL pthread_attr_destroy(attr)

    resp = s

    resp = 4*(resp/n + 1/(2*n))
    WRITE (*,"(F12.10)") resp
    STOP 0

    CONTAINS
    SUBROUTINE PI_THREAD(sumrange)
        IMPLICIT NONE
        INTEGER, DIMENSION (2), INTENT(IN) :: sumrange
!       DOUBLE PRECISION :: s = 0

        DO i = sumrange(1), sumrange(2)
            s = s + SQRT(1-(DBLE(i)/n)*(DBLE(i)/n))
        ENDDO
        PRINT *, s

    END SUBROUTINE PI_THREAD

!	INTERFACE
!		SUBROUTINE pthread_join(thread) BIND (C)
!			USE ISO_C_BINDING
!			IMPLICIT NONE
!			INTEGER(C_PTR) :: thread
!		END SUBROUTINE pthread_join
!	END INTERFACE
END PROGRAM PI
