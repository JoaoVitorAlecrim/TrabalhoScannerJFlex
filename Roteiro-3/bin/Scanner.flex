/* Scanner.flex - Roteiro 3: Declaracao de Variavel
 *
 * Mudancas em relacao ao Roteiro 2:
 *   - Removido KW_IF (nao usado neste roteiro)
 *   - Adicionado KW_PROGRAM para a palavra reservada "program"
 *   - "program" deve vir ANTES de {ident} para ter prioridade sobre ele
 *
 * Nota importante: int, float, char etc. sao tratados como IDENT neste
 * roteiro — apenas "program" e uma palavra reservada separada.
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

digito       = [0-9]
letra        = [a-zA-Z]
digitos      = {digito}+
ident        = {letra}({letra}|{digito}|_)*
opRelacional = ">="|"<="|"=="|"!="|">"|"<"
fimLinha     = \r|\n|\r\n
espaco       = {fimLinha} | [ \t\f]

%%

/* --- Operadores relacionais (devem vir antes de > e < isolados) --- */
{opRelacional} {
    return new Symbol(sym.OP_RELACIONAL, yytext());
}

/* --- Numeros inteiros --- */
{digitos} {
    return new Symbol(sym.NUMBER, Double.valueOf(Double.parseDouble(yytext())));
}

/* --- Operadores aritmeticos --- */
"+"  { return new Symbol(sym.MAIS);    }
"-"  { return new Symbol(sym.MENOS);   }
"*"  { return new Symbol(sym.MULT);    }
"/"  { return new Symbol(sym.DIV);     }
"%"  { return new Symbol(sym.MOD);     }

/* --- Delimitadores --- */
";"  { return new Symbol(sym.PTVIRG);       }
"("  { return new Symbol(sym.ABRE_PARENT);  }
")"  { return new Symbol(sym.FECHA_PARENT); }
"{"  { return new Symbol(sym.ABRE_CHAVE);   }
"}"  { return new Symbol(sym.FECHA_CHAVE);  }
"["  { return new Symbol(sym.ABRE_COLCH);   }
"]"  { return new Symbol(sym.FECHA_COLCH);  }
"."  { return new Symbol(sym.PTO);          }
","  { return new Symbol(sym.VIRG);         }

/* --- Palavras reservadas (DEVEM vir antes de {ident}) ---
 * JFlex usa "primeira regra que casa" para matches do mesmo tamanho.
 * Se {ident} viesse antes, "program" seria lexado como IDENT, nao KW_PROGRAM.
 */
"program" { return new Symbol(sym.KW_PROGRAM); }

/* --- Identificadores (SEMPRE apos as keywords) --- */
{ident} { return new Symbol(sym.IDENT, yytext()); }

/* --- Espacos e fins de linha: ignorar --- */
{espaco} { /* despreza */ }

/* --- Qualquer outro caracter: erro lexico --- */
[^] {
    System.err.println("Erro lexico na linha " + (yyline + 1) +
                       ", coluna " + (yycolumn + 1) +
                       ": caractere invalido '" + yytext() + "'");
}
