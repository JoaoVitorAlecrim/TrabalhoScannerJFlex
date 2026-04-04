import java.io.FileReader;

public class Main {
    public static void main(String[] args) {
        try {
            Scanner scanner = new Scanner(new FileReader("entrada.txt"));
            while (scanner.yylex() != -1) {
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
