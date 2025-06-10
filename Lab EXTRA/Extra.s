.globl _start
.bss
1_entrada: .skip 6000 
jason: .skip 6000  # buffer
vetor: .skip 6000
result: .skip 0x4
.text
_start:
    jal main

exit:
    li a0, 0
    li a7, 93 # exit
    ecall
main:
    la a0, 1_entrada
    jal gets
    mv a1, a0
    la a0, jason
    jal gets
    mv a2, a0
    la a0, vetor
    jal gets 
    mv a3, a0
    /*a1- entrada
    a2- jason
    a3- vetor*/
    





    j exit

negativo:
    li a0, 0
    ret
relu:
    blt a0, zero, negativo
    ret

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
