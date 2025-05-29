.globl puts
.globl gets
.globl atoi
.text

/*void puts ( const char * str (a0) );*/
   
puts:
    mv t0, a0
loop1:
    lbu t1, 0(t0)
    beq t1, zero, fimputs
    li a0, 1                    # file descriptor = 1 (stdout)
    mv a1, t0
    li a2, 1                    # size - Writes 1 bytes.
    li a7, 64                   # syscall write (64)
    ecall
    addi t0, t0, 1 
    j loop1

fimputs:
    li a0, 1                    # file descriptor = 1 (stdout)
    li a1, 10 
    li a2, 1                    # size - Writes 4 bytes.
    li a7, 64                   # syscall write (64)
    ecall
    ret


/*char * gets ( char * str(a0) )*/
gets:
    mv t0, a0
    li t1, 10

loop2:
    lbu t2, 0(t0)
    beq t2, t1, fimgets
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, t0           # buffer
    li a2, 1            # size - Reads 24 bytes.
    li a7, 63            # syscall read (63)
    ecall
    addi t0, t0, 1
    j loop2

fimgets:
    li a0, 1                    # file descriptor = 1 (stdout)
    li a1, 0 
    li a2, 1                    # size - Writes 4 bytes.
    li a7, 64                   # syscall write (64)
    ecall
    ret

/*int atoi (const char * str);*/
atoi:
    mv t0, a0
loop3:
    lbu a0, 0(t0)
    beq a0, zero, fimatoi
    
fimatoi:
    ret