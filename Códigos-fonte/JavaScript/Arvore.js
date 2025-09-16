/*A classe ‘No’ cria a estrutura básica da árvore. 
O construtor inicializa o nó com um valor, armazena esse valor, e inicia os ponteiros dos filhos da esquerda e da direita com valor ‘null’. */ 
class No {
    constructor(valor) {
        this.valor = valor;
        this.esquerda = null;
        this.direita = null;
    }
}

/*Definindo a árvore binária e inicializando o valor da raíz (nó inicial) como ‘null’.*/
class ArvoreBinaria {
    constructor() {
        this.raiz = null;
    }

    /*O método ‘inserir()’ cria um novo nó, e, caso não exista uma raíz, esse nó passará a ser a raíz. 
    Caso contrário, se já existir uma raíz, chama o método privado “#inserirNo”.*/
    inserir(valor) {
        const novoNo = new No(valor);

        if (this.raiz === null) {
            this.raiz = novoNo;
        } else {
            this.#inserirNo(this.raiz, novoNo);
        }
    }
    /*O método “#inserirNo” aplica as regras da árvore binária de busca, então, se o valor do novo nó for maior que o nó anterior, 
    é criado pela direita e, caso seja menor, é criado à esquerda. Isso só ocorre se esse nó já não tiver um filho (no.esquerda === null),
    caso já tenha um filho, esse método é chamado recursivamente até encontrar um espaço livre.
*/
    #inserirNo(no, novoNo) {
        if (novoNo.valor < no.valor) {
            if (no.esquerda === null) {
                no.esquerda = novoNo;
            } else {
                this.#inserirNo(no.esquerda, novoNo);
            }
        } else {
            if (no.direita === null) {
                no.direita = novoNo;
            } else {
                this.#inserirNo(no.direita, novoNo);
            }
        }
    }

    /*Agora, o método “buscar()”, chama o método auxiliar privado ‘#buscarNo’, que por sua vez,
     funciona como se percorresse cada “galho” da árvore para encontrar determinado valor.*/
    buscar(valor) {
        return this.#buscarNo(this.raiz, valor);
    }

    #buscarNo(no, valor) {
        if (no === null) return false;
        if (valor === no.valor) return true;
        if (valor < no.valor) return this.#buscarNo(no.esquerda, valor);
        return this.#buscarNo(no.direita, valor);
    }

    /*O método “emOrdem()” percorre a árvore em ordem crescente.*/
    emOrdem(no = this.raiz) {
        if (no !== null) {
            this.emOrdem(no.esquerda);
            console.log(no.valor);
            this.emOrdem(no.direita);
        }
    }

    /*Já o método “preOrdem()”, obtém a raíz antes dos filhos, sendo útil para copiar ou salvar a árvore.*/
    preOrdem(no = this.raiz) {
        if (no !== null) {
            console.log(no.valor);
            this.preOrdem(no.esquerda);
            this.preOrdem(no.direita);
        }
    }

    /*Já o “posOrdem()” visita os filhos antes da raíz, sendo útil para deletar a árvore.*/
    posOrdem(no = this.raiz) {
        if (no !== null) {
            this.posOrdem(no.esquerda);
            this.posOrdem(no.direita);
            console.log(no.valor);
        }
    }

    /*Os métodos “minimo” e “maximo”, obtém o maior e menor valor. 
    Perceba que, o menor valor sempre será o último nó à esquerda, enquanto o maior está no último nó à direita.*/
    minimo(no = this.raiz) {
        if (no === null) return null;
        while (no.esquerda !== null) {
            no = no.esquerda;
        }
        return no.valor;
    }

    maximo(no = this.raiz) {
        if (no === null) return null;
        while (no.direita !== null) {
            no = no.direita;
        }
        return no.valor;
    }

    /*O método “altura()”, conta quantos níveis de nós existem do topo ao nó mais abaixo, 
    pegando o maior desses valores (Math.max) e somando a 1, contando também o nó atual.*/
    altura(no = this.raiz) {
        if (no === null) return 0;
        return 1 + Math.max(this.altura(no.esquerda), this.altura(no.direita));
    }
}

/*Por fim, resta criar a árvore, atribuir os valores dos nós, que serão automaticamente alocados nas posições corretas,
 e em seguida, buscar, obter o máximo e mínimo, e obter a altura dessa árvore. Além disso, também mostrar as diferentes travessias.*/
const arvore = new ArvoreBinaria();
arvore.inserir(10);
arvore.inserir(5);
arvore.inserir(15);
arvore.inserir(3);
arvore.inserir(7);

console.log("Buscar 7:", arvore.buscar(7));
console.log("Mínimo:", arvore.minimo());
console.log("Máximo:", arvore.maximo());
console.log("Altura:", arvore.altura());

console.log("Percurso em ordem:");
arvore.emOrdem();

console.log("Percurso pré-ordem:");
arvore.preOrdem();

console.log("Percurso pós-ordem:");
arvore.posOrdem();