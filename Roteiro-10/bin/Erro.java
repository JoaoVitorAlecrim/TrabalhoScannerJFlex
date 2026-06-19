/* Erro.java - Roteiro 10: Tratamento de Erros — Especial error
 *
 * Representa um unico erro coletado durante a analise.
 * Campos texto, getTexto() e setTexto() sao necessarios para o mecanismo
 * de dois passos usado pelo syntax_error():
 *   1. syntax_error()    -> defineErro(linha, coluna)     : cria Erro sem texto
 *   2. action {:....:}   -> defineErro(String texto)      : preenche o texto
 */
public class Erro {
    private int linha, coluna;
    private String texto;

    public Erro() {
        this.linha  = -1;
        this.coluna = -1;
        this.texto  = "";
    }

    public Erro(int linha, int coluna, String texto) {
        this.linha  = linha;
        this.coluna = coluna;
        this.texto  = texto;
    }

    /* Construtor sem texto — usado pelo syntax_error() para registrar posicao
     * antes de conhecer a mensagem. O texto sera preenchido depois via setTexto(). */
    public Erro(int linha, int coluna) {
        this.linha  = linha;
        this.coluna = coluna;
        this.texto  = null;
    }

    public void imprime() {
        String aux = "linha:" + this.linha + ", coluna:" + this.coluna + ", ";
        if (this.texto == null)
            aux += "erro indefinido!";
        else
            aux += this.texto;
        System.out.println(aux);
    }

    public String getTexto()            { return texto; }
    public void   setTexto(String texto){ this.texto = texto; }
}
