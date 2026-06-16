/* ex1Slide16.flex - Exercicio 1 da Aula 16
 *
 * Igual ao exSlide14.flex, mas com impressao do valor do INTEIRO
 * diretamente no scanner (dentro da regra .lex), antes de retornar
 * o token ao parser.
 *
 * Objetivo: mostrar que acoes no .lex executam ANTES das acoes
 * semanticas do .cup. Como o parsing e bottom-up, o scanner imprime
 * "scanner: X.0" antes de o parser imprimir "Resultado = X".
 *
 * Exemplo de saida para entrada "4;":
 *   scanner: 4.0
 *   Resultado = 4.0
 */

import java_cup.runtime.Symbol;

%%

%class Scanner
%unicode
%cup
%line
%column
%public

%{
    public Scanner(java.io.InputStream in) {
        this(new java.io.InputStreamReader(in,
             java.nio.charset.Charset.forName("UTF-8")));
    }
%}

digito    = [0-9]
inteiro   = {digito}+
fimLinha  = \r|\n|\r\n
espaco    = {fimLinha} | [ \t\f]

%%

/* --- Numeros: imprime no scanner E retorna token ao parser --- */
{inteiro} {
    double val = Double.parseDouble(yytext());
    System.out.println("scanner: " + val);
    return new Symbol(sym.INTEIRO, Double.valueOf(val));
}

/* --- Operadores aritmeticos --- */
"+"  { return new Symbol(sym.MAIS);    }
"-"  { return new Symbol(sym.MENOS);   }
"*"  { return new Symbol(sym.VEZES);   }
"/"  { return new Symbol(sym.DIVISAO); }
"%"  { return new Symbol(sym.MOD);     }

/* --- Parenteses --- */
"("  { return new Symbol(sym.ABRE);   }
")"  { return new Symbol(sym.FECHA);  }

/* --- Ponto e virgula --- */
";"  { return new Symbol(sym.PTVIRG); }

/* --- Espacos: ignora --- */
{espaco} { /* despreza */ }

/* --- Caracter invalido --- */
[^] {
    System.err.println("Erro lexico na linha " + (yyline+1) +
                       ", coluna " + (yycolumn+1) +
                       ": caractere invalido '" + yytext() + "'");
}
