/* scanner1_cup.flex - Adaptado para trabalhar com JCup */

import java_cup.runtime.Symbol;

%%

%cup
%public
%unicode
%line
%column
%class Scanner

%state COMMENT

%{
    /* Controle de comentario aninhado */
    private int commentStartLine   = 0;
    private int commentStartColumn = 0;
    private int commentDepth       = 0;
    private boolean nestedCommentDetected = false;
%}

/* ========= MACROS ========= */

LETRA        = [a-zA-Z]
DIGITO       = [0-9]
HEXDIG       = [0-9A-Fa-f]

IDENT        = {LETRA}({LETRA}|{DIGITO}|_)*
INT_LIT      = 0|[1-9]{DIGITO}*
FLOAT_LIT    = {DIGITO}+"."{DIGITO}+
HEX_LIT      = 0x{HEXDIG}+
CHARCONST    = \'([^\\\'\r\n]|\\[btnrf\'\"\\])\'
BRANCO       = [ \t\r\n\f]+

COMMENT_TEXT = [^*/\r\n]+

%%

/* ========= REGRAS ========= */

/* Espacos em branco: ignora, sem retorno */
{BRANCO} { /* ignora */ }

/* ---------- Inicio de comentario ---------- */
"/*" {
    commentStartLine   = yyline + 1;
    commentStartColumn = yycolumn + 1;
    commentDepth       = 1;
    nestedCommentDetected = false;
    yybegin(COMMENT);
}

/* ---------- Palavras reservadas ---------- */
"program" { return new Symbol(sym.PROGRAM, yyline, yycolumn, yytext()); }
"final"   { return new Symbol(sym.FINAL,   yyline, yycolumn, yytext()); }
"class"   { return new Symbol(sym.CLASS,   yyline, yycolumn, yytext()); }
"void"    { return new Symbol(sym.VOID,    yyline, yycolumn, yytext()); }
"if"      { return new Symbol(sym.IF,      yyline, yycolumn, yytext()); }
"else"    { return new Symbol(sym.ELSE,    yyline, yycolumn, yytext()); }
"while"   { return new Symbol(sym.WHILE,   yyline, yycolumn, yytext()); }
"return"  { return new Symbol(sym.RETURN,  yyline, yycolumn, yytext()); }
"read"    { return new Symbol(sym.READ,    yyline, yycolumn, yytext()); }
"print"   { return new Symbol(sym.PRINT,   yyline, yycolumn, yytext()); }
"new"     { return new Symbol(sym.NEW,     yyline, yycolumn, yytext()); }
"int"     { return new Symbol(sym.INT,     yyline, yycolumn, yytext()); }
"float"   { return new Symbol(sym.FLOAT,   yyline, yycolumn, yytext()); }
"char"    { return new Symbol(sym.CHAR,    yyline, yycolumn, yytext()); }

/* ---------- Casos invalidos (erro lexico) ---------- */
"0X"{HEXDIG}+ {
    System.out.println("[" + (yyline+1) + "," + (yycolumn+1) + "] erro lexico: hexadecimal invalido -> " + yytext());
}
"0x" {
    System.out.println("[" + (yyline+1) + "," + (yycolumn+1) + "] erro lexico: hexadecimal incompleto -> " + yytext());
}
{DIGITO}+"." {
    System.out.println("[" + (yyline+1) + "," + (yycolumn+1) + "] erro lexico: numero real invalido -> " + yytext());
}
"."{DIGITO}+ {
    System.out.println("[" + (yyline+1) + "," + (yycolumn+1) + "] erro lexico: numero real invalido -> " + yytext());
}

/* ---------- Numeros ---------- */
{FLOAT_LIT}  { return new Symbol(sym.NUM_REAL, yyline, yycolumn, Double.parseDouble(yytext())); }
{HEX_LIT}    { return new Symbol(sym.NUM_HEX,  yyline, yycolumn, yytext()); }
{INT_LIT}    { return new Symbol(sym.NUM_INT,  yyline, yycolumn, Integer.parseInt(yytext())); }

/* ---------- Constante caractere ---------- */
{CHARCONST}  { return new Symbol(sym.CHAR_CONST, yyline, yycolumn, yytext()); }

/* ---------- Identificadores ---------- */
{IDENT}      { return new Symbol(sym.IDENT, yyline, yycolumn, yytext()); }

/* ---------- Operadores relacionais ---------- */
"==" { return new Symbol(sym.EQ_EQ, yyline, yycolumn, yytext()); }
"!=" { return new Symbol(sym.NEQ,   yyline, yycolumn, yytext()); }
">=" { return new Symbol(sym.GEQ,   yyline, yycolumn, yytext()); }
"<=" { return new Symbol(sym.LEQ,   yyline, yycolumn, yytext()); }
"="  { return new Symbol(sym.EQ,    yyline, yycolumn, yytext()); }
">"  { return new Symbol(sym.GT,    yyline, yycolumn, yytext()); }
"<"  { return new Symbol(sym.LT,    yyline, yycolumn, yytext()); }

/* ---------- Operadores aritmeticos ---------- */
"+" { return new Symbol(sym.PLUS,  yyline, yycolumn, yytext()); }
"-" { return new Symbol(sym.MINUS, yyline, yycolumn, yytext()); }
"*" { return new Symbol(sym.TIMES, yyline, yycolumn, yytext()); }
"/" { return new Symbol(sym.DIV,   yyline, yycolumn, yytext()); }
"%" { return new Symbol(sym.MOD,   yyline, yycolumn, yytext()); }

/* ---------- Delimitadores ---------- */
"{" { return new Symbol(sym.LBRACE,    yyline, yycolumn, yytext()); }
"}" { return new Symbol(sym.RBRACE,    yyline, yycolumn, yytext()); }
"(" { return new Symbol(sym.LPAREN,    yyline, yycolumn, yytext()); }
")" { return new Symbol(sym.RPAREN,    yyline, yycolumn, yytext()); }
"[" { return new Symbol(sym.LBRACKET,  yyline, yycolumn, yytext()); }
"]" { return new Symbol(sym.RBRACKET,  yyline, yycolumn, yytext()); }
";" { return new Symbol(sym.SEMICOLON, yyline, yycolumn, yytext()); }
"," { return new Symbol(sym.COMMA,     yyline, yycolumn, yytext()); }
"." { return new Symbol(sym.DOT,       yyline, yycolumn, yytext()); }

/* ---------- Erro lexico generico ---------- */
. {
    System.out.println("[" + (yyline+1) + "," + (yycolumn+1) + "] erro lexico: " + yytext());
}

/* ========= ESTADO COMMENT ========= */

<COMMENT>"/*" {
    commentDepth++;
    if (!nestedCommentDetected) {
        nestedCommentDetected = true;
        System.out.println("[" + (yyline+1) + "," + (yycolumn+1) + "] erro lexico: comentario aninhado nao permitido");
    }
}

<COMMENT>"*/" {
    commentDepth--;
    if (commentDepth == 0) {
        yybegin(YYINITIAL);
    }
}

<COMMENT>{COMMENT_TEXT} { /* ignora */ }
<COMMENT>"*"            { /* ignora */ }
<COMMENT>"/"            { /* ignora */ }
<COMMENT>\r\n           { /* ignora */ }
<COMMENT>\r             { /* ignora */ }
<COMMENT>\n             { /* ignora */ }

<COMMENT><<EOF>> {
    System.out.println("[" + commentStartLine + "," + commentStartColumn + "] erro lexico: comentario nao fechado");
    return new Symbol(sym.EOF, yyline, yycolumn, null);
}
