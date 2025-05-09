.globl _start
.bss
input_address: .skip 24
result: .skip 12

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
    jal leitura     # numero em t4 sinal em t1
    mv a3, t1       # a3 sinal
    mv a4, t4       # a4 expoente
    jal leitura     # numero em t4 sinal em t1
    mv a5, t1       # a5 sinal 
    mv a6, t4       # a6 expoente
    jal leitura     # t1 sinal t4 expoente
    jal limites1    # t5 recebe limite inferior
    jal limites2    # t6 recebe limite superior
    jal integral    # a4 recebe primeiro termo  #a3,a4,a5,a6,t1,t4,t5,t6
    jal integral2   # a6 recebe segundo termo 
    jal integral3   # t4 recebe terceiro termo
    jal operacoes   # resultado em a6

    #write------------------------
    mv t0, a6           # t0 será usado para manipular o número
    la t1, result       # ponteiro para o buffer
    addi t1, t1, 11     # aponta para o fim do buffer
    li a7, 10
    sb a7, 0(t1)
    li t2, 1            # contador de dígitos

convert_loop:
    li t4, 10
    rem t3, t0, t4     # t3 = t0 % 10
    addi t3, t3, 48     # converte para ASCII ('0' = 48)
    addi t1, t1, -1     # anda uma posição pra trás
    sb t3, 0(t1)        # armazena caractere
    div t0, t0, t4     # t0 = t0 / 10
    addi t2, t2, 1      # conta o dígito
    bnez t0, convert_loop
    
    jal write

    j exit
    
read:
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 24            # size - Reads 8 bytes.
    li a7, 63            # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    addi a1, a1, 11
    sub a1, a1, t2
    li a2, 12            # size - Writes 4 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret

leitura:
    li t0, 10       # ASCII do \n
    li t3, 10       # constante 10
    li t4, 0        # acumulador para o primeiro número
    lb t1, (a2)     # t1 recebe o sinal
    addi a2, a2, 2  # ignorar sinal
    
while:
    lb t2, (a2)         # lê caractere do buffer
    beq t2, t0, fim    # if branch equal a (\n) o loop sai
    addi t2, t2, -48    # subtraçao carteada resgitrador + numero
    mul t4, t4, t3      # multiplica acumulador por 10
    add t4, t4, t2      # soma dígito
    addi a2, a2, 1      # avança para próximo caractere i++
    j while

fim:
    # t4 recebe o 1 numero
    addi a2, a2, 1      # avança 1 byte para pular o espaço
    ret

limites1:
    li t0, 32          # ASCII do espaço
    li t3, 10          # constante 10
    li t5, 0           # acumulador do numero

while1: 
    lb t2, (a2)         # lê caractere do buffer
    beq t2, t0, fim1    # if branch equal a espaço o loop sai
    addi t2, t2, -48    # subtraçao carteada resgitrador + numero
    mul t5, t5, t3      # multiplica acumulador por 10
    add t5, t5, t2      # soma dígito
    addi a2, a2, 1      # avança para próximo caractere i++
    j while1

fim1:
    # t5 recebe o 1 numero
    addi a2, a2, 1      # avança 1 byte para pular o espaço
    ret


limites2:
    li t0, 10          # ASCII do \n
    li t3, 10          # constante 10
    li t6, 0           # acumulador do numero

while2: 
    lb t2, (a2)         # lê caractere do buffer
    beq t2, t0, fim2    # if branch equal a \n o loop sai
    addi t2, t2, -48    # subtraçao carteada resgitrador + numero
    mul t6, t6, t3      # multiplica acumulador por 10
    add t6, t6, t2      # soma dígito
    addi a2, a2, 1      # avança para próximo caractere i++
    j while2

fim2:
    ret

integral:
#a3,a4,a5,a6,t1,t4,t5,t6
    addi a4, a4, 1     # expoente +1
    li t0, 1 
    mv t3, t5          # t7 = limite inferior
    mv t2, t6          # t8 = limite superior

exponenciacao:
    beq t0, a4, fimint
    mul t3, t3, t5     # t7 = t7 * limite inferior
    mul t2, t2, t6     # t8 = t8 * limite superior
    addi t0, t0, 1
    j exponenciacao

fimint:
    div t3, t3, a4     # t7 = t5^(n+1)/n+1
    div t2, t2, a4     # t8 = t6^(n+1)/n+1
    sub a4, t2, t3     # resultado da integral

    li t0, 45          # ASCII do '-'
    beq a3, t0, neg1   # se for negativo, aplica sinal
    j continue1

neg1:
    li a2, -1
    mul a4, a4, a2    # aplica o sinal negativo

continue1:
    ret

integral2:
    #,a4,a5,a6,t1,t4,t5,t6
    addi a6, a6, 1 # expoente +1
    li t0, 1
    mv t3, t5
    mv t2, t6

exponenciacao2:
    beq t0, a6, fimint2
    mul t3, t3, t5
    mul t2, t2, t6
    addi t0, t0, 1
    j exponenciacao2

fimint2:
    div t3, t3, a6
    div t2, t2, a6
    sub a6, t2, t3
    
    li t0, 45          # ASCII do '-'
    beq a5, t0, neg2   # se for negativo, aplica sinal
    j continue2

neg2:

    li a2, -1
    mul a6, a6, a2    # aplica o sinal negativo

continue2:
    ret
    
integral3:
#a4,a6,t1,t4,t5,t6
    addi t4, t4, 1 # expoente +1
    li t0, 1 
    mv t3, t5
    mv t2, t6

exponenciacao3:
    beq t0, t4, fimint3
    mul t3, t3, t5
    mul t2, t2, t6
    addi t0, t0, 1
    j exponenciacao3

fimint3:
    div t3, t3, t4
    div t2, t2, t4
    sub t4, t2, t3
    
    li t0, 45          # ASCII do '-'
    beq t1, t0, neg3  # se for negativo, aplica sinal
    j continue3

neg3:

    li a2, -1
    mul t4, t4, a2     # aplica o sinal negativo

continue3:
    #a4,a6,t4
    ret

operacoes:
    #usados até então: a4,a6,t4
    add a6, a6, a4
    add a6, a6, t4
    ret

