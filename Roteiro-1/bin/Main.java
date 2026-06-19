import java.io.*;

/**
 * Main.java - Roteiro 1
 *
 * Une o Scanner (Analisador Lexico) e o Parser (Analisador Sintatico).
 * Aceita leitura via arquivo (args[0]) ou via teclado (System.in).
 *
 * Uso:
 *   java -cp ".;java-cup-11b-runtime.jar" Main entrada.txt
 *   java -cp ".;java-cup-11b-runtime.jar" Main          (teclado)
 */
class Main {
    public static void main(String[] args) throws Exception {
        Scanner scanner;
        if (args.length > 0) {
            scanner = new Scanner(new FileReader(args[0]));
        } else {
            scanner = new Scanner(System.in);
        }

        parser p = new parser(scanner);
        try {
            p.parse();
            System.out.println("Arquivo sem erros de sintaxe!");
        } catch (Exception e) {
            System.out.println("Erro de sintaxe: " + e);
        }
    }
}
