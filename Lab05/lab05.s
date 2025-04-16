.globl _start

_start:
    jal main

exit:
    li a0, 0
    li a7, 93 # exit
    ecall


main:
    jal read
    lb t0, 8(a1) # byte 1 da entrada ( load + 8 bites da entrada)
    lb t1, 9(a1)    # byte 5 
    addi t0, t0, -48 # subtraçao carteada resgitrador + numero
    addi t1, t1, -48 # subtraçao carteada resgitrador + numero
    li t2, 10
    mul t0, t0, t2  #dezenha 
    add t0, t0, t1 # valor x de b

   
   
   j exit


read:
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 24            # size - Reads 24 bytes.
    li a7, 63            # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 4            # size - Writes 4 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret

hipotenusa:
    li t5, 10
    li t4, 0

edf:
    addi t5, t5, 1
    beq t5, t4,  fim
    j edf


fim:

    ret
.bss

input_address: .skip 0x18  # buffer

result: .skip 0x4