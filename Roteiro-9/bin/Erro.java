/* Erro.java - Roteiro 9: Registro de Erros com Localizacao
 *
 * Representa um unico erro coletado durante a analise.
 * Armazena mensagem, linha e coluna (localizacao opcional).
 * Erros semanticos nao tem localizacao exata (linha=0, coluna=0).
 * Erros lexicos tem linha e coluna do caractere invalido.
 */
public class Erro {
    private String mensagem;
    private int linha;
    private int coluna;

    public Erro(String mensagem, int linha, int coluna) {
        this.mensagem = mensagem;
        this.linha    = linha;
        this.coluna   = coluna;
    }

    public Erro(String mensagem) {
        this(mensagem, 0, 0);
    }

    @Override
    public String toString() {
        if (linha > 0) {
            return "[linha " + linha + ", coluna " + coluna + "] " + mensagem;
        }
        return mensagem;
    }
}
