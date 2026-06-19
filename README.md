# Trabalho de Compiladores - Scanner e Parser Java--

Implementação de um analisador léxico (Scanner) e analisador sintático (Parser) para a linguagem **Java--**, desenvolvido com **JFlex** e **JCup**.

---

## Pré-requisitos

- **Java JDK 11 ou superior** — compilação e execução  
  Download: https://adoptium.net/

Os arquivos `jflex-full-1.9.1.jar`, `java-cup-11b.jar` e `java-cup-11b-runtime.jar` já estão incluídos no repositório dentro de `jflex-1.9.1/bin/`.

---

## Estrutura da pasta `jflex-1.9.1/bin/`

| Arquivo | Descrição |
|---|---|
| `Scanner.flex` | Especificação léxica do analisador Java-- (JFlex) |
| `Scanner.java` | Scanner gerado pelo JFlex |
| `Parser.cup` | Especificação sintática do analisador Java-- (JCup) |
| `parser.java`, `sym.java` | Parser gerado pelo JCup |
| `Main.java` | Ponto de entrada principal (Scanner + Parser Java--) |
| `MainExercicio.java` | Ponto de entrada para os exercícios de expressões |
| `exSlide14.flex` | Scanner base dos exercícios de expressões aritméticas (Aulas 14–15) |
| `exSlide15.cup` | Exercícios 1, 2 e 3 da Aula 15 (Tradução Dirigida por Sintaxe) |
| `ex4Slide15.cup` | Exercício 4 da Aula 15 (verificação de divisão por zero) |
| `ex1Slide16.flex` | Exercício 1 da Aula 16 (impressão de INTEIRO no scanner) |
| `exSlide17.flex` | Scanner da Aula 17 (com IDENT, DOT, colchetes) |
| `exSlide17.cup` | Gramática da Aula 17 (com produção designator) |
| `entrada.txt` | Programa Java-- de teste (sem erros) |
| `entrada_erros.txt` | Programa Java-- de teste (com erros léxicos) |
| `saida.txt` | Saída esperada para `entrada.txt` |
| `saida_erros.txt` | Saída esperada para `entrada_erros.txt` |

---

## Como rodar

Todos os comandos devem ser executados **dentro da pasta** `jflex-1.9.1/bin/`.

```powershell
cd jflex-1.9.1\bin
```

---

### 1. Regenerar o Scanner (opcional — `Scanner.java` já está incluído)

```powershell
.\jflex.bat Scanner.flex
```

---

### 2. Regenerar o Parser (opcional — `parser.java` e `sym.java` já estão incluídos)

```powershell
java -jar java-cup-11b.jar -expect 1 Parser.cup
```

O flag `-expect 1` é necessário porque a gramática tem 1 conflito shift/reduce esperado (ambiguidade do *dangling else*, resolvida corretamente pelo parser).

---

### 3. Compilar todos os arquivos Java

```powershell
javac -cp ".;java-cup-11b-runtime.jar" *.java
```

---

### 4. Rodar o Parser com entrada válida

```powershell
java -cp ".;java-cup-11b-runtime.jar" Main entrada.txt
```

Saída esperada:
```
Analise sintatica concluida com sucesso.
```

---

### 5. Rodar o Parser com entrada contendo erros léxicos

```powershell
java -cp ".;java-cup-11b-runtime.jar" Main entrada_erros.txt
```

Saída esperada:
```
[8,9] erro lexico: hexadecimal invalido -> 0XFF
[9,9] erro lexico: numero real invalido -> 5.
[10,9] erro lexico: numero real invalido -> .5
[11,9] erro lexico: hexadecimal incompleto -> 0x
Analise sintatica concluida com sucesso.
```

---

### 6. Rodar os exercícios de expressões aritméticas (Aulas 14–15)

Digitando expressões interativamente (Ctrl+Z para encerrar no Windows):

```powershell
java -cp ".;java-cup-11b-runtime.jar" MainExercicio
```

---

### 7. Exercício 1 da Aula 16 — impressão no scanner

O arquivo `ex1Slide16.flex` demonstra que ações no `.lex` executam **antes** das ações semânticas do `.cup`. Para testar, regenere o scanner com esse arquivo (substitui o `Scanner.java` temporariamente):

```powershell
.\jflex.bat ex1Slide16.flex
```

Compile e rode com qualquer expressão como `4 + 2;` — a saída mostrará `scanner: 4.0` e `scanner: 2.0` **antes** de `Resultado = 6.0`.

---

## Exercício 2 da Aula 16 — ordem de execução dos blocos

Dada a parse tree da expressão `3 + 5;`, a ordem de execução dos blocos em um parser bottom-up é:

**d → b → c → e → f → a**

Raciocínio: o parser reduz das folhas para a raiz. Primeiro o INTEIRO esquerdo (d), depois a ação intermediária pós-`expr` esquerdo (b), depois a ação pós-`MAIS` (c), depois o INTEIRO direito (e), depois a redução da soma (f), e por último a redução de `expr_ptv` (a).

---

## Observação sobre a sintaxe Java--

Em Java--, as declarações de variáveis locais ficam **entre** o `)` e o `{` do método, não dentro do bloco:

```
void main()
    int x;
    int resultado;
{
    x = 10;
    return;
}
```

Isso é diferente do Java padrão. O bloco `{ }` contém apenas os statements.
