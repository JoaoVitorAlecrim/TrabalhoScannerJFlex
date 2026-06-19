import java.io.FileReader;

public class Main {
    public static void main(String[] args) throws Exception {
        String arquivo = (args.length > 0) ? args[0] : "entrada.txt";
        Scanner scanner = new Scanner(new FileReader(arquivo));
        parser p = new parser(scanner);
        p.parse();
        System.out.println("Analise sintatica concluida com sucesso.");
    }
}
