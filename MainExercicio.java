import java.io.*;

/**
 * Main para os exercicios 1, 2 e 3 do slide 14.
 * Le expressoes da entrada padrao (teclado ou redirecionamento).
 *
 * Uso:
 *   java MainExercicio              <- digita na mao
 *   java MainExercicio < teste.txt  <- redireciona arquivo
 */
public class MainExercicio {
    public static void main(String[] args) {
        try {
            Scanner sc;
            if (args.length > 0) {
                sc = new Scanner(new FileInputStream(args[0]));
            } else {
                sc = new Scanner(System.in);
            }
            parser p = new parser(sc);
            p.parse();
            System.out.println("Analise sintatica concluida com sucesso.");
        } catch (Exception e) {
            System.err.println("Erro: " + e.getMessage());
        }
    }
}
