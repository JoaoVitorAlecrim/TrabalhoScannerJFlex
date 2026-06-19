/* Scanner.flex - Roteiro 2: IDENT e Designator
 *
 * Novidades em relacao ao Roteiro 1:
 *   - Macro e regra para IDENT (identificadores: variaveis, nomes de classe...)
 *   - Token PTO       (ponto para acesso a atributos: pessoa.idade)
 *   - Token ABRE_COLCH / FECHA_COLCH (colchetes para vetores: vetor[i])
 *   - Token ABRE_CHAVE / FECHA_CHAVE (chaves, para uso futuro)
 *   - Token VIRG      (virgula)
 *   - Token OP_RELACIONAL (==, !=, >=, <=, >, <)
 *   - Token KW_IF     (palavra reservada — DEVE vir ANTES da regra de ident)
 *
 * REGRA DE OURO: a regra {ident} DEVE vir APOS todas as keywords.
 * Se vier antes, "if", "while", etc. serao reconhecidos como IDENT.
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
ident        = {letra}({letra}|{digito}|_)*
opRelacional = ">="|"<="|"=="|"!="|">"|"<"
fimLinha     = \r|\n|\r\n
espaco       = {fimLinha} | [ \t\f]

%%

/* --- Operadores relacionais (antes de > e < isolados, senao nao bate >= e <=) --- */
{opRelacional} {
    return new Symbol(sym.OP_RELACIONAL, yytext());
}

/* --- Numeros --- */
{digitos} {
    double val = Double.parseDouble(yytext());
    return new Symbol(sym.NUMBER, Double.valueOf(val));
}

/* --- Operadores aritmeticos --- */
"+"  { return new Symbol(sym.MAIS);    }
"-"  { return new Symbol(sym.MENOS);   }
"*"  { return new Symbol(sym.MULT);    }
"/"  { return new Symbol(sym.DIV);     }
"%"  { return new Symbol(sym.MOD);     }

/* --- Delimitadores --- */
";"  { return new Symbol(sym.PTVIRG);       }
"("  { return new Symbol(sym.ABRE_PARENT);  }
")"  { return new Symbol(sym.FECHA_PARENT); }
"{"  { return new Symbol(sym.ABRE_CHAVE);   }
"}"  { return new Symbol(sym.FECHA_CHAVE);  }
"["  { return new Symbol(sym.ABRE_COLCH);   }
"]"  { return new Symbol(sym.FECHA_COLCH);  }
"."  { return new Symbol(sym.PTO);          }
","  { return new Symbol(sym.VIRG);         }

/* --- Palavras reservadas (DEVEM vir antes de {ident}) --- */
"if" { return new Symbol(sym.KW_IF); }

/* --- Identificadores (SEMPRE apos as keywords) --- */
{ident} { return new Symbol(sym.IDENT, yytext()); }

/* --- Espacos: ignora --- */
{espaco} { /* despreza */ }

/* --- Caracter invalido --- */
[^] {
    System.err.println("Erro lexico na linha " + (yyline + 1) +
                       ", coluna " + (yycolumn + 1) +
                       ": caractere invalido '" + yytext() + "'");
}
