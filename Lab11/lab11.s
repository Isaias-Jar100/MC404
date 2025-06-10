.globl _start
.bss
.text
_start:
    li t0, 3100 
inicio:
    li a0, 0xFFFF0120
    li a1, 127
    sb a1, (a0)
    li a0, 0xFFFF0121 
    li a1, 1
    sb a1, (a0)
    addi t0, t0, -1
    bne t0, zero, inicio



0:
    li a0, 0xFFFF0120
    li a1, 0
    sb a1, (a0)
    li a0, 0xFFFF0121 
    li a1, 1
    sb a1, (a0)

1:
    beqz zero, 1b


exit:
    li a0, 0
    li a7, 93 # exit
    ecall