import java.io.FileReader;

public class Main {
    public static void main(String[] args) {
        try {
            String nomeArquivo = args.length > 0 ? args[0] : "teste_completo.txt";

            Scanner scanner = new Scanner(new FileReader(nomeArquivo));

            Parser parser = new Parser(scanner);
            parser.parse();

            System.out.println("Parsing finished.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}