.globl _start

_start:
    jal main

exit:
    li a0, 0
    li a7, 93 # exit
    ecall


main:
    jal read
    lb t0, 9(a1) # byte 1 da entrada ( load + 8 bites da entrada)
    lb t1, 10(a1)    # byte 5 
    addi t0, t0, -48 # subtraçao carteada resgitrador + numero
    addi t1, t1, -48 # subtraçao carteada resgitrador + numero
    li t2, 10
    mul t0, t0, t2  #dezena 
    add t0, t0, t1 # valor x de b  
    
    #x de A-----------------------------
    
    lb t1, 1(a1) # byte 1 da entrada ( load + 0bites da entrada)
    lb t2, 2(a1)    # byte 5 
    addi t1, t1, -48 # subtraçao carteada resgitrador + numero
    addi t2, t2, -48 # subtraçao carteada resgitrador + numero
    li t3, 10
    mul t1, t1, t3  #dezena 
    add t1, t1, t2 # valor x de b  
    
    #---------Cateto 1
    sub t0, t0, t1

    #------ Cateto 2 -------(00 00) (15 00) (00 12)
    lb t1, 20(a1) # byte 1 da entrada ( load + 8 bites da entrada)
    lb t2, 21(a1)    # byte 5 
    addi t1, t1, -48 # subtraçao carteada resgitrador + numero
    addi t2, t2, -48 # subtraçao carteada resgitrador + numero
    li t3, 10
    mul t1, t1, t3  #dezena 
    add t1, t1, t2 # valor x de b  
    #-----------
    
    lb t2, 4(a1) # byte 1 da entrada ( load + 0bites da entrada)
    lb t3, 5(a1)    # byte 5 
    addi t2, t2, -48 # subtraçao carteada resgitrador + numero
    addi t3, t3, -48 # subtraçao carteada resgitrador + numero
    li t4, 10
    mul t2, t2, t4  #dezena 
    add t2, t2, t3 # valor x de b  

    sub t1, t1, t2# cateto 2
    
    jal hipotenusa
    #------------------------
    li t3, 100
    div t4, t2, t3     # t4 = centena
    rem t2, t2, t3

    li t3, 10
    div t5, t2, t3     # t5 = dezena
    rem t2, t2, t3     # t2 = unidade
    
    addi t4, t4, 48    # convertendo de volta pra asccii
    addi t5, t5, 48
    addi t2, t2, 48

    la t0, result
    sb t4, 0(t0)
    sb t5, 1(t0)
    sb t2, 2(t0)
    li t1, 10
    sb t1, 3(t0)  # '\n'

    jal write
   
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
    mul t0, t0, t0     #Eleva o primeiro cateto ao quadrado
    mul t1, t1, t1     #Eleva o segundo cateto ao quadrado
    add t2, t0, t1     #Soma os Quadrados das potencias
    mv  t3, t2         #t3 = t2
    srai t4, t3, 1      # k = y / 2   
    li  t5, 0          # i=0
for:
    li t6, 10          #i<10
    bge t5, t6, fim
    div t6, t3, t4     # y / k
    add t6, t6, t4     # (k + y/k)
    srai t4, t6, 1     # k = (k + y/k) / 2   
    addi t5, t5, 1     #i++
    j for
fim:
    mv t2, t4          #salva em t2
    ret
.bss

input_address: .skip 0x18  # buffer

result: .skip 0x4