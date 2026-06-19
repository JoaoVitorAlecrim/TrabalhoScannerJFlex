/* Scanner.flex - Roteiro 1: Local, Bloco e Precedencia (expr, term, factor)
 *
 * Reconhece expressoes aritmeticas com operadores: + - * / % e parenteses
 * Retorna NUMBER como Double (necessario para a Traducao Dirigida por Sintaxe)
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
    /* Construtor para leitura de System.in (teclado) */
    public Scanner(java.io.InputStream in) {
        this(new java.io.InputStreamReader(in,
             java.nio.charset.Charset.forName("UTF-8")));
    }
%}

digito   = [0-9]
digitos  = {digito}+
fimLinha = \r|\n|\r\n
espaco   = {fimLinha} | [ \t\f]

%%

/* --- Numeros inteiros: retorna Double para o parser --- */
{digitos} {
    double val = Double.parseDouble(yytext());
    return new Symbol(sym.NUMBER, Double.valueOf(val));
}

/* --- Operadores aritmeticos --- */
"+"  { return new Symbol(sym.MAIS);        }
"-"  { return new Symbol(sym.MENOS);       }
"*"  { return new Symbol(sym.MULT);        }
"/"  { return new Symbol(sym.DIV);         }
"%"  { return new Symbol(sym.MOD);         }

/* --- Delimitadores --- */
";"  { return new Symbol(sym.PTVIRG);      }
"("  { return new Symbol(sym.ABRE_PARENT); }
")"  { return new Symbol(sym.FECHA_PARENT);}

/* --- Espacos e quebras de linha: ignora --- */
{espaco} { /* despreza */ }

/* --- Caracter invalido --- */
[^] {
    System.err.println("Erro lexico na linha " + (yyline + 1) +
                       ", coluna " + (yycolumn + 1) +
                       ": caractere invalido '" + yytext() + "'");
}
