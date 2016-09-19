#ifndef LINSYS_H
#define LINSYS_H

/** Tamanho máximo da matriz.*/
#define NMAX 1024

/*----Abaixo estão as implementações por colunas.----*/

/** Calcula o fator de Cholesky e guarda-o no canto inferior
  * esquerdo da matriz A. Este método é orientado a colunas.
  *
  * @param n		Tamanho da matriz quadrada.
  * @param A		Matriz quadrada de tamanho máx. NMAX.
  * @return		0 caso sucesso,
  *			-1 se A não é def. positiva.
  */
int cholcol(int n, double A[][NMAX]);

/** Resolve o sistema triangular inferior Ax = b, armazenando
  * o resultado no vetor b. Este método é orientado a colunas.
  *
  * @param n		Tamanho da matriz quadrada.
  * @param A		Matriz quadrada de tamanho máx. NMAX.
  * @param b		Vetor com os coeficientes.
  * @return		0 caso sucesso, 
  *			-1 se A for singular.
  */
int forwcol(int n, double A[][NMAX], double b[]);

/** Resolve o sistema triangular superior Ax = b, armazenando
  * o resultado no vetor b. Este método é orientado a colunas.
  *
  * @param n		Tamanho da matriz quadrada.
  * @param A		Matriz quadrada de tamanho máx. NMAX.
  * @param b		Vetor com os coeficientes.
  * @param trans	a matriz A é transposta?
  * @return		0 caso sucesso, 
  *			-1 se A for singular.
  */
int backcol(int n, double A[][NMAX], double b[], int trans);

/** Resolve um sistema Ax = b dado por uma matriz definida positiva
  * não-singular e simétrica, guardando seu resultado em b. Colunas.
  * @param n		Tamanho da matriz quadrada.
  * @param A		Matriz quadrada simétrica def. positiva.
  *			e não-singular.
  * @param b		Vetor com os coeficientes.
  * @return		0 se sucesso, 
  *			-1 se A não satisfaz as condições acima.
  */
int symmcol(int n, double A[][NMAX], double b[]);

/** Calcula as matrizes L e U da decomposição LU da matriz PA, onde
  * P é a matriz de permutação obtida ao utilizar o pivoteamento parcial.
  * A matriz P é devolvida no vetor p. Orientação a coluna.
  * @param n		Tamanho da matriz
  * @param A		Matriz quadrada
  * @param p		Matriz P de permutações
  * @return		0 se sucesso, -1 
  */
int lucol(int n, double A[][NMAX], int p[]);

/** Calcula a solução do sistema Ax=b usando decomposição LU, 
  * sobreescrevendo b com x, e armazenando a matriz de permutações
  * no vetor p. Orientação a coluna.
  * @param n		Tamanho da matriz.
  * @param A		Matriz quadrada.
  * @param p		Matriz P de permutações
  * @return		0 se sucesso, -1 se U for singular
  */
int sscol(int n, double A[][NMAX], int p[], double b[]);

/*----Abaixo estão as implementações por linhas.----*/

/** Calcula o fator de Cholesky e guarda-o no canto inferior
  * esquerdo da matriz A. Este método é orientado a linhas.
  *
  * @param n		Tamanho da matriz quadrada.
  * @param A		Matriz quadrada de tamanho máx. NMAX.
  * @return		0 caso sucesso,
  *			-1 se A não é def. positiva
  */
int cholrow(int n, double A[][NMAX]);

/** Resolve o sistema triangular inferior Ax = b, armazenando
  * o resultado no vetor b. Este método é orientado a linhas.
  *
  * @param n		Tamanho da matriz quadrada.
  * @param A		Matriz quadrada de tamanho máx. NMAX.
  * @param b		Vetor com os coeficientes.
  * @return		0 caso sucesso, 
  *			-1 se A for singular.
  */
int forwrow(int n, double A[][NMAX], double b[]);

/** Resolve o sistema triangular superior Ax = b, armazenando
  * o resultado no vetor b. Este método é orientado a colunas.
  *
  * @param n		Tamanho da matriz quadrada.
  * @param A		Matriz quadrada de tamanho máx. NMAX.
  * @param trans	a matriz A é transposta?
  * @return		0 caso sucesso, 
  *			-1 se A for singular.
  */
int backrow(int n, double A[][NMAX], double b[], int trans);

/** Resolve um sistema Ax = b dado por uma matriz definida positiva
  * não-singular e simétrica, guardando seu resultado em b. Linhas.
  * @param n		Tamanho da matriz quadrada.
  * @param A		Matriz quadrada simétrica def. positiva
  *			e não-singular.
  * @param b		Vetor com os coeficientes.
  * @return		0 se sucesso, 
  			-1 se A não satisfaz as condições acima.
  */
int symmrow(int n, double A[][NMAX], double b[]);

/** Calcula as matrizes L e U da decomposição LU da matriz PA, onde
  * P é a matriz de permutação obtida ao utilizar o pivoteamento parcial.
  * A matriz P é devolvida no vetor p. Orientação a linha.
  * @param n		Tamanho da matriz
  * @param A		Matriz quadrada
  * @param p		Matriz P de permutações
  * @return		0 se sucesso, -1 se A for singular.
  */
int lurow(int n, double A[][NMAX], int p[]);

/** Calcula a solução do sistema Ax=b usando decomposição LU, 
  * sobreescrevendo b com x, e armazenando a matriz de permutações
  * no vetor p. Orientação a linha.
  * @param n		Tamanho da matriz.
  * @param A		Matriz quadrada.
  * @param p		Matriz P de permutações
  * @return		0 se sucesso, -1 se U for singular
  */
int ssrow(int n, double A[][NMAX], int p[], double b[]);

/*Funções de Entrada/Saída*/

/** Imprime uma matriz A no terminal
  * @param n		Tamanho da matriz.
  * @param A		Matriz quadrada.
  */
void print_matrix(int n, double A[][NMAX]);

/** Imprime um vetor v no terminal
  * @param n		Tamanho do vetor.
  * @param v		Vetor.
  */
void print_vector(int n, double v[]);

/** Lê um sistema linear de um arquivo gerado pelo genmat.c
  * disponiblizado pelo professor.
  * @param filename	String com o caminho para o arquivo.
  * @param A		Matriz quadrada a ser preenchida.
  * @param b		Vetor com os coeficientes a ser preenchido.
  * @return		Tamanho da matriz quadrada.
  */
int read_linsys_file(const char* filename, double A[][NMAX], double b[]);

/** Escreve um sistema linear para um arquivo compatível com o genmat.c
  * disponiblizado pelo professor.
  * @param filename	String com o caminho para o arquivo.
  * @param n		Tamanho da matriz quadrada.
  * @param A		Matriz quadrada a ser guardada.
  * @param b		Vetor com os coeficientes a ser guardado.
  * @return		0 em caso erro.
  */
int write_linsys_file(const char* filename, int n, double A[][NMAX], double b[]);

#endif
