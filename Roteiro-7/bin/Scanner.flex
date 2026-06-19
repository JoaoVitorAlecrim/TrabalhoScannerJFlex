/* Scanner.flex - Roteiro 7: Regra if-else
 *
 * Igual ao Roteiro 6: nenhuma mudanca necessaria no scanner.
 * KW_ELSE ja estava presente desde o Roteiro 5.
 * KW_TRUE e KW_FALSE ja estavam presentes desde o Roteiro 6.
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
decimal      = {digito}+ "." {digito}+
ident        = {letra}({letra}|{digito}|_)*
opRelacional = ">="|"<="|"=="|"!="|">"|"<"
fimLinha     = \r|\n|\r\n
espaco       = {fimLinha} | [ \t\f]

%%

/* --- Operadores relacionais com valor String (ANTES de "=" para que == nao vire IGUAL) --- */
{opRelacional} {
    return new Symbol(sym.OP_RELACIONAL, yytext());
}

/* --- Numeros decimais (ex: 3.5) --- */
{decimal} {
    return new Symbol(sym.NUMBER, Double.valueOf(Double.parseDouble(yytext())));
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
"if"      { return new Symbol(sym.KW_IF);      }
"else"    { return new Symbol(sym.KW_ELSE);    }
"while"   { return new Symbol(sym.KW_WHILE);   }
"true"    { return new Symbol(sym.KW_TRUE);    }
"false"   { return new Symbol(sym.KW_FALSE);   }

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
