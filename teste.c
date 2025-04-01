#define STDIN_FD 0
#define STDOUT_FD 1

int read(int __fd, void *__buf, int __n) {
    int ret_val;
    __asm__ __volatile__(
        "mv a0, %1\n"
        "mv a1, %2\n"
        "mv a2, %3\n"
        "li a7, 63\n"
        "ecall\n"
        "mv %0, a0\n"
        : "=r"(ret_val)
        : "r"(__fd), "r"(__buf), "r"(__n)
        : "a0", "a1", "a2", "a7");
    return ret_val;
}

void write(int __fd, const void *__buf, int __n) {
    __asm__ __volatile__(
        "mv a0, %0\n"
        "mv a1, %1\n"
        "mv a2, %2\n"
        "li a7, 64\n"
        "ecall\n"
        :
        : "r"(__fd), "r"(__buf), "r"(__n)
        : "a0", "a1", "a2", "a7");
}

void exit(int code) {
    __asm__ __volatile__(
        "mv a0, %0\n"
        "li a7, 93\n"
        "ecall\n"
        :
        : "r"(code)
        : "a0", "a7");
}

void _start() {
    int ret_code = main();
    exit(ret_code);
}


int bin2dec(const char *bin) {
    int dec = 0;
    for (int i = 0; i < 32; i++) {
        dec = (dec << 1) | (bin[i] - '0');
    }
    return dec;
}

// Troca a ordem dos bytes (Endianness)
int swap_endianness(int value) {
    return ((value >> 24) & 0x000000FF) |
           ((value >> 8)  & 0x0000FF00) |
           ((value << 8)  & 0x00FF0000) |
           ((value << 24) & 0xFF000000);
}


void int2str(int num, char *str) {
    char temp[12];
    int i = 0, is_neg = 0;

    if (num < 0) {
        is_neg = 1;
        num = -num;
    }

    do {
        temp[i++] = (num % 10) + '0';
        num /= 10;
    } while (num > 0);

    if (is_neg) temp[i++] = '-';

    for (int j = 0; j < i; j++) {
        str[j] = temp[i - j - 1];
    }
    str[i] = '\n';
    str[i + 1] = '\0';
}


void int2hex(int num, char *str) {
    const char hex_chars[] = "0123456789abcdef";
    str[0] = '0';
    str[1] = 'x';
    for (int i = 0; i < 8; i++) {
        str[9 - i] = hex_chars[num & 0xF];
        num >>= 4;
    }
    str[10] = '\n';
    str[11] = '\0';
}

void int2oct(int num, char *str) {
    const char oct_chars[] = "01234567";
    
    str[0] = '0';
    str[1] = 'o';
    
    int i = 15;  // Espaço para 11 dígitos octais + "0o" + "\n\0"
    str[i--] = '\n'; 
    str[i--] = '\0';  

    do {
        str[i--] = oct_chars[num & 7];  
        num >>= 3;  
    } while (num > 0);
    
    i++;  // Ajusta para apontar para o primeiro caractere octal válido

    // Copia o resultado para o início da string
    int j = 2;
    while (str[i] != '\0') {
        str[j++] = str[i++];
    }

    str[j] = '\n';  
    str[j + 1] = '\0';  
}


void int2bin(int num, char *str) {
    str[0] = '0';
    str[1] = 'b';
    for (int i = 0; i < 32; i++) {
        str[2 + (31 - i)] = (num & 1) ? '1' : '0';
        num >>= 1;
    }
    str[34] = '\n';
    str[35] = '\0';
}

int main() {
    char str[34];
    int n = read(STDIN_FD, str, 33);
    str[32] = '\0'; 

    int dec = bin2dec(str);
    int dec_swapped = swap_endianness(dec);

    char output[36];

    int2str(dec, output);
    write(STDOUT_FD, output, 12);

    int2str(dec_swapped, output);
    write(STDOUT_FD, output, 12);

    int2hex(dec, output);
    write(STDOUT_FD, output, 12);

    int2oct(dec, output);
    write(STDOUT_FD, output, 15);

    int2bin(dec_swapped, output);
    write(STDOUT_FD, output, 36);

    int2str(dec_swapped, output);
    write(STDOUT_FD, output, 12);

    int2hex(dec_swapped, output);
    write(STDOUT_FD, output, 12);

    int2oct(dec_swapped, output);
    write(STDOUT_FD, output, 16);

    return 0;
}
