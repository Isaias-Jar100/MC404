.globl _start
.bss
# Correção no .bss
arquitetura_str: .skip 40    # Buffer para a string da arquitetura (ex: "4,8,15,3")
json_str:        .skip 6000  # Buffer para a string JSON
input_vec_str:   .skip 40    # Buffer para a string do vetor de entrada (ex: "59,30,51,18")
.text
_start:
    jal main

exit:
    li a0, 0
    li a7, 93 # exit
    ecall
main:
    # Salva o registrador de retorno no stack
    addi sp, sp, -20
    sw ra, 0(sp)        # Salva o endereço de retorno
    sw s0, 4(sp)        # s0: ponteiro para a string da arquitetura
    sw s1, 8(sp)        # s1: ponteiro para a string do JSON
    sw s2, 12(sp)       # s2: ponteiro para a string do vetor de entrada
    sw s3, 16(sp)       # s3: vai guardar o número de camadas

    # --- Passo 1: Ler as 3 linhas da entrada ---
    # Ler a string da arquitetura
    la s0, arquitetura_str
    mv a0, s0
    jal ra, gets

    # Ler a string JSON
    la s1, json_str
    mv a0, s1
    jal ra, gets

    # Ler a string do vetor de entrada
    la s2, input_vec_str
    mv a0, s2
    jal ra, gets

    # --- Passo 2: Fazer o parse dos dados lidos ---
    # Parse da arquitetura
    mv a0, s0                   # a0 = ponteiro para a string "4,8,15,3"
    la a1, arquitetura_array    # a1 = ponteiro para onde guardar os ints
    jal ra, parse_csv_integers
    mv s3, v0                   # Salva o número de camadas retornado por v0 em s3

    # Parse do vetor de entrada
    mv a0, s2                   # a0 = ponteiro para a string "59,30,51,18"
    la a1, input_vector_array   # a1 = ponteiro para onde guardar os ints
    jal ra, parse_csv_integers
    
    # Parse dos pesos do JSON
    mv a0, s1                   # a0 = ponteiro para a string JSON
    la a1, weights_array        # a1 = ponteiro para o grande array de pesos
    jal ra, parse_json_pesos

    # --- Passo 3: Chamar a Lógica Principal da Rede Neural ---
    # Neste ponto, todos os dados estão em arrays de inteiros na memória.
    # Agora podemos começar o processo de inferência.
    jal ra, forward_pass_placeholder

    # O resultado final da inferência estará em v0
    # Descomente as linhas abaixo quando a inferência estiver pronta
    # mv a1, v0      # Mover o resultado (índice) para o argumento de impressão
    # li a0, 1       # ecall 1 para imprimir inteiro
    # ecall

    # --- Epílogo: Restaurar registradores e limpar o stack ---
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    ret





string_to_int:
    mv t0, a0           # t0 = ponteiro de trabalho para a string
    li t1, 1            # t1 = sinal (1 para positivo, -1 para negativo)
    li t2, 0            # t2 = resultado acumulado

    # Verifica o sinal
    lbu t3, 0(t0)
    la t4, ASCII_MINUS
    lbu t4, 0(t4)
    bne t3, t4, atoi_loop # Se nao for '-', comeca o loop de conversao

    # Se for '-', define o sinal como negativo e avança o ponteiro
    li t1, -1
    addi t0, t0, 1

atoi_loop:
    lbu t3, 0(t0)       # Carrega o proximo caractere

    # Verifica se o caractere é um digito (entre '0' e '9')
    la t4, ASCII_0
    lbu t4, 0(t4)
    blt t3, t4, atoi_end # Se for menor que '0', fim do numero

    la t4, ASCII_9
    lbu t4, 0(t4)
    bgt t3, t4, atoi_end # Se for maior que '9', fim do numero

    # Converte o caractere ASCII para digito (ex: '5' -> 5)
    la t4, ASCII_0
    lbu t4, 0(t4)
    sub t3, t3, t4      # t3 agora contem o valor numerico do digito

    # Atualiza o resultado: resultado = resultado * 10 + digito
    li t4, 10
    mul t2, t2, t4      # resultado = resultado * 10
    add t2, t2, t3      # resultado = resultado + digito

    addi t0, t0, 1      # Avanca para o proximo caractere
    j atoi_loop

atoi_end:
    # Aplica o sinal ao resultado
    mul t2, t2, t1

    # Prepara os valores de retorno
    mv v0, t2           # v0 = resultado inteiro
    mv v1, t0           # v1 = ponteiro para o final do numero
    ret


relu:
    # Estende o sinal de 8 bits para 32 bits para comparação correta
    slli a0, a0, 24
    srai a0, a0, 24

    # Compara com zero
    blt a0, zero, relu_is_negative
    
    # Se for >= 0, o valor já está correto
    mv v0, a0
    ret

relu_is_negative:
    # Se for < 0, o resultado é 0
    li v0, 0
    ret


negativo:
    li a0, 0
    ret
relu:
    blt a0, zero, negativo
    ret

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
    li a1, 10 
    li a2, 1                    # size - Writes 4 bytes.
    li a7, 64                   # syscall write (64)
    ecall
    ret

gets:
    mv t0, a0
    li t1, 10

loop2:
    lbu t2, 0(t0)
    beq t2, t1, fimgets
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, t0           # buffer
    li a2, 1            # size - Reads 24 bytes.
    li a7, 63            # syscall read (63)
    ecall
    addi t0, t0, 1
    j loop2

fimgets:
    li a0, 1                    # file descriptor = 1 (stdout)
    li a1, 0 
    li a2, 1                    # size - Writes 4 bytes.
    li a7, 64                   # syscall write (64)
    ecall
    ret

parse_csv_integers:
    # Salvar registradores que serao modificados
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)

    mv s0, a0           # s0 = ponteiro de trabalho para a string
    mv s1, a1           # s1 = ponteiro de trabalho para o array de saida
    li s2, 0            # s2 = contador de inteiros lidos

parse_csv_loop:
    # Chama string_to_int para ler o proximo numero
    mv a0, s0
    jal ra, string_to_int

    # Armazena o numero convertido no array de saida
    sw v0, 0(s1)
    mv s0, v1           # Atualiza o ponteiro da string para depois do numero lido

    # Incrementa o ponteiro do array de saida e o contador
    addi s1, s1, 4
    addi s2, s2, 1

    # Verifica o proximo caractere para decidir o que fazer
    lbu t0, 0(s0)
    beq t0, zero, parse_csv_end # Se for \0, fim da string

    la t1, ASCII_COMMA
    lbu t1, 0(t1)
    beq t0, t1, parse_csv_skip_comma # Se for ',', pula e continua

    j parse_csv_end # Se for qualquer outra coisa (como \n), termina

parse_csv_skip_comma:
    addi s0, s0, 1      # Pula a virgula
    j parse_csv_loop

parse_csv_end:
    mv v0, s2           # Prepara o valor de retorno (quantidade de inteiros)

    # Restaura os registradores
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16
    ret

parse_json_pesos:
    # Salvar registradores
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)

    mv s0, a0           # s0 = ponteiro de trabalho para a string JSON
    mv s1, a1           # s1 = ponteiro de trabalho para o array de pesos

parse_json_loop:
    lbu t0, 0(s0)       # Carrega o caractere atual
    beq t0, zero, parse_json_end # Fim da string?

    # É o começo de um número? (ou é um digito ou é '-')
    li t1, '-'
    beq t0, t1, parse_json_found_num

    li t1, '0'
    blt t0, t1, parse_json_not_num # Nao é um digito
    li t1, '9'
    bgt t0, t1, parse_json_not_num # Nao é um digito

    # Se chegou aqui, é um digito, então é um numero
parse_json_found_num:
    # Encontramos o começo de um número. Chama string_to_int.
    mv a0, s0
    jal ra, string_to_int

    # Salva o peso convertido no array
    sw v0, 0(s1)
    
    # Atualiza os ponteiros
    mv s0, v1           # Ponteiro da string avança para depois do número
    addi s1, s1, 4      # Ponteiro do array avança para a próxima posição
    j parse_json_loop   # Continua a busca

parse_json_not_num:
    # Se nao for o comeco de um numero, apenas avanca na string
    addi s0, s0, 1
    j parse_json_loop

parse_json_end:
    # Restaura registradores
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    ret

