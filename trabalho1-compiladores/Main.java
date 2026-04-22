import java.io.FileReader;

public class Main {
    public static void main(String[] args) {
        try {
            /*
             * Se o usuário passar um nome de arquivo, usa esse arquivo.
             * Caso contrário, usa "teste_completo.txt" como padrão.
             */
            String nomeArquivo;
            if (args.length > 0) {
                nomeArquivo = args[0];
            } else {
                nomeArquivo = "teste_completo.txt";
            }

            Scanner scanner = new Scanner(new FileReader(nomeArquivo));

            while (scanner.yylex() != -1) {
                // O scanner já imprime os tokens; não precisa fazer nada aqui.
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}