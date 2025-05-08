.globl _start
.bss
input_address: .skip 8
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
    mv a2, a1       # Salvando o conteudo de a1 em a2
    jal leitura1    # t4 valor
    mv a3, t4       # a3 = t4   a3 = cA1 
    jal leitura2    # t5 vlor
    mv a4, t5       # a4 = t5   a4 = cO1
    jal leitura3     # t4 valor
    mv a5, t4        # a5 = t4   a5 = cO2
    jal similaridade # a6 = cA2
    #write------------------------
    li t1, 10 # t0 = 10
    blt a6, t1, um_digito
    div t2, a6, t1  #t2= dezena
    addi t2, t2, 48
    rem a6, a6, t1  #a6 = unidade
    addi a6, a6, 48

    la t0, result
    sb t2, 0(t0)
    sb a6, 1(t0)
    li t1, 10
    sb t1, 2(t0)  # '\n'
    jal write
  
    j exit
um_digito:
    addi a6, a6, 48
    
    la t0, result
    sb a6, 0(t0)
    li t1, 10
    sb t1, 1(t0)  # '\n'
    
    jal write
    j exit

read:
    li a0, 0                # file descriptor = 0 (stdin)
    la a1, input_address    # buffer
    li a2, 8                # size - Reads 6 bytes.
    li a7, 63               # syscall read (63)
    ecall
    ret

write:
    li a0, 1                # file descriptor = 1 (stdout)
    la a1, result           # buffer
    li a2, 3                # size - Writes 4 bytes.
    li a7, 64               # syscall write (64)
    ecall
    ret
leitura1:
    li t0, 32               # ASCII do espaço
    li t1, 0                # índice no buffer
    li t3, 10               # constante 10
    li t4, 0                # acumulador para o primeiro número

while1:
    lb t2, 0(a2)            # lê caractere do buffer
    beq t2, t0, fim1        # if branch equal a (espaço) o loop continua
    addi t2, t2, -48        # subtraçao carteada resgitrador + numero
    mul t4, t4, t3          # multiplica acumulador por 10
    add t4, t4, t2          # soma dígito
    addi a2, a2, 1          # avança para próximo caractere i++
    j while1

fim1:
    # t4 recebe o 1 numero
    addi a2, a2, 1      # avança 1 byte para pular o espaço
    ret

leitura2:
    li t3, 10       # constante 10
    li t5, 0        # acumulador para o segundo número
    li t0, 10       # ASCII do '\n'
while2:
    lb t2, 0(a2)        # lê caractere do buffer
    beq t2, t0, fim2    # if branch equal a (\n) o loop continua
    addi t2, t2, -48    # subtraçao carteada resgitrador + numero
    mul t5, t5, t3      # multiplica acumulador por 10
    add t5, t5, t2      # soma dígito 
    addi a2, a2, 1      # avança para próximo caractere i++
    j while2

fim2:
    addi a2, a2, 1  
    ret

leitura3:
    li t0, 10       # ASCII do '\n'     
    li t3, 10       # constante 10
    li t4, 0        # acumulador para o primeiro número

while3:
    lb t2, 0(a2)        # lê caractere do buffer
    beq t2, t0, fim3    # if branch equal a \n o loop continua
    addi t2, t2, -48    # subtraçao carteada resgitrador + numero
    mul t4, t4, t3      # multiplica acumulador por 10
    add t4, t4, t2      # soma dígito
    addi a2, a2, 1      # avança para próximo caractere i++
    j while3

fim3:
    # t4 recebe o 3 numero
    ret
similaridade:
    mul a6, a3, a5  # CA₂ = (CA₁ × CO₂)
    div a6, a6, a4  # CA₂ = (CA₁ × CO₂) / CO₁
    ret

     

