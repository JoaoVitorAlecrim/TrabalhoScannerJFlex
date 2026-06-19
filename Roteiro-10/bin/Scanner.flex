/* Scanner.flex - Roteiro 10: Tratamento de Erros — Especial error
 *
 * Mudancas em relacao ao Roteiro 9:
 *   - Usa arquitetura INSTANCIA de ListaErros (nao estatica):
 *       Main cria ListaErros, passa para Scanner(FileReader, ListaErros).
 *   - criaSimbolo() passa yyline/yycolumn em TODOS os tokens (Symbol.left/right).
 *       Isso e obrigatorio para que tleft, tright, cleft, cright etc.
 *       funcionem corretamente nas acoes do Parser.
 *   - Tres sobrecargas de defineErro() espelham as de ListaErros:
 *       (int, int, String)  <- erros semanticos diretos
 *       (int, int)          <- passo 1 do syntax_error()
 *       (String)            <- passo 2: preenche texto pendente
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
    private ListaErros listaErros;

    /* Construtor principal: recebe a ListaErros criada em Main */
    public Scanner(java.io.FileReader in, ListaErros listaErros) {
        this(in);
        this.listaErros = listaErros;
    }

    public ListaErros getListaErros() { return listaErros; }

    /* Wrappers que delegam a ListaErros */
    public void defineErro(int linha, int coluna, String texto) {
        listaErros.defineErro(linha, coluna, texto);
    }

    public void defineErro(int linha, int coluna) {
        listaErros.defineErro(linha, coluna);
    }

    public void defineErro(String texto) {
        listaErros.defineErro(texto);
    }

    /* Fabrica de Symbol com localizacao embutida.
     * Symbol.left = yyline (0-based), Symbol.right = yycolumn (0-based).
     * Necessario para cleft/cright, tleft/tright, idxleft/idxright no Parser. */
    private Symbol criaSimbolo(int code, Object value) {
        return new Symbol(code, yyline, yycolumn, value);
    }

    private Symbol criaSimbolo(int code) {
        return new Symbol(code, yyline, yycolumn, null);
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

/* Relacionais ANTES de "=" para que == nao vire IGUAL+IGUAL */
{opRelacional} {
    return criaSimbolo(sym.OP_RELACIONAL, yytext());
}

/* Decimal ANTES de digitos (maximal munch: 3.5 nao pode ser 3 e .5) */
{decimal} {
    return criaSimbolo(sym.NUMBER, Double.valueOf(Double.parseDouble(yytext())));
}

{digitos} {
    return criaSimbolo(sym.NUMBER, Double.valueOf(Double.parseDouble(yytext())));
}

"+"  { return criaSimbolo(sym.MAIS);    }
"-"  { return criaSimbolo(sym.MENOS);   }
"*"  { return criaSimbolo(sym.MULT);    }
"/"  { return criaSimbolo(sym.DIV);     }
"%"  { return criaSimbolo(sym.MOD);     }
"="  { return criaSimbolo(sym.IGUAL);   }
";"  { return criaSimbolo(sym.PTVIRG);       }
"("  { return criaSimbolo(sym.ABRE_PARENT);  }
")"  { return criaSimbolo(sym.FECHA_PARENT); }
"{"  { return criaSimbolo(sym.ABRE_CHAVE);   }
"}"  { return criaSimbolo(sym.FECHA_CHAVE);  }
"["  { return criaSimbolo(sym.ABRE_COLCH);   }
"]"  { return criaSimbolo(sym.FECHA_COLCH);  }
"."  { return criaSimbolo(sym.PTO);          }
","  { return criaSimbolo(sym.VIRG);         }

/* Palavras reservadas ANTES de {ident} */
"program" { return criaSimbolo(sym.KW_PROGRAM); }
"if"      { return criaSimbolo(sym.KW_IF);      }
"else"    { return criaSimbolo(sym.KW_ELSE);    }
"while"   { return criaSimbolo(sym.KW_WHILE);   }
"for"     { return criaSimbolo(sym.KW_FOR);     }
"do"      { return criaSimbolo(sym.KW_DO);      }
"true"    { return criaSimbolo(sym.KW_TRUE);    }
"false"   { return criaSimbolo(sym.KW_FALSE);   }

{ident} { return criaSimbolo(sym.IDENT, yytext()); }

{espaco} { /* despreza */ }

/* Caractere invalido: erro lexico via defineErro(int,int,String) direto */
[^] {
    defineErro(yyline, yycolumn,
        "Lexico - simbolo desconhecido: '" + yytext() + "'");
}
