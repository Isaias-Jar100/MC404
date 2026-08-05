# MC404 — Organização Básica de Computadores e Linguagem de Montagem

Repositório com os laboratórios desenvolvidos durante a disciplina **MC404 — Organização Básica de Computadores e Linguagem de Montagem**, cursada na Universidade Estadual de Campinas — UNICAMP, no primeiro semestre de 2025.

As atividades exploram programação de baixo nível em **C** e **Assembly RISC-V**, abordando representação de dados, registradores, memória, chamadas de sistema, ABI, recursão, estruturas de dados, MMIO e interação direta com periféricos.

<div align="center">

![C](https://img.shields.io/badge/C-Programming-A8B9CC?style=for-the-badge&logo=c&logoColor=white)
![RISC-V](https://img.shields.io/badge/Assembly-RISC--V-283272?style=for-the-badge&logo=riscv&logoColor=white)
![Linux](https://img.shields.io/badge/Environment-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![UNICAMP](https://img.shields.io/badge/UNICAMP-MC404-B31B1B?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Concluído-2E8B57?style=for-the-badge)

</div>

## Sobre o repositório

O objetivo deste repositório é registrar as implementações e os conhecimentos desenvolvidos ao longo da disciplina.

A sequência de atividades começa com programas em C executados sem a biblioteca padrão e avança gradualmente para implementações completas em Assembly RISC-V, incluindo algoritmos recursivos, estruturas de dados, manipulação de imagens e controle de dispositivos externos.

Entre os principais assuntos estudados estão:

- arquitetura e conjunto de instruções RISC-V;
- registradores e representação de dados;
- operações aritméticas e lógicas;
- manipulação de bits, máscaras e deslocamentos;
- conversão entre bases numéricas;
- chamadas de sistema com `ecall`;
- leitura e escrita sem a biblioteca padrão C;
- pilha e convenção de chamadas;
- Application Binary Interface — ABI;
- funções recursivas;
- listas encadeadas;
- processamento de imagens PGM;
- esteganografia e cifra de César;
- entrada e saída mapeada em memória — MMIO;
- controle de periféricos e dispositivos externos;
- inferência de redes neurais com aritmética inteira.

## Estrutura

```text
MC404/
├── Lab01/
├── Lab02/
├── Lab03/
├── Lab04/
├── Lab05/
├── Lab06/
├── Lab07/
├── Lab08/
├── Lab09/
├── Lab10/
├── Lab11/
└── Lab EXTRA/
```

Cada diretório contém a solução desenvolvida para a respectiva atividade. Algumas pastas também incluem relatórios produzidos pelo ambiente de avaliação da disciplina.

## Laboratórios

### [Lab 01 — Calculadora simples](./Lab01)

Implementação, em C, de uma calculadora de símbolos capaz de realizar operações de adição, subtração e multiplicação.

O programa foi desenvolvido sem utilizar a biblioteca padrão C, implementando diretamente:

- ponto de entrada `_start`;
- encerramento com a chamada de sistema `exit`;
- leitura da entrada padrão com `read`;
- escrita na saída padrão com `write`;
- integração entre C e instruções Assembly RISC-V.

[Enunciado oficial do Lab 01](https://ic.unicamp.br/~allanms/mc404-S12025/labs/Lab-01/)

---

### [Lab 02 — Depuração de código com ALE](./Lab02)

Atividade de familiarização com o modo de depuração do simulador RISC-V ALE.

O laboratório envolve:

- execução passo a passo de instruções;
- inspeção de registradores;
- inspeção e modificação de posições de memória;
- identificação de símbolos e endereços;
- análise de desvios e laços;
- acompanhamento da evolução do estado do processador.

Entre os comandos utilizados estão `step`, `until`, `peek`, `poke`, `symbols` e `run`.

[Enunciado oficial do Lab 02](https://ic.unicamp.br/~allanms/mc404-S12025/labs/Lab-02/)

---

### [Lab 03 — Conversão de bases](./Lab03)

Programa em C que recebe um número binário de 32 bits e produz diferentes representações numéricas.

Foram trabalhadas conversões para:

- binário;
- decimal;
- octal;
- hexadecimal;
- números positivos;
- números negativos em complemento de dois.

A atividade também utiliza chamadas de sistema implementadas com Assembly embutido, sem dependência da biblioteca padrão C.

[Enunciado oficial do Lab 03](https://ic.unicamp.br/~allanms/mc404-S12025/labs/Lab-03/)

---

### [Lab 04 — Operações bit a bit e máscaras](./Lab04)

Programa em C que lê oito números decimais, seleciona intervalos específicos de seus bits e os compacta em uma única palavra de 32 bits.

Principais conceitos:

- máscaras binárias;
- deslocamentos para a esquerda e para a direita;
- operações AND, OR e XOR;
- números positivos e negativos;
- representação hexadecimal;
- compactação de campos em uma palavra de memória.

[Enunciado oficial do Lab 04](https://ic.unicamp.br/~allanms/mc404-S12025/labs/Lab-04/)

---

### [Lab 05 — Cálculo aproximado da hipotenusa](./Lab05)

Primeiro laboratório desenvolvido integralmente em Assembly RISC-V.

O programa recebe três pontos que formam um triângulo retângulo e calcula aproximadamente o comprimento de sua hipotenusa.

A implementação envolve:

- leitura e interpretação de coordenadas;
- cálculo das diferenças entre os pontos;
- exponenciação inteira;
- soma dos quadrados dos catetos;
- cálculo aproximado de raiz quadrada;
- conversão entre texto e valores inteiros;
- chamadas de sistema diretamente em Assembly.

[Enunciado oficial do Lab 05](https://ic.unicamp.br/~allanms/mc404-S12025/labs/Lab-05/)

---

### [Lab 06 — Similaridade de triângulos](./Lab06)

Programa em Assembly RISC-V que calcula o cateto adjacente de um triângulo retângulo menor a partir das medidas de outro triângulo semelhante.

A solução utiliza a relação:

```text
CA₁ / CO₁ = CA₂ / CO₂
```

e, consequentemente:

```text
CA₂ = (CA₁ × CO₂) / CO₁
```

A atividade trabalha leitura de números, multiplicação, divisão inteira, truncamento do resultado e impressão em formato decimal.

[Enunciado oficial do Lab 06](https://ic.unicamp.br/~allanms/mc404-S12025/labs/Lab-06/)

---

### [Lab 07 — Cálculo aproximado de integral](./Lab07)

Implementação, em Assembly RISC-V, do cálculo aproximado de uma integral definida formada por três termos polinomiais.

O programa recebe:

- o sinal de cada termo;
- o expoente correspondente;
- o limite inferior da integral;
- o limite superior da integral.

O cálculo utiliza somente aritmética inteira, estruturas de repetição, decisões condicionais e truncamento dos resultados.

[Enunciado oficial do Lab 07](https://ic.unicamp.br/~allanms/mc404-S12025/labs/Lab-07/)

---

### [Lab 08 — Esteganografia em imagens PGM](./Lab08)

Programa em Assembly RISC-V para extração, decodificação e reinserção de mensagens escondidas em uma imagem PGM de 64 × 64 pixels.

A atividade envolve:

- leitura de arquivos;
- interpretação do formato PGM;
- manipulação dos bits menos significativos dos pixels;
- extração de duas mensagens ocultas;
- identificação do deslocamento de uma cifra de César;
- decodificação da mensagem criptografada;
- reinserção da mensagem nos últimos pixels da imagem;
- exibição da imagem no Canvas do simulador.

[Enunciado oficial do Lab 08](https://ic.unicamp.br/~allanms/mc404-S12025/labs/Lab-08/)

---

### [Lab 09 — Busca em lista encadeada e ABI](./Lab09)

Implementação da função:

```c
int linked_list_search(Node *head_node, int val);
```

A função percorre uma lista encadeada e retorna o índice do primeiro nó cuja soma dos valores corresponde ao valor procurado. Caso nenhum nó satisfaça a condição, retorna `-1`.

O código Assembly é ligado a um programa escrito em C, exigindo compatibilidade com a ABI RISC-V.

Também foram implementadas funções utilitárias semelhantes a:

```c
void puts(const char *str);
char *gets(char *str);
int atoi(const char *str);
char *itoa(int value, char *str, int base);
```

[Enunciado oficial do Lab 09](https://ic.unicamp.br/~allanms/mc404-S12025/labs/Lab-09/)

---

### [Lab 10 — Recursão e ABI](./Lab10)

Implementação de três algoritmos recursivos em Assembly RISC-V:

```c
int fibonacci_recursive(int num);
int fatorial_recursive(int num);
void torre_de_hanoi(
    int num,
    char de,
    char auxiliar,
    char ate,
    char *str
);
```

O laboratório trabalha:

- recursão;
- manipulação da pilha;
- preservação de registradores;
- endereços de retorno;
- passagem de parâmetros;
- retorno de funções;
- compatibilidade entre C e Assembly;
- convenção de chamadas da ABI RISC-V.

[Enunciado oficial do Lab 10](https://ic.unicamp.br/~allanms/mc404-S12025/labs/Lab-10/)

---

### [Lab 11 — Controle de carrinho por MMIO](./Lab11)

Programa em Assembly RISC-V responsável por conduzir um carrinho virtual de uma posição inicial até um ponto de destino.

O veículo é um dispositivo externo conectado ao processador e controlado exclusivamente por meio de entrada e saída mapeada em memória — MMIO.

O laboratório envolve acesso a:

- coordenadas e rotação fornecidas pelo GPS;
- câmera de linha;
- sensor ultrassônico;
- direção do volante;
- motor;
- freio de mão;
- posições de memória associadas aos periféricos.

A solução deve interpretar os sensores, controlar o movimento do veículo e alcançar o destino dentro do limite definido pelo ambiente de avaliação.

[Enunciado oficial do Lab 11](https://ic.unicamp.br/~allanms/mc404-S12025/labs/Lab-11/)

---

### [Trabalho extra — Iris em Assembly](./Lab%20EXTRA)

Implementação, em Assembly RISC-V, do processo de inferência de uma rede neural treinada para classificar amostras do conjunto de dados Iris.

O trabalho envolve:

- leitura da arquitetura da rede;
- interpretação dos pesos fornecidos em formato textual;
- manipulação de matrizes;
- multiplicação matriz-vetor;
- inferência camada por camada;
- números inteiros quantizados em 8 bits;
- extensão de sinal;
- função de ativação ReLU;
- seleção da classe final com `argmax`.

A rede recebe as medidas de uma flor e retorna uma das três classes:

- Iris setosa;
- Iris versicolor;
- Iris virginica.

[Enunciado oficial do trabalho extra](https://ic.unicamp.br/~allanms/mc404-S12025/trab/trabalho-1/)

## Tecnologias e ferramentas

| Tecnologia | Utilização |
|---|---|
| **C** | Laboratórios iniciais, manipulação de dados e integração com Assembly |
| **Assembly RISC-V** | Implementação dos algoritmos e acesso direto à arquitetura |
| **ALE** | Simulação, execução e depuração dos programas RISC-V |
| **Linux** | Ambiente de desenvolvimento |
| **Syscalls** | Entrada, saída, arquivos e encerramento dos programas |
| **MMIO** | Comunicação direta com dispositivos externos |
| **ABI RISC-V** | Integração entre funções escritas em C e Assembly |
| **PGM** | Processamento e manipulação de imagens em tons de cinza |

## Principais aprendizados

Ao longo da disciplina, foram consolidados conhecimentos sobre:

- relação entre código C, Assembly e código de máquina;
- funcionamento do processo de compilação, montagem e ligação;
- organização dos registradores RISC-V;
- representação de inteiros com e sem sinal;
- complemento de dois;
- manipulação direta de bits;
- acesso e organização da memória;
- implementação de funções sem bibliotecas;
- uso da pilha em chamadas recursivas;
- interoperabilidade entre C e Assembly;
- implementação de estruturas de dados em baixo nível;
- comunicação entre software e hardware;
- programação de periféricos por MMIO;
- implementação de algoritmos numéricos com aritmética inteira;
- execução de uma rede neural em linguagem de montagem.

## Como executar

Os laboratórios foram desenvolvidos para execução no simulador **ALE**, disponível em:

[https://riscv-programming.org/](https://riscv-programming.org/)

O procedimento geral é:

1. Acesse o simulador ALE.
2. Carregue o arquivo `.c` ou `.s` do laboratório.
3. Carregue também eventuais arquivos auxiliares, como imagens PGM.
4. Utilize a opção **Run** para compilar e executar.
5. Utilize a opção **Debug** para executar instruções passo a passo.
6. Ative os periféricos necessários na seção **Hardware**, quando aplicável.

Os formatos de entrada, os dispositivos necessários e as condições de avaliação variam entre os laboratórios. Consulte o enunciado oficial correspondente para reproduzir cada execução.

## Resultado acadêmico

Disciplina concluída com **média final 7,8/10**.

## Autor

**Isaías Junio Jarcem do Nascimento Almeida**

Estudante de Engenharia de Computação na Universidade Estadual de Campinas — UNICAMP.

- GitHub: [Isaias-Jar100](https://github.com/Isaias-Jar100)

## Aviso acadêmico

Este repositório é mantido como registro do processo de aprendizagem desenvolvido na disciplina.

As soluções são disponibilizadas para fins de estudo e portfólio. Estudantes que estejam cursando a disciplina devem desenvolver suas próprias implementações e respeitar as regras acadêmicas estabelecidas pela universidade.