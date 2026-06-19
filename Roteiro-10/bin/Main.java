import java.io.*;

class Main {
    public static void main(String[] args) throws Exception {
        String arquivo = (args.length > 0) ? args[0] : "entrada.txt";

        /* Cria a lista de erros e a injeta no Scanner.
         * O Scanner propaga ao Parser via getScanner()/criaSimbolo().
         * Ao final, imprimimos TODOS os erros de uma vez — filosofia de compiladores. */
        ListaErros listaErros = new ListaErros();
        Scanner scanner = new Scanner(new FileReader(arquivo), listaErros);
        parser p = new parser(scanner);

        try {
            p.parse();
        } catch (Exception e) {
            listaErros.defineErro(0, 0, "Erro fatal de sintaxe: " + e.getMessage());
        }

        p.imprimeRelatorio();

        if (!listaErros.hasErros()) {
            System.out.println("Arquivo sem erros!");
        } else {
            System.out.println("\nErros encontrados:");
            listaErros.dump();
        }
    }
}
