%cup
%cup
%class Scanner
%public
%unicode
%line
%column
%type java_cup.runtime.Symbol

%{
    import java_cup.runtime.Symbol;

    /* Metodo auxiliar para imprimir no formato pedido pelo trabalho (desativado) */
    private void imprimirToken(String tipo, String valor) {
        // desativado
    }

    private void imprimirErro(String mensagem, String valor) {
        System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro lexico: " + mensagem + " -> " + valor);
    }

    private void imprimirErroSimples(String mensagem) {
        System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro lexico: " + mensagem);
    }

    private int commentStartLine = 0;
    private int commentStartColumn = 0;
    private int commentDepth = 0;
    private boolean nestedCommentDetected = false;
%}

/* ========= MACROS ========= */

LETRA      = [a-zA-Z]
DIGITO     = [0-9]
HEXDIG     = [0-9A-Fa-f]

IDENT      = {LETRA}({LETRA}|{DIGITO}|_)*
INT        = 0|[1-9]{DIGITO}*
FLOAT      = {DIGITO}+"."{DIGITO}+
HEX        = 0x{HEXDIG}+
CHARCONST  = \'([^\\\'\r\n]|\\[btnrf\'\"\\])\'
BRANCO     = [ \t\r\n\f]+

COMMENT_TEXT = [^*/\r\n]+

%%

/* ========= REGRAS ========= */

{BRANCO} ;

"/*" {
    commentStartLine = yyline + 1;
    commentStartColumn = yycolumn + 1;
    commentDepth = 1;
    nestedCommentDetected = false;
    yybegin(COMMENT);
}

"program" { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.PROGRAM, yytext()); }
"final"   { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.FINAL, yytext()); }
"class"   { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.CLASS, yytext()); }
"void"    { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.VOID, yytext()); }
"if"      { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.IF, yytext()); }
"else"    { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.ELSE, yytext()); }
"while"   { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.WHILE, yytext()); }
"return"  { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.RETURN, yytext()); }
"read"    { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.READ, yytext()); }
"print"   { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.PRINT, yytext()); }
"new"     { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.NEW, yytext()); }

"int"     { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.INT, yytext()); }
"float"   { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.FLOAT, yytext()); }
"char"    { /*imprimirToken("palavra reservada", yytext());*/ return new Symbol(sym.CHAR, yytext()); }

"0X"{HEXDIG}+ { imprimirErro("hexadecimal invalido", yytext()); return new Symbol(sym.ERROR, yytext()); }
"0x"          { imprimirErro("hexadecimal incompleto", yytext()); return new Symbol(sym.ERROR, yytext()); }
{DIGITO}+"."  { imprimirErro("numero real invalido", yytext()); return new Symbol(sym.ERROR, yytext()); }
"."{DIGITO}+  { imprimirErro("numero real invalido", yytext()); return new Symbol(sym.ERROR, yytext()); }

{FLOAT} { /*imprimirToken("numero real", yytext());*/ return new Symbol(sym.FLOATNUM, yytext()); }
{HEX}   { /*imprimirToken("numero hexadecimal", yytext());*/ return new Symbol(sym.HEXNUM, yytext()); }
{INT}   { /*imprimirToken("numero inteiro", yytext());*/ return new Symbol(sym.INTNUM, yytext()); }

{CHARCONST} { /*imprimirToken("charConst", yytext());*/ return new Symbol(sym.CHARCONST, yytext()); }

{IDENT} { /*imprimirToken("identificador", yytext());*/ return new Symbol(sym.IDENT, yytext()); }

/* relational operators */
"==" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.EQEQ, yytext()); }
"!=" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.NEQ, yytext()); }
">=" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.GE, yytext()); }
"<=" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.LE, yytext()); }
"="  { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.ASSIGN, yytext()); }
">"  { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.GT, yytext()); }
"<"  { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.LT, yytext()); }

/* arithmetic operators */
"+" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.PLUS, yytext()); }
"-" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.MINUS, yytext()); }
"*" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.TIMES, yytext()); }
"/" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.DIV, yytext()); }
"%" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.MOD, yytext()); }

/* delimiters */
"{" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.LBRACE, yytext()); }
"}" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.RBRACE, yytext()); }
"(" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.LPAREN, yytext()); }
")" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.RPAREN, yytext()); }
"[" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.LBRACK, yytext()); }
"]" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.RBRACK, yytext()); }
";" { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.SEMI, yytext()); }
"," { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.COMMA, yytext()); }
"." { /*imprimirToken("simbolo", yytext());*/ return new Symbol(sym.DOT, yytext()); }

/* generic lexical error */
. { System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro lexico: " + yytext()); return new Symbol(sym.ERROR, yytext()); }

/* ========= ESTADO COMMENT ========= */

<COMMENT>"/*" {
    commentDepth++;

    if (!nestedCommentDetected) {
        nestedCommentDetected = true;
        imprimirErroSimples("comentario aninhado nao permitido");
    }
}

<COMMENT>"*/" {
    commentDepth--;

    if (commentDepth == 0) {
        yybegin(YYINITIAL);
    }
}

<COMMENT>{COMMENT_TEXT} { /* ignora */ }

<COMMENT>"*" { /* ignora */ }
<COMMENT>"/" { /* ignora */ }

<COMMENT>\r\n { /* ignora */ }
<COMMENT>\r   { /* ignora */ }
<COMMENT>\n   { /* ignora */ }

<COMMENT><<EOF>> {
    System.out.println("[" + commentStartLine + "," + commentStartColumn + "] erro lexico: comentario nao fechado");
    return YYEOF;
}
.                         { System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro léxico: " + yytext()); return new Symbol(sym.ERROR, yytext()); }