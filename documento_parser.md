# Trabalho Prático: Analisador Sintático — Parser

**Disciplina:** Compiladores  
**Professor(a):** Alessandra Hauck  
**Curso:** Engenharia de Computação — FATECS  
**Alunos:** João Vitor Alecrim  

---

## 1. Visão Geral

O analisador sintático, ou *parser*, é a segunda etapa de um compilador. Após o analisador léxico (Scanner) ter transformado o código-fonte em uma sequência de tokens, o parser recebe esses tokens e verifica se a estrutura do programa obedece às regras gramaticais da linguagem. Se a estrutura for válida, o parser conclui a análise com sucesso; caso contrário, reporta um erro sintático.

Neste trabalho, o parser foi desenvolvido para a linguagem **Java--**, um subconjunto simplificado do Java, utilizando a ferramenta **JCup** (Java CUP — *Construction of Useful Parsers*). O JCup gera um parser LALR(1) a partir de uma gramática escrita em um arquivo `.cup`, no mesmo espírito que o JFlex gera o scanner a partir de um arquivo `.flex`.

### Arquivos envolvidos

| Arquivo | Papel |
|---|---|
| `Scanner.flex` | Especificação léxica — gera os tokens consumidos pelo parser |
| `Scanner.java` | Scanner gerado pelo JFlex |
| `Parser.cup` | Especificação gramatical — entrada do JCup |
| `sym.java` | Constantes numéricas dos terminais — gerado pelo JCup |
| `parser.java` | Autômato LALR(1) gerado pelo JCup |
| `Main.java` | Ponto de entrada — instancia Scanner e Parser e inicia a análise |
| `entrada.txt` | Programa Java-- de teste (sem erros) |
| `entrada_erros.txt` | Programa Java-- de teste (com erros léxicos) |

(print ou diagrama mostrando o fluxo: entrada.txt → Scanner → tokens → Parser → "Análise concluída")

---

## 2. Gramática da Linguagem Java--

A gramática da linguagem Java-- foi especificada no arquivo `Parser.cup`. Ela é composta por **terminais** (tokens gerados pelo scanner), **não-terminais** (símbolos gramaticais) e **produções** (regras que definem como os símbolos se combinam).

### 2.1 Terminais

Os terminais são os tokens que o scanner entrega ao parser. Cada terminal corresponde a um símbolo do código-fonte.

| Terminal | Descrição |
|---|---|
| `PROGRAM` | Palavra reservada `program` |
| `FINAL` | Palavra reservada `final` |
| `CLASS` | Palavra reservada `class` |
| `VOID` | Palavra reservada `void` |
| `INT`, `FLOAT`, `CHAR` | Tipos primitivos |
| `IF`, `ELSE` | Estrutura condicional |
| `WHILE` | Estrutura de repetição |
| `RETURN` | Retorno de método |
| `READ`, `PRINT` | Entrada e saída |
| `NEW` | Criação de objetos e vetores |
| `IDENT` | Identificador (String) |
| `NUM_INT` | Literal inteiro (Integer) |
| `NUM_REAL` | Literal real (Double) |
| `NUM_HEX` | Literal hexadecimal (String) |
| `CHAR_CONST` | Constante caractere (String) |
| `EQ_EQ`, `NEQ`, `GEQ`, `LEQ`, `GT`, `LT` | Operadores relacionais |
| `EQ` | Operador de atribuição `=` |
| `PLUS`, `MINUS`, `TIMES`, `DIV`, `MOD` | Operadores aritméticos |
| `LBRACE`, `RBRACE` | Chaves `{` `}` |
| `LPAREN`, `RPAREN` | Parênteses `(` `)` |
| `LBRACKET`, `RBRACKET` | Colchetes `[` `]` |
| `SEMICOLON` | Ponto e vírgula `;` |
| `COMMA` | Vírgula `,` |
| `DOT` | Ponto `.` |

### 2.2 Não-terminais e Produções

As produções foram agrupadas por categoria para facilitar a compreensão.

#### Estrutura do programa

Um programa Java-- começa com a palavra `program` seguida de um identificador, uma lista opcional de declarações globais e, entre chaves, a lista de métodos.

```
program       ::= PROGRAM IDENT decl_list LBRACE method_decl_list RBRACE

decl_list     ::= /* vazio */
               | decl_list const_decl
               | decl_list var_decl
               | decl_list class_decl
```

#### Declarações

Constantes são declaradas com `final`, seguidas de tipo, nome, `=` e valor. Variáveis são declaradas com tipo e nome, podendo declarar múltiplos nomes separados por vírgula. Classes são declaradas com `class` e contêm um bloco de declarações de variáveis.

```
const_decl   ::= FINAL type IDENT EQ number SEMICOLON
               | FINAL type IDENT EQ CHAR_CONST SEMICOLON

var_decl     ::= type IDENT var_decl_tail SEMICOLON
var_decl_tail ::= /* vazio */
               | var_decl_tail COMMA IDENT

class_decl   ::= CLASS IDENT LBRACE var_decl_list RBRACE
```

#### Tipos

O tipo pode ser primitivo (`int`, `float`, `char`) ou um identificador de classe, e pode ser vetor adicionando `[]`.

```
type  ::= IDENT | IDENT LBRACKET RBRACKET
        | INT   | INT   LBRACKET RBRACKET
        | FLOAT | FLOAT LBRACKET RBRACKET
        | CHAR  | CHAR  LBRACKET RBRACKET
```

#### Métodos

Um método pode retornar um tipo ou ser `void`. Os parâmetros formais são opcionais. As **declarações de variáveis locais ficam entre `)` e `{`**, fora do bloco de statements — característica específica do Java--.

```
method_decl  ::= type IDENT LPAREN form_pars_opt RPAREN var_decl_list block
               | VOID IDENT LPAREN form_pars_opt RPAREN var_decl_list block

form_pars_opt ::= /* vazio */ | form_pars
form_pars    ::= type IDENT | form_pars COMMA type IDENT
```

#### Bloco e Statements

O bloco é uma lista de statements entre chaves. Os statements cobrem atribuição, chamada de método, condicionais, laços, retorno, leitura e impressão.

```
block        ::= LBRACE stmt_list RBRACE
stmt_list    ::= /* vazio */ | stmt_list statement

statement    ::= designator EQ expr SEMICOLON          /* atribuição */
               | designator act_pars SEMICOLON         /* chamada de método */
               | IF LPAREN condition RPAREN statement
               | IF LPAREN condition RPAREN statement ELSE statement
               | WHILE LPAREN condition RPAREN statement
               | RETURN SEMICOLON
               | RETURN expr SEMICOLON
               | READ LPAREN designator RPAREN SEMICOLON
               | PRINT LPAREN expr RPAREN SEMICOLON
               | PRINT LPAREN expr COMMA NUM_INT RPAREN SEMICOLON
               | block
               | SEMICOLON
```

#### Expressões

As expressões seguem a hierarquia clássica: `expr` → `term` → `factor`, garantindo precedência correta de operadores.

```
expr         ::= term term_list | MINUS term term_list
term_list    ::= /* vazio */ | term_list addop term

term         ::= factor | term mulop factor

factor       ::= designator
               | designator act_pars
               | number
               | CHAR_CONST
               | NEW IDENT
               | NEW IDENT LBRACKET expr RBRACKET
               | LPAREN expr RPAREN
```

#### Designator

O designator representa uma referência a uma variável, campo de objeto ou elemento de vetor, com encadeamento recursivo.

```
designator      ::= IDENT designator_tail
designator_tail ::= /* vazio */
                 | designator_tail DOT IDENT
                 | designator_tail LBRACKET expr RBRACKET
```

Exemplos de designators válidos: `x`, `ponto.x`, `vetor[i]`, `matriz[i][j]`.

#### Condição e operadores

```
condition ::= expr relop expr
relop     ::= EQ_EQ | NEQ | GT | GEQ | LT | LEQ
addop     ::= PLUS | MINUS
mulop     ::= TIMES | DIV | MOD
number    ::= NUM_INT | NUM_REAL | NUM_HEX
```

### 2.3 Conflito Shift/Reduce — Dangling Else

A gramática possui 1 conflito shift/reduce, originado pela ambiguidade do *dangling else*. Considere:

```
if (a > 0) if (b > 0) x = 1; else x = 2;
```

Não está claro, pela gramática, se o `else` pertence ao `if` externo ou ao interno. O parser LALR(1) resolve automaticamente fazendo *shift* (associando o `else` ao `if` mais próximo), que é o comportamento correto e esperado. O flag `-expect 1` no comando de geração do JCup informa que esse único conflito é intencional, evitando que o JCup trate como erro.

(print do aviso de conflito no terminal ao rodar o JCup, mostrando "1 shift/reduce conflict")

---

## 3. Integração Scanner–Parser

O scanner e o parser não funcionam de forma independente — o parser chama o scanner toda vez que precisa do próximo token. Esta integração é possível porque o Scanner.flex foi especificado com a diretiva `%cup`, que faz com que o scanner gerado implemente a interface `Scanner` do JCup, retornando objetos do tipo `Symbol`.

### Adaptações no Scanner.flex para o JCup

Sem o `%cup`, o scanner retornaria `int` (código do token). Com o `%cup`, cada regra retorna um objeto `Symbol` contendo:
- o **código numérico** do token (definido em `sym.java`)
- a **linha e coluna** onde foi encontrado (`yyline`, `yycolumn`)
- o **valor semântico** (o texto ou valor convertido)

```java
// Exemplo de regra no Scanner.flex
"program" { return new Symbol(sym.PROGRAM, yyline, yycolumn, yytext()); }
{INT_LIT}  { return new Symbol(sym.NUM_INT,  yyline, yycolumn, Integer.parseInt(yytext())); }
{IDENT}    { return new Symbol(sym.IDENT,   yyline, yycolumn, yytext()); }
```

A diretiva `%public` é necessária para que a classe `Scanner` gerada seja acessível pelo `Main.java`.

### O papel do sym.java

O arquivo `sym.java` é gerado automaticamente pelo JCup e contém constantes inteiras para cada terminal da gramática. Tanto o scanner quanto o parser os usam para identificar os tokens sem depender de strings.

```java
// Trecho de sym.java (gerado automaticamente)
public class sym {
    public static final int EOF = 0;
    public static final int error = 1;
    public static final int PROGRAM = 2;
    public static final int IDENT = 3;
    public static final int NUM_INT = 4;
    ...
}
```

(print do arquivo sym.java completo)

### Fluxo de comunicação

O parser chama `scanner.next_token()` para obter o próximo `Symbol`. Internamente, isso aciona a máquina de estados do scanner, que lê caracteres do arquivo até completar um lexema e retornar o Symbol correspondente. O parser empilha tokens e reduções conforme a tabela LALR(1) gerada pelo JCup.

(diagrama: arquivo → FileReader → Scanner.next_token() → Symbol → parser.parse() → tabela LALR → aceitar/erro)

---

## 4. Explicando o Código

### 4.1 Scanner.flex

(print do Scanner.flex completo, ou das seções principais: cabeçalho com diretivas %cup %public, macros, regras de palavras reservadas, regras de erros léxicos e estado COMMENT)

O arquivo é dividido em três seções separadas por `%%`:

**Seção de diretivas e código Java:** define o modo `%cup`, o nome da classe gerada (`%class Scanner`), o rastreamento de linha e coluna (`%line %column`), o estado `COMMENT` e as variáveis para controle de comentário aninhado.

**Seção de macros:** define padrões reutilizáveis como `DIGITO`, `LETRA`, `IDENT`, `FLOAT_LIT`, `HEX_LIT`, `CHARCONST` e `BRANCO`.

**Seção de regras:** define o que fazer com cada padrão. A ordem importa: palavras reservadas vêm antes de `{IDENT}` para que `if`, `while`, `program`, etc., sejam reconhecidas corretamente. Regras de erro léxico (`0X`, `{DIGITO}+"."`) vêm antes dos padrões válidos para garantir prioridade. O estado `COMMENT` trata o interior dos comentários `/* ... */`, inclusive detectando comentários aninhados.

### 4.2 Parser.cup

(print do Parser.cup completo)

O arquivo `Parser.cup` tem três seções:

**Declarações de terminais:** lista todos os tokens com seus tipos Java opcionais. `terminal String IDENT` significa que o valor semântico do token IDENT é uma `String`, acessível nas ações como `RESULT`.

**Declarações de não-terminais:** lista todos os não-terminais da gramática. Podem receber tipos para ações semânticas futuras.

**Produções:** cada produção segue o formato `nao_terminal ::= simbolos ... ;`. Produções vazias são representadas por `/* vazio */`. As produções definem a hierarquia completa da linguagem, do `program` até `factor` e `designator`.

### 4.3 sym.java e parser.java

Ambos são gerados automaticamente ao rodar:

```powershell
java -jar java-cup-11b.jar -expect 1 Parser.cup
```

`sym.java` contém apenas constantes inteiras, uma por terminal. `parser.java` contém o autômato LALR(1) completo — as tabelas de *action* e *goto*, a pilha de análise e o loop principal do parser. Esse arquivo não deve ser editado manualmente, pois é sobrescrito a cada geração.

(print do terminal mostrando a execução do JCup e a geração dos dois arquivos)

### 4.4 Main.java

```java
import java.io.FileReader;

public class Main {
    public static void main(String[] args) throws Exception {
        String arquivo = (args.length > 0) ? args[0] : "entrada.txt";
        Scanner scanner = new Scanner(new FileReader(arquivo));
        parser p = new parser(scanner);
        p.parse();
        System.out.println("Analise sintatica concluida com sucesso.");
    }
}
```

O `Main.java` é o ponto de entrada. Ele instancia o `Scanner` passando um `FileReader` com o arquivo de entrada, passa o scanner para o construtor do `parser`, e chama `p.parse()`. Se a análise concluir sem erros sintáticos, a mensagem de sucesso é impressa. Qualquer erro sintático lança uma exceção e a mensagem não é exibida.

### 4.5 entrada.txt

(print do arquivo entrada.txt)

O arquivo de teste cobre os principais recursos da linguagem Java--:
- Declaração de classe (`class Ponto`)
- Variáveis globais e constante (`final int MAX = 100`)
- Método com parâmetros (`void trocar(int a, int b)`)
- Variáveis locais declaradas fora do bloco, entre `)` e `{`
- Estrutura `if-else`
- Estrutura `while`
- Comandos `read` e `print`
- Literal hexadecimal válido (`0xFF`)
- `return` sem valor

---

## 5. Resultados

### 5.1 Entrada válida — entrada.txt

(print do terminal com o comando de compilação e execução)

```powershell
javac -cp ".;java-cup-11b-runtime.jar" *.java
java -cp ".;java-cup-11b-runtime.jar" Main entrada.txt
```

Saída:
```
Analise sintatica concluida com sucesso.
```

Nenhum erro léxico ou sintático é gerado, confirmando que o programa `entrada.txt` está em conformidade com a gramática Java--.

### 5.2 Entrada com erros léxicos — entrada_erros.txt

(print do terminal com a execução sobre entrada_erros.txt)

```powershell
java -cp ".;java-cup-11b-runtime.jar" Main entrada_erros.txt
```

Saída:
```
[8,9] erro lexico: hexadecimal invalido -> 0XFF
[9,9] erro lexico: numero real invalido -> 5.
[10,9] erro lexico: numero real invalido -> .5
[11,9] erro lexico: hexadecimal incompleto -> 0x
Analise sintatica concluida com sucesso.
```

Este teste demonstra que os erros são detectados e reportados pelo scanner com linha e coluna, mas o parser continua a análise e conclui com sucesso — os tokens inválidos são descartados pelo scanner sem produzir um Symbol, portanto o parser nunca os vê e não gera erro sintático.

---

## 6. Conclusão

O trabalho implementou com sucesso um analisador sintático completo para a linguagem Java-- utilizando JCup. A gramática LALR(1) cobre todas as construções da linguagem: declarações globais, classes, constantes, métodos com parâmetros, variáveis locais, estruturas de controle (if-else, while), expressões aritméticas e relacionais, designators recursivos (acesso a campos e vetores), além de chamadas de método e comandos de I/O.

A integração entre o Scanner (JFlex) e o Parser (JCup) é feita por meio da interface `Scanner` do JCup e da classe `sym`, tornando a comunicação entre as duas fases transparente e bem encapsulada. O único conflito shift/reduce presente, referente ao *dangling else*, é tratado corretamente pelo comportamento padrão do parser LALR(1).

---

## 7. Referências

- JFlex User's Manual: https://jflex.de/manual.html  
- JCup User's Manual: http://www2.cs.tum.edu/projects/cup/  
- LOUDEN, Kenneth C. *Compiladores: princípios e práticas*. Thomson Learning, 2004.  
- AHO, Alfred V. et al. *Compiladores: princípios, técnicas e ferramentas*. 2. ed. Pearson, 2008.
