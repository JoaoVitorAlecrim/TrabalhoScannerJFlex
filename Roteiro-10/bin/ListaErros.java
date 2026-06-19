/* ListaErros.java - Roteiro 10: Tratamento de Erros — Especial error
 *
 * Colecao de erros instanciada em Main e passada ao Scanner via construtor.
 * O Scanner repassa ao Parser (via getListaErros()).
 *
 * Tres sobrecargas de defineErro():
 *   (int, int, String) -> erro semantico direto (linha/col + texto de uma vez)
 *   (int, int)         -> passo 1 do syntax_error(): so a posicao, texto = null
 *   (String)           -> passo 2: preenche o texto do primeiro erro sem texto
 *
 * O par (int,int) + (String) implementa o mecanismo de dois passos do error:
 *   syntax_error() registra a posicao; a acao da producao preenche a mensagem.
 */
import java.util.ArrayList;
import java.util.List;

public class ListaErros {
    private List<Erro> erros;

    public ListaErros() {
        this.erros = new ArrayList<Erro>();
    }

    public void defineErro(int linha, int coluna, String texto) {
        erros.add(new Erro(linha, coluna, texto));
    }

    public void defineErro(int linha, int coluna) {
        erros.add(new Erro(linha, coluna));
    }

    /* Preenche o texto do primeiro Erro que ainda esta sem mensagem.
     * Chamado depois do syntax_error() ter registrado posicao sem texto. */
    public void defineErro(String texto) {
        for (Erro e : erros) {
            if (e.getTexto() == null) {
                e.setTexto(texto);
                return;
            }
        }
    }

    public void dump() {
        for (Erro e : erros) {
            e.imprime();
        }
    }

    public boolean hasErros() {
        return erros.size() > 0;
    }
}
