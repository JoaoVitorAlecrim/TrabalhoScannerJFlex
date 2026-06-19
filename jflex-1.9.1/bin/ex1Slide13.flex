/* ex1Slide13.flex - Exercicio 1 da Aula 13
 *
 * Modifica o scanner base para reconhecer tambem:
 *   - comentarioLinha  (// ate fim da linha)
 *   - espaco           (espacos, tabs, quebras de linha)
 */

import java_cup.runtime.Symbol;

class sym {
    public static final int EOF        = -1;
    public static final int INTEIRO    =  1;
    public static final int IDENT      =  2;
    public static final int COMENTARIO =  3;
    public static final int ESPACO     =  4;
}

%%

%class Scanner
%unicode
%cup
%line
%column
%debug

digito          = [0-9]
letra           = [a-zA-Z]
ident           = {letra}({letra}|{digito})*
inteiro         = {digito}+
fimDeLinha      = \r|\n|\r\n
charTexto       = [^\r\n]
espaco          = {fimDeLinha} | [ \t]
comentarioLinha = "//" {charTexto}* {fimDeLinha}

%%

{comentarioLinha} {
    return new Symbol(sym.COMENTARIO, yyline, yycolumn, yytext());
}

{espaco} {
    return new Symbol(sym.ESPACO, yyline, yycolumn, yytext());
}

{ident} {
    return new Symbol(sym.IDENT, yyline, yycolumn, yytext());
}

{inteiro} {
    int aux = Integer.parseInt(yytext());
    Symbol s = new Symbol(sym.INTEIRO, yyline, yycolumn, new Integer(aux));
    return s;
}

/* Caractere invalido */
.|\n {
    Symbol s = new Symbol(sym.EOF, yyline, yycolumn, yytext());
    return s;
}
