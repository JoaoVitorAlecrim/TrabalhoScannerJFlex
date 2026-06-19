/* ex3Slide13.flex - Exercicio 3 da Aula 13 (versao com bug)
 *
 * Adiciona palavras reservadas: if, while
 *
 * ATENCAO: esta versao tem um bug intencional!
 * A regra {ident} aparece ANTES de {kw_if} e {kw_while}.
 * Como JFlex usa a primeira regra que casar em caso de empate de tamanho,
 * "if" e "while" serao reconhecidos como IDENT em vez de IF/WHILE.
 *
 * Veja ex3Fixed_Slide13.flex para a versao corrigida.
 *
 * Entrada de teste (teste_ex3Slide13.txt):
 *   abc123   -> IDENT (correto)
 *   if03     -> IDENT (correto: if03 e identificador, nao palavra reservada)
 *   if       -> IDENT (ERRADO: deveria ser IF)
 *   123while -> INTEIRO(123) + IDENT(while) (ERRADO: "while" deveria ser WHILE)
 *
 * Explicacao do bug: quando o scanner le "if", tanto {ident} quanto {kw_if}
 * casam com o mesmo comprimento (2 caracteres). O JFlex escolhe a PRIMEIRA
 * regra na ordem do arquivo. Como {ident} vem antes de {kw_if}, "if" vira IDENT.
 *
 * Correcao: mover {kw_if} e {kw_while} para ANTES de {ident}.
 */

import java_cup.runtime.Symbol;

class sym {
    public static final int EOF    = -1;
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

/* BUG: {ident} antes das palavras reservadas - "if" e "while" viram IDENT */
{ident} {
    return new Symbol(sym.IDENT, yyline, yycolumn, yytext());
}

{inteiro} {
    int aux = Integer.parseInt(yytext());
    return new Symbol(sym.INTEIRO, yyline, yycolumn, new Integer(aux));
}

{kw_if} {
    return new Symbol(sym.IF, yyline, yycolumn, yytext());
}

{kw_while} {
    return new Symbol(sym.WHILE, yyline, yycolumn, yytext());
}

/* Espacos: ignora */
[ \t\r\n]+ { /* ignora */ }

/* Caractere invalido */
.|\n {
    return new Symbol(sym.EOF, yyline, yycolumn, yytext());
}
