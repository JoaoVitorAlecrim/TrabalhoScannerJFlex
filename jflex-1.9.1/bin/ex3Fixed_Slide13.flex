/* ex3Fixed_Slide13.flex - Exercicio 3 da Aula 13 (versao corrigida)
 *
 * Correcao: regras de palavras reservadas aparecem ANTES de {ident}.
 * Assim, quando o scanner ve "if" ou "while", a regra do keyword
 * vence sobre a regra do identificador (mesmo comprimento, primeira regra ganha).
 *
 * Nota: "if03" ainda e IDENT, pois {ident} casa 5 chars vs {kw_if} casa 2.
 * JFlex sempre prefere o casamento MAIS LONGO, independente da ordem.
 */

import java_cup.runtime.Symbol;

class sym {
    public static final int EOF     = -1;
    public static final int INTEIRO =  1;
    public static final int IDENT   =  2;
    public static final int IF      =  3;
    public static final int WHILE   =  4;
}

%%

%class Scanner
%unicode
%cup
%line
%column
%debug

digito   = [0-9]
letra    = [a-zA-Z]
ident    = {letra}({letra}|{digito})*
inteiro  = {digito}+
kw_if    = "if"
kw_while = "while"

%%

/* CORRETO: palavras reservadas ANTES de {ident} */
{kw_if} {
    return new Symbol(sym.IF, yyline, yycolumn, yytext());
}

{kw_while} {
    return new Symbol(sym.WHILE, yyline, yycolumn, yytext());
}

{ident} {
    return new Symbol(sym.IDENT, yyline, yycolumn, yytext());
}

{inteiro} {
    int aux = Integer.parseInt(yytext());
    return new Symbol(sym.INTEIRO, yyline, yycolumn, new Integer(aux));
}

/* Espacos: ignora */
[ \t\r\n]+ { /* ignora */ }

/* Caractere invalido */
.|\n {
    return new Symbol(sym.EOF, yyline, yycolumn, yytext());
}
