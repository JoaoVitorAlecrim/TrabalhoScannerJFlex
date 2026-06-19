/* ListaErro.java - Roteiro 9: Registro de Erros com Localizacao
 *
 * Lista estatica de erros coletados durante analise lexica e semantica.
 * Estatica para ser acessivel tanto do Scanner quanto do Parser sem
 * precisar passar referencia entre eles.
 *
 * Uso:
 *   ListaErro.adicionar("mensagem", linha, coluna);  <- com localizacao
 *   ListaErro.adicionar("mensagem");                  <- sem localizacao
 *   ListaErro.imprimir();                             <- ao final
 *   ListaErro.temErros();                             <- boolean
 */
import java.util.ArrayList;

public class ListaErro {
    private static ArrayList<Erro> lista = new ArrayList<>();

    public static void adicionar(String mensagem, int linha, int coluna) {
        lista.add(new Erro(mensagem, linha, coluna));
    }

    public static void adicionar(String mensagem) {
        lista.add(new Erro(mensagem));
    }

    public static void imprimir() {
        if (lista.isEmpty()) {
            System.out.println("Nenhum erro encontrado.");
        } else {
            System.out.println("\n=== Lista de Erros ===");
            for (Erro e : lista) {
                System.out.println("  " + e);
            }
            System.out.println("Total: " + lista.size() + " erro(s) encontrado(s)");
        }
    }

    public static boolean temErros() {
        return !lista.isEmpty();
    }
}
