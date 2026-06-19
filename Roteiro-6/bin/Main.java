import java.io.*;

class Main {
    public static void main(String[] args) throws Exception {
        String arquivo = (args.length > 0) ? args[0] : "entrada.txt";
        Scanner scanner = new Scanner(new FileReader(arquivo));
        parser p = new parser(scanner);
        try {
            p.parse();
            p.imprimeRelatorio();
            System.out.println("Arquivo sem erros de sintaxe!");
        } catch (Exception e) {
            System.out.println("Erro de sintaxe: " + e);
        }
    }
}
