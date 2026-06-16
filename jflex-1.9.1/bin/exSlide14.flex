/* exSlide14.flex - Scanner base para exercicios das Aulas 14 e 15 */
 *
 * Ex1: +, -
 * Ex2: adiciona *, /, %
 * Ex3: adiciona ( ) para alterar precedencia
 * Ex4: mesmo scanner (verificacao de denominador fica no .cup)
 *
 * INTEIRO retorna Double (necessario para Traducao Dirigida por Sintaxe)
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
    /* Construtor para leitura de System.in */
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

/* --- Numeros (retornam Double para o parser) --- */
{inteiro} {
    double val = Double.parseDouble(yytext());
    return new Symbol(sym.INTEIRO, Double.valueOf(val));
}

/* --- Operadores aritmeticos (Ex1, Ex2) --- */
"+"  { return new Symbol(sym.MAIS);    }
"-"  { return new Symbol(sym.MENOS);   }
"*"  { return new Symbol(sym.VEZES);   }
"/"  { return new Symbol(sym.DIVISAO); }
"%"  { return new Symbol(sym.MOD);     }

/* --- Parenteses (Ex3) --- */
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
