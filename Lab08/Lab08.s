# Leitura de imagem .pgm, extração do cabeçalho e redimensionamento dinâmico do Canvas

.data
input_file:     .asciz "image.pgm"

.bss
input_address:   .space 4109       # Espaço para os pixels (64x64)
bits 
.text
.globl _start

_start:
    jal main

exit:
    li a0, 0
    li a7, 93     # syscall exit
    ecall

main:
    jal open
    jal read
    la a0, input_address
    addi a0, a0, 13
    
    
    j exit


open:
    la a0, input_file
    li a1, 0       # leitura
    li a2, 0
    li a7, 1024    # syscall open
    ecall
    ret


read:        
    la a1, input_address # buffer
    li a2, 4109            # size - Reads 24 bytes.
    li a7, 63            # syscall read (63)
    ecall
    ret
