.globl _start
.bss
input_address: .skip 24
result: .skip 3

.text
_start:
    jal main 

exit:
    li a0, 0
    li a7, 93 # exit
    ecall

main:
    jal read        # chamando a leitura  
    mv a2, a1 
    jal leitura     #numero em t4 sinal em t1
    mv a3, t1       # a3 sinal
    mv a4, t2       # a4 expoente
    jal leitura     #numero em t4 sinal em t1
    mv a5, t1       # a5 sinal 
    mv a6, t2       #a6 expoente
    jal leitura     #t1 sinal t4 expoente
    jal limites


    j exit

read:
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 24             # size - Reads 8 bytes.
    li a7, 63            # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 3            # size - Writes 4 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret

leitura:
    li t0, 10       # ASCII do \n
    li t3, 10       # constante 10
    li t4, 0        # acumulador para o primeiro número
    lb t1, (a2)     #t1 recebe o sinal
    addi a2, a2, 2  # ignorar sinal
    

while1:
    lb t2, (a2)         # lê caractere do buffer
    beq t2, t0, fim1    # if branch equal a (\n) o loop sai
    addi t2, t2, -48    # subtraçao carteada resgitrador + numero
    mul t4, t4, t3      # multiplica acumulador por 10
    add t4, t4, t2      # soma dígito
    addi a2, a2, 1      # avança para próximo caractere i++
    j while1

fim1:
    # t4 recebe o 1 numero
    addi a2, a2, 1      # avança 1 byte para pular o espaço
    ret
limites:
    lb t2, (a2)
