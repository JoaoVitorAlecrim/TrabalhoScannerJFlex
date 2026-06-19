import java.io.*;

/**
 * Main_esquerda.java - Roteiro 1, Atividade 3
 *
 * Ponto de entrada para o parser com RECURSIVIDADE A ESQUERDA em term.
 * Usa parser_esquerda (gerado de Parser_esquerda.cup) ao inves de parser.
 */
class Main_esquerda {
    public static void main(String[] args) throws Exception {
        Scanner scanner;
        if (args.length > 0) {
            scanner = new Scanner(new FileReader(args[0]));
        } else {
            scanner = new Scanner(System.in);
        }

        parser_esquerda p = new parser_esquerda(scanner);
        try {
            p.parse();
            System.out.println("Arquivo sem erros de sintaxe!");
        } catch (Exception e) {
            System.out.println("Erro de sintaxe: " + e);
        }
    }
}
