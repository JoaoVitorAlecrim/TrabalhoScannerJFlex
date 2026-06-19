import java.io.*;

/**
 * Main.java - Roteiro 2: IDENT e Designator
 *
 * Le o arquivo de expressoes (args[0] ou "entrada.txt").
 * Os VALORES das variaveis (designators) sao solicitados ao usuario via teclado
 * diretamente pelo parser, assim que cada designator e reconhecido.
 */
class Main {
    public static void main(String[] args) throws Exception {
        String arquivo = (args.length > 0) ? args[0] : "entrada.txt";
        Scanner scanner = new Scanner(new FileReader(arquivo));
        parser p = new parser(scanner);
        try {
            p.parse();
            System.out.println("Arquivo sem erros de sintaxe!");
        } catch (Exception e) {
            System.out.println("Erro de sintaxe: " + e);
        }
    }
}
