/* exSlide17.flex - Scanner da Aula 17 (com IDENT, DOT, COL_ABRE, COL_FECHA) */
 *
 * Adiciona ao exercicio.flex (Aulas 15/16):
 *   - IDENT: identificador  letra(letra|digito)*
 *   - DOT:   ponto "."  (acesso a atributo)
 *   - COL_ABRE / COL_FECHA: colchetes "[" "]"  (acesso a vetor)
 *
 * INTEIRO retorna Double; IDENT retorna String.
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

letra     = [a-zA-Z_]
digito    = [0-9]
ident     = {letra}({letra}|{digito})*
inteiro   = {digito}+
fimLinha  = \r|\n|\r\n
espaco    = {fimLinha} | [ \t\f]

%%

/* --- Identificadores (devem vir antes dos inteiros) --- */
{ident} {
    return new Symbol(sym.IDENT, yytext());
}

/* --- Numeros (retornam Double para o parser) --- */
{inteiro} {
    double val = Double.parseDouble(yytext());
    return new Symbol(sym.INTEIRO, Double.valueOf(val));
}

/* --- Operadores aritmeticos --- */
"+"  { return new Symbol(sym.MAIS);    }
"-"  { return new Symbol(sym.MENOS);   }
"*"  { return new Symbol(sym.VEZES);   }
"/"  { return new Symbol(sym.DIVISAO); }
"%"  { return new Symbol(sym.MOD);     }

/* --- Parenteses --- */
"("  { return new Symbol(sym.ABRE);    }
")"  { return new Symbol(sym.FECHA);   }

/* --- Colchetes (acesso a vetor) --- */
"["  { return new Symbol(sym.COL_ABRE);  }
"]"  { return new Symbol(sym.COL_FECHA); }

/* --- Ponto (acesso a atributo de objeto) --- */
"."  { return new Symbol(sym.DOT); }

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
