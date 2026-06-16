/* ex2Slide13.flex - Exercicio 2 da Aula 13
 *
 * Estende ex1Slide13.flex adicionando os operadores aritmeticos basicos:
 *   +, -, *, /
 *
 * Entrada de teste (teste_ex2Slide13.txt):
 *   abc123+ponto01 1A
 *   123abcd
 *   // linha comentada
 */

import java_cup.runtime.Symbol;

class sym {
    public static final int EOF        = -1;
    public static final int INTEIRO    =  1;
    public static final int IDENT      =  2;
    public static final int COMENTARIO =  3;
    public static final int ESPACO     =  4;
    public static final int MAIS       =  5;
    public static final int MENOS      =  6;
    public static final int VEZES      =  7;
    public static final int DIV        =  8;
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
    return new Symbol(sym.INTEIRO, yyline, yycolumn, new Integer(aux));
}

"+" { return new Symbol(sym.MAIS,  yyline, yycolumn, yytext()); }
"-" { return new Symbol(sym.MENOS, yyline, yycolumn, yytext()); }
"*" { return new Symbol(sym.VEZES, yyline, yycolumn, yytext()); }
"/" { return new Symbol(sym.DIV,   yyline, yycolumn, yytext()); }

/* Caractere invalido */
.|\n {
    return new Symbol(sym.EOF, yyline, yycolumn, yytext());
}
