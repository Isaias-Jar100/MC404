.globl puts
.globl gets
.globl atoi
.globl itoa
.globl exit
.globl linked_list_search

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
    mv a1, t0
    li t0, 10
    sb t0, (a1)
    li a2, 1                    # size - Writes 4 bytes.
    li a7, 64                   # syscall write (64)
    ecall
    ret

/*char * gets ( char * str(a0) )*/
gets:
    mv t1, a0            # t1 = ponteiro para escrita
    mv t6, a0
    li t2, 10            # ASCII '\n'

loop2:
    li a0, 0             # stdin
    mv a1, t1            # endereço de escrita
    li a2, 1             # ler 1 byte
    li a7, 63            # syscall read
    ecall

    lbu t3, 0(t1)        # lê o caractere digitado
    beq t3, t2, fimgets  # se for '\n', termina

    addi t1, t1, 1       # avança ponteiro
    j loop2

fimgets:
    sb zero, 0(t1)       # termina string com '\0'
    mv a0, t6
    ret

/*int atoi (const char * str);*/
atoi:
    mv t0, a0
    li a0, 0
    li t2, 10
    li t3, 1
    lbu t1, 0(t0)
    li t4, 45         # ASCII '-'
    beq t1, t4, sinal
    j loop3

sinal:
    li t3, -1 
    addi t0, t0, 1 

loop3:
    lbu t1, 0(t0)
    beq t1, zero, fimatoi
    addi t1, t1, -48
    mul a0, a0, t2
    add a0, a0, t1
    addi t0, t0, 1
    j loop3
    
fimatoi:
    mul a0, a0, t3
    ret

/*char * itoa ( int value(a0), char * str(a1), int base (a2))*/
itoa:
    mv s0, a1           #ponteiro inicial 
    li t3, 0            # flag para sinal: 0=positivo, 1=negativo
    li t0, 10           # constante 10
    
    beq a2, t0, base10
    j base16
    
base10:
    blt a0, zero, negativo_base10
    j conversor_base10
    
negativo_base10:
    li t3, 1            # marca flag como negativo
    li t1, -1
    mul a0, a0, t1      
    
conversor_base10:
    li t0, 10
    rem t2, a0, t0      
    div a0, a0, t0      
    addi t2, t2, 48     
    sb t2, 0(a1)        # armazena caractere
    addi a1, a1, 1      # avança ponteiro
    bnez a0, conversor_base10 
    
    # negativo se necessário
    beq t3, zero, finalizar_base10
    li t1, 45           # ASCII '-'
    sb t1, 0(a1)
    addi a1, a1, 1
    
finalizar_base10:
    sb zero, 0(a1)     
    j inverter_string
    
base16:
    li t0, 16
    li t1, 10
    
conversor_base16:
    rem t2, a0, t0     
    div a0, a0, t0      
    
    blt t2, t1, digito_0_9
   
    addi t2, t2, 55   
    j armazenar_hex
    
digito_0_9:
    addi t2, t2, 48  
    
armazenar_hex:
    sb t2, 0(a1)        
    addi a1, a1, 1    
    bnez a0, conversor_base16 
    
    sb zero, 0(a1)     
    
inverter_string:
   
    addi t4, a1, -1     # t4 = ponteiro último caractere (antes do '\0')
    mv t3, s0           # t3 = ponteiro primeiro caractere
    
loop_inversao:
    bge t3, t4, fim_inversao  # para quando os ponteiros se encontram
    
    lbu t5, 0(t3)     
    lbu t6, 0(t4)       
    sb t6, 0(t3)        
    sb t5, 0(t4)       
    
    
    addi t3, t3, 1     
    addi t4, t4, -1   
    j loop_inversao
    
fim_inversao:
    mv a0, s0         
    ret

/*int linked_list_search(Node *head_node(a0), int val(a1))*/
linked_list_search:
    addi sp, sp, -16        #Famosa pilha
    sw ra, 12(sp)           
    sw s0, 8(sp)            # ponteiro
    sw s1, 4(sp)            # índice
    
    mv s0, a0               # s0 = ponteiro atual (head_node)
    li s1, 0                # s1 = índice (começa em 0)

loop4:
    beq s0, zero, nao_encontrado 
    
    lw t0, 0(s0)            
    lw t1, 4(s0)            
    add t2, t0, t1          # t2 = soma dos dois valores
    
    beq t2, a1, encontrado  
    
    lw s0, 8(s0)            # s0 = próximo nó (ponteiro para próximo)
    addi s1, s1, 1          # Incrementa índice
    j loop4                 # Volta para o início do loop

nao_encontrado:
    li a0, -1               # Retorna -1
    j fim

encontrado:
    mv a0, s1               # Retorna o índice

fim:
    lw ra, 12(sp)           # Restaura return address
    lw s0, 8(sp)            # Restaura s0
    lw s1, 4(sp)            # Restaura s1
    addi sp, sp, 16         # Desaloca pilha
    ret
/*void exit(int code)*/
exit:
    li a7, 93 # exit
    ecall

