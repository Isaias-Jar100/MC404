
int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n){
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD  0
#define STDOUT_FD 1


void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}
 
//Formato de string - "SDDDD SDDDD SDDDD SDDDD SDDDD SDDDD SDDDD SDDDD\n"
void str2dec(char entrada[], int saida[]) {
    for (int i = 0; i < 8; i++) {
        saida[i] = 0;  // Inicializa com 0
        for (int j = 1; j < 5; j++) {  // Captura os 4 dígitos
            saida[i] = (saida[i]) * 10 + (entrada[(i * 6) + j] - '0');
        }
        if (entrada[i * 6] == '-') {  // Aplica o sinal
            saida[i] = -saida[i];
        }
    }
}

int N1operação(int entrada[]){
    int N1 =0;
    N1 = entrada[0] & entrada[1];
    return N1;
}

int N2operação(int entrada[]){
    int N2 = 0;
    N2 = entrada[3] | entrada[4];
    return N2;
}

int N3operação(int entrada[]){
    int N3 = 0;
    N3 = entrada[5] ^ entrada[6];
    return N3;
}

int N4operação(int entrada[]){
    int N4 = 0;
    N4 = ~(entrada[7] ^ entrada[8]);
    return N4;
}

int montar_a_resposta(int n1, int n2, int n3, int n4){
    int resultado = 0;
    resultado |= (n1 & 0xFF);       // Bits 0 a 7
    resultado |= (n2 & 0xFF) << 8;  // Bits 8 a 15
    resultado |= (n4 & 0xFF) << 16; // Bits 16 a 23
    resultado |= (n3 & 0xFF) << 24; // Bits 24 a 31

    return resultado;
}

void dec2str(int entrada[], char saida[]){
    for (int i = 0; i < 8; i++) {
        int pos = i * 6;
        if (entrada[i] < 0) {
            saida[pos] = '-';
            entrada[i] = -entrada[i];
        }
        else {
            saida[pos] = '+';
        }
        for (int j = 4; j > 0; j--) {
            saida[pos + j] = (entrada[i] % 10) + '0';
            entrada[i] /= 10;
        }
        if (i < 7) {
            saida[pos + 5] = ' ';
        }
    }

    saida[47] = '\n';
}


int main()
{
    char str[47];
    int dec[8];
    /* Read up to 8 bytes from the standard input into the str buffer */
    int n = read(STDIN_FD, str, 47);
    /* Write n bytes from the str buffer to the standard output */
    
    int N1,N2,N3,N4;
    int resposta = 0;

    str2dec(str,dec);
    N1 = N1operação(dec);
    N2 = N2operação(dec);
    N3 = N3operação(dec);
    N4 = N4operação(dec);  

    resposta = montar_a_resposta(N1,N2,N3,N4);
    
    hex_code(resposta);


  return 0;
}
