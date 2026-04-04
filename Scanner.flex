%%

%class Scanner
%public
%unicode
%line
%column
%integer

%{
    private void imprimirToken(String tipo, String valor) {
        System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] " + tipo + ": " + valor);
    }
%}

DIGITO = [0-9]
LETRA = [a-zA-Z]
IDENT = {LETRA}({LETRA}|{DIGITO}|_)*
INT = {DIGITO}+
FLOAT = {DIGITO}+"."{DIGITO}+
HEX = 0x[0-9a-fA-F]+
ESPACO = [ \t\r\n]+

%%

{ESPACO}                  { }

"program"                 { imprimirToken("palavra reservada", yytext()); return 1; }
"final"                   { imprimirToken("palavra reservada", yytext()); return 1; }
"class"                   { imprimirToken("palavra reservada", yytext()); return 1; }
"void"                    { imprimirToken("palavra reservada", yytext()); return 1; }
"if"                      { imprimirToken("palavra reservada", yytext()); return 1; }
"else"                    { imprimirToken("palavra reservada", yytext()); return 1; }
"while"                   { imprimirToken("palavra reservada", yytext()); return 1; }
"return"                  { imprimirToken("palavra reservada", yytext()); return 1; }
"read"                    { imprimirToken("palavra reservada", yytext()); return 1; }
"print"                   { imprimirToken("palavra reservada", yytext()); return 1; }
"new"                     { imprimirToken("palavra reservada", yytext()); return 1; }

"int"                     { imprimirToken("palavra reservada", yytext()); return 1; }
"float"                   { imprimirToken("palavra reservada", yytext()); return 1; }
"char"                    { imprimirToken("palavra reservada", yytext()); return 1; }

"=="                      { imprimirToken("símbolo", yytext()); return 1; }
"!="                      { imprimirToken("símbolo", yytext()); return 1; }
">="                      { imprimirToken("símbolo", yytext()); return 1; }
"<="                      { imprimirToken("símbolo", yytext()); return 1; }
">"                       { imprimirToken("símbolo", yytext()); return 1; }
"<"                       { imprimirToken("símbolo", yytext()); return 1; }
"="                       { imprimirToken("símbolo", yytext()); return 1; }

"+"                       { imprimirToken("símbolo", yytext()); return 1; }
"-"                       { imprimirToken("símbolo", yytext()); return 1; }
"*"                       { imprimirToken("símbolo", yytext()); return 1; }
"/"                       { imprimirToken("símbolo", yytext()); return 1; }
"%"                       { imprimirToken("símbolo", yytext()); return 1; }

";"                       { imprimirToken("símbolo", yytext()); return 1; }
","                       { imprimirToken("símbolo", yytext()); return 1; }
"."                       { imprimirToken("símbolo", yytext()); return 1; }
"("                       { imprimirToken("símbolo", yytext()); return 1; }
")"                       { imprimirToken("símbolo", yytext()); return 1; }
"["                       { imprimirToken("símbolo", yytext()); return 1; }
"]"                       { imprimirToken("símbolo", yytext()); return 1; }
"{"                       { imprimirToken("símbolo", yytext()); return 1; }
"}"                       { imprimirToken("símbolo", yytext()); return 1; }

"0X"[0-9a-fA-F]+          { System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro léxico: hexadecimal inválido " + yytext()); return 1; }

"0x"                      { System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro léxico: hexadecimal incompleto " + yytext()); return 1; }

{DIGITO}+"."              { System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro léxico: número real inválido " + yytext()); return 1; }

"."{DIGITO}+              { System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro léxico: número real inválido " + yytext()); return 1; }

{FLOAT}                   { imprimirToken("número real", yytext()); return 1; }
{HEX}                     { imprimirToken("número hexadecimal", yytext()); return 1; }
{INT}                     { imprimirToken("número inteiro", yytext()); return 1; }



{IDENT}                   { imprimirToken("identificador", yytext()); return 1; }

"/*"([^*]|\*+[^*/])*\*+"/" { }

.                         { System.out.println("[" + (yyline + 1) + "," + (yycolumn + 1) + "] erro léxico: " + yytext()); return 1; }