PROGRAM PI
    IMPLICIT NONE
    INTEGER :: i, n
    DOUBLE PRECISION :: s = 0

    n = 1000000000

    DO i = 1, n-1
        s = s + SQRT(1-(DBLE(i)/n)*(DBLE(i)/n))
    ENDDO
    s = 4*(s/n + 1/(2*n))
    WRITE (*,"(F12.10)") s

END PROGRAM PI
