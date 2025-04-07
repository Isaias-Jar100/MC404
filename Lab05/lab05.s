.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall


main:
   jal read



   
   
   ret


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



    ret
.bss

input_address: .skip 0x18  # buffer

result: .skip 0x4