/* Scanner.flex - Roteiro 4: Atribuicao
 *
 * Mudanca em relacao ao Roteiro 3:
 *   - Adicionado IGUAL para o simbolo "=" (atribuicao)
 *
 * CUIDADO com a ordem:
 *   {opRelacional} vem ANTES de "=" para que "==" seja capturado
 *   como OP_RELACIONAL (maximal munch ja garante isso, mas a ordem
 *   explicita torna a intencao clara).
 *
 * Novas palavras reservadas (KW_IF, KW_ELSE, KW_WHILE) serao adicionadas
 * nos proximos roteiros; por enquanto so KW_PROGRAM e necessario.
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

/* --- Operadores relacionais (ANTES de "=" para que == nao vire IGUAL+IGUAL) --- */
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

/* --- Atribuicao (apos opRelacional para nao conflitar com ==) --- */
"="  { return new Symbol(sym.IGUAL); }

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

/* --- Palavras reservadas (DEVEM vir antes de {ident}) --- */
"program" { return new Symbol(sym.KW_PROGRAM); }

/* --- Identificadores (SEMPRE apos as keywords) --- */
{ident} { return new Symbol(sym.IDENT, yytext()); }

/* --- Espacos: ignorar --- */
{espaco} { /* despreza */ }

/* --- Caracter invalido --- */
[^] {
    System.err.println("Erro lexico na linha " + (yyline + 1) +
                       ", coluna " + (yycolumn + 1) +
                       ": caractere invalido '" + yytext() + "'");
}
