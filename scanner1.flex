/* Scanner1.flex */
%%

%standalone
%line
%column
%class Scanner
%state COMMENT

%{
    /* Metodo auxiliar para imprimir no formato pedido pelo trabalho */
    private void imprimirToken(String tipo, String valor) {
        System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] " + tipo + ": " + valor);
    }

    /* Metodo auxiliar para erro lexico com valor */
    private void imprimirErro(String mensagem, String valor) {
        System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro lexico: " + mensagem + " -> " + valor);
    }

    /* Metodo auxiliar para erro lexico simples */
    private void imprimirErroSimples(String mensagem) {
        System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro lexico: " + mensagem);
    }

    /* Controle de comentario */
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

/* Conteudo interno de comentario que nao inclui /, * ou quebra de linha */
COMMENT_TEXT = [^*/\r\n]+

%%

/* ========= REGRAS ========= */

/* Ignora espacos em branco */
{BRANCO} { /* nao imprime nada */ }

/* ---------- Inicio de comentario ---------- */
"/*" {
    commentStartLine = yyline + 1;
    commentStartColumn = yycolumn + 1;
    commentDepth = 1;
    nestedCommentDetected = false;
    yybegin(COMMENT);
}

/* ---------- Palavras reservadas ---------- */
"program" { imprimirToken("palavra reservada", yytext()); }
"final"   { imprimirToken("palavra reservada", yytext()); }
"class"   { imprimirToken("palavra reservada", yytext()); }
"void"    { imprimirToken("palavra reservada", yytext()); }
"if"      { imprimirToken("palavra reservada", yytext()); }
"else"    { imprimirToken("palavra reservada", yytext()); }
"while"   { imprimirToken("palavra reservada", yytext()); }
"return"  { imprimirToken("palavra reservada", yytext()); }
"read"    { imprimirToken("palavra reservada", yytext()); }
"print"   { imprimirToken("palavra reservada", yytext()); }
"new"     { imprimirToken("palavra reservada", yytext()); }
"int"     { imprimirToken("palavra reservada", yytext()); }
"float"   { imprimirToken("palavra reservada", yytext()); }
"char"    { imprimirToken("palavra reservada", yytext()); }

/* ---------- Casos invalidos especificos ---------- */
"0X"{HEXDIG}+ { imprimirErro("hexadecimal invalido", yytext()); }
"0x"          { imprimirErro("hexadecimal incompleto", yytext()); }
{DIGITO}+"."  { imprimirErro("numero real invalido", yytext()); }
"."{DIGITO}+  { imprimirErro("numero real invalido", yytext()); }

/* ---------- Numeros ---------- */
{FLOAT} { imprimirToken("numero real", yytext()); }
{HEX}   { imprimirToken("numero hexadecimal", yytext()); }
{INT}   { imprimirToken("numero inteiro", yytext()); }

/* ---------- Constante caractere ---------- */
{CHARCONST} { imprimirToken("charConst", yytext()); }

/* ---------- Identificadores ---------- */
{IDENT} { imprimirToken("identificador", yytext()); }

/* ---------- Operadores relacionais ---------- */
"==" { imprimirToken("simbolo", yytext()); }
"!=" { imprimirToken("simbolo", yytext()); }
">=" { imprimirToken("simbolo", yytext()); }
"<=" { imprimirToken("simbolo", yytext()); }
"="  { imprimirToken("simbolo", yytext()); }
">"  { imprimirToken("simbolo", yytext()); }
"<"  { imprimirToken("simbolo", yytext()); }

/* ---------- Operadores aritmeticos ---------- */
"+" { imprimirToken("simbolo", yytext()); }
"-" { imprimirToken("simbolo", yytext()); }
"*" { imprimirToken("simbolo", yytext()); }
"/" { imprimirToken("simbolo", yytext()); }
"%" { imprimirToken("simbolo", yytext()); }

/* ---------- Delimitadores ---------- */
"{" { imprimirToken("simbolo", yytext()); }
"}" { imprimirToken("simbolo", yytext()); }
"(" { imprimirToken("simbolo", yytext()); }
")" { imprimirToken("simbolo", yytext()); }
"[" { imprimirToken("simbolo", yytext()); }
"]" { imprimirToken("simbolo", yytext()); }
";" { imprimirToken("simbolo", yytext()); }
"," { imprimirToken("simbolo", yytext()); }
"." { imprimirToken("simbolo", yytext()); }

/* ---------- Erro lexico generico ---------- */
. { System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro lexico: " + yytext()); }

/* ========= ESTADO COMMENT ========= */

/* Novo comentario dentro de comentario */
<COMMENT>"/*" {
    commentDepth++;

    if (!nestedCommentDetected) {
        nestedCommentDetected = true;
        imprimirErroSimples("comentario aninhado nao permitido");
    }
}

/* Fecha um nivel de comentario */
<COMMENT>"*/" {
    commentDepth--;

    if (commentDepth == 0) {
        yybegin(YYINITIAL);
    }
}

/* Texto comum dentro do comentario */
<COMMENT>{COMMENT_TEXT} { /* ignora */ }

/* Caracteres * ou / soltos dentro do comentario */
<COMMENT>"*" { /* ignora */ }
<COMMENT>"/" { /* ignora */ }

/* Quebras de linha dentro do comentario */
<COMMENT>\r\n { /* ignora */ }
<COMMENT>\r   { /* ignora */ }
<COMMENT>\n   { /* ignora */ }

/* EOF dentro do comentario */
<COMMENT><<EOF>> {
    System.out.println("[" + commentStartLine + "," + commentStartColumn + "] erro lexico: comentario nao fechado");
    return YYEOF;
}