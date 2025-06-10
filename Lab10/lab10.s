.globl puts
.globl gets
.globl atoi
.globl itoa
.globl exit
.globl fibonacci_recursive
.globl fatorial_recursive
.globl torre_de_hanoi

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


/*int fibonacci_recursive(int num)  */
#int num(a0)
fibonacci_recursive:
    addi sp, sp, -16
    sw ra, 12(sp)          # return endereço
    sw s1, 8(sp)           # valor de n
    sw s2, 4(sp)           # salvar registrador que guardará fib(n-1)
    sw s0, 0(sp)           # Frame pointer 
    addi s0, sp, 16           # s0 = novo endereço do frame pointer

    mv s1, a0  #s1= n

caso_base:
    li t0, 1
    ble s1, t0, fim_caso_base
    addi a0, s1, -1
    jal ra, fibonacci_recursive
    mv s2, a0            # s2 = fib(n-1)
    addi a0, s1, -2
    jal ra, fibonacci_recursive
    add a0, s2, a0
    j finalizar
    
fim_caso_base:
    beqz s1, retorna_zero
    li a0, 1  
    j finalizar
    
retorna_zero:
    li a0, 0 
    
finalizar:
    lw s0, 0(sp)
    lw s2, 4(sp)         
    lw s1, 8(sp)        
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

/*int fatorial_recursive(int num)*/
fatorial_recursive:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)
    addi s0, sp, 16

    mv s1, a0 #s1=n
    
    li t0, 1
    ble s1, t0, fim_fatorial_base
    addi a0, s1, -1
    jal ra, fatorial_recursive
    mv s2, a0           #s2 n-1
    mv a0, s1           #s1 n
    mul a0, a0, s2
    j finalizar_fatorial


fim_fatorial_base:
    li a0, 1
    
finalizar_fatorial:
    lw s2,  0(sp)
    lw s1,  4(sp)
    lw s0,  8(sp)
    lw ra,  12(sp)
    addi sp,  sp, 16
    ret


/*void torre_de_hanoi(int num, char de, char auxiliar, char ate, char* str)*/
# a0= n , a1= torre Inicio a2= torre auxiliar, a3= torre fim, a4= 
torre_de_hanoi:
    addi sp, sp, -80    
    sw ra, 76(sp)
    sw s0, 72(sp)
    sw s1, 68(sp) # s1 = num
    sw s2, 64(sp) # s2 = TOrre inicio
    sw s3, 60(sp) # s3 =  aTOrre auxiliar
    sw s4, 56(sp)  # s4 = torre fim
    sw s5, 52(sp)           # s5 = string 
    sw s6, 48(sp)           # s6 = buffer local
    addi s0, sp, 80
    
    mv s1, a0               
    mv s2, a1              
    mv s3, a2               
    mv s4, a3              
    mv s5, a4              
    
    addi s6, sp, 0          # s6 aponta para o buffer 
    
    mv t0, s5              
    mv t1, s6               
copy_loop:
    lb t3, 0(t0)
    sb t3, 0(t1)
    beqz t3, copy_done 
    addi t0, t0, 1
    addi t1, t1, 1
    addi t2, t2, -1
    bnez t2, copy_loop
copy_done:
    
    li t0, 1
    beq s1, t0, fim_hanoi_base
    
    addi a0, s1, -1
    mv a1, s2
    mv a2, s4
    mv a3, s3
    mv a4, s5           
    jal ra, torre_de_hanoi

    addi t1, s1, '0'
    sb t1, 12(s6)          
    sb s2, 23(s6)
    sb s4, 38(s6)
    mv a0, s6               
    jal ra, puts

    addi a0, s1, -1
    mv a1, s3
    mv a2, s2
    mv a3, s4
    mv a4, s5          
    jal ra, torre_de_hanoi
    
    j finalizar_hanoi

fim_hanoi_base:
    li t1, '1'
    sb t1, 12(s6)           
    sb s2, 23(s6)
    sb s4, 38(s6)
    mv a0, s6       
    jal ra, puts

finalizar_hanoi:
    lw s6, 48(sp)
    lw s5, 52(sp)
    lw s4, 56(sp)
    lw s3, 60(sp)
    lw s2, 64(sp)
    lw s1, 68(sp)
    lw s0, 72(sp)
    lw ra, 76(sp)
    addi sp, sp, 80
    ret

/*void exit(int code)*/
exit:
    li a7, 93 # exit
    ecall

