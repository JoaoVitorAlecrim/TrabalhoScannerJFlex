/* Scanner.flex - Roteiro 9: Registro de Erros com Localizacao
 *
 * Mudanca em relacao ao Roteiro 8:
 *   Erros lexicos (caractere invalido) nao sao mais impressos no stderr.
 *   Agora sao REGISTRADOS em ListaErro para impressao ao final.
 *
 *   ANTES: System.err.println("Erro lexico na linha ...");
 *   AGORA:  ListaErro.adicionar("Caractere invalido: '...'", linha, coluna);
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

{opRelacional} {
    return new Symbol(sym.OP_RELACIONAL, yytext());
}

{decimal} {
    return new Symbol(sym.NUMBER, Double.valueOf(Double.parseDouble(yytext())));
}

{digitos} {
    return new Symbol(sym.NUMBER, Double.valueOf(Double.parseDouble(yytext())));
}

"+"  { return new Symbol(sym.MAIS);    }
"-"  { return new Symbol(sym.MENOS);   }
"*"  { return new Symbol(sym.MULT);    }
"/"  { return new Symbol(sym.DIV);     }
"%"  { return new Symbol(sym.MOD);     }
"="  { return new Symbol(sym.IGUAL);   }
";"  { return new Symbol(sym.PTVIRG);       }
"("  { return new Symbol(sym.ABRE_PARENT);  }
")"  { return new Symbol(sym.FECHA_PARENT); }
"{"  { return new Symbol(sym.ABRE_CHAVE);   }
"}"  { return new Symbol(sym.FECHA_CHAVE);  }
"["  { return new Symbol(sym.ABRE_COLCH);   }
"]"  { return new Symbol(sym.FECHA_COLCH);  }
"."  { return new Symbol(sym.PTO);          }
","  { return new Symbol(sym.VIRG);         }

"program" { return new Symbol(sym.KW_PROGRAM); }
"if"      { return new Symbol(sym.KW_IF);      }
"else"    { return new Symbol(sym.KW_ELSE);    }
"while"   { return new Symbol(sym.KW_WHILE);   }
"for"     { return new Symbol(sym.KW_FOR);     }
"do"      { return new Symbol(sym.KW_DO);      }
"true"    { return new Symbol(sym.KW_TRUE);    }
"false"   { return new Symbol(sym.KW_FALSE);   }

{ident} { return new Symbol(sym.IDENT, yytext()); }

{espaco} { /* despreza */ }

/* Caractere invalido: registra na lista de erros em vez de imprimir no stderr */
[^] {
    ListaErro.adicionar(
        "Caractere invalido: '" + yytext() + "'",
        yyline + 1,
        yycolumn + 1
    );
}
