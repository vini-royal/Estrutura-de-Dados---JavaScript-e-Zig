class Conjunto {
    constructor() {
        this.itens = {};
    }

    // adicionar(elemento): Antes de inserir, verifica-se se a chave já existe no objeto interno usando 
    // Object.prototype.hasOwnProperty.call(), 
    // um método robusto para evitar conflitos. Se não existir, o elemento é adicionado como uma chave-valor
    adicionar(elemento) {
        if (!this.contem(elemento)) {
            this.itens[elemento] = elemento;
            return true;
        }
        return false;
    }

    // remover(elemento): Utiliza o operador delete para remover a propriedade do objeto interno correspondente ao elemento.
    remover(elemento) {
        if (this.contem(elemento)) {
            delete this.itens[elemento];
            return true;
        }
        return false;
    }

    // contem(elemento): Verifica a existência da chave no objeto interno, também utilizando a verificação segura com hasOwnProperty. 
    // Uma decisão de projeto importante nesta implementação é o retorno de um booleano nas operações de adição e remoção, 
    // informando se a operação foi bem-sucedida (isto é, se o elemento foi de fato adicionado ou removido), 
    // o que aumenta a utilidade da classe para o usuário.
    contem(elemento) {
        
        return Object.prototype.hasOwnProperty.call(this.itens, elemento);
    }

    // Retorna o tamanho do conjunto
    tamanho() {
        return Object.keys(this.itens).length;
    }

    // Retorna todos os valores do conjunto em um array
    valores() {
        return Object.values(this.itens);
    }

    // uniao(outroConjunto): Cria um novo conjunto e adiciona todos os elementos do conjunto atual e do conjunto passado como parâmetro. 
    // A propriedade de unicidade é mantida naturalmente pelo método adicionar
    uniao(outroConjunto) {
        const conjuntoUniao = new Conjunto();
        this.valores().forEach(item => conjuntoUniao.adicionar(item));
        outroConjunto.valores().forEach(item => conjuntoUniao.adicionar(item));
        return conjuntoUniao;
    }

    // interseccao(outroConjunto): Percorre os elementos do conjunto atual e adiciona ao novo conjunto apenas 
    // aqueles que também estão presentes no outro conjunto
    interseccao(outroConjunto) {
        const conjuntoInter = new Conjunto();
        this.valores().forEach(item => {
            if (outroConjunto.contem(item)) {
                conjuntoInter.adicionar(item);
            }
        });
        return conjuntoInter;
    }

    // diferenca(outroConjunto): Percorre os elementos do conjunto atual e 
    // adiciona ao novo conjunto apenas os que NÃO estão presentes no outro conjunto.
    diferenca(outroConjunto) {
        const conjuntoDiff = new Conjunto();
        this.valores().forEach(item => {
            if (!outroConjunto.contem(item)) {
                conjuntoDiff.adicionar(item);
            }
        });
        return conjuntoDiff;
    }

    // ehSubconjunto(outroConjunto): Utiliza o método every() para 
    // verificar se todos os elementos do conjunto atual estão contidos no outro conjunto.
    ehSubconjunto(outroConjunto) {
        if (this.tamanho() > outroConjunto.tamanho()) return false;
        return this.valores().every(item => outroConjunto.contem(item));
    }

    // Esvazia o conjunto
    limpar() {
        this.itens = {};
    }

    // Exibe o conjunto no console
    imprimir() {
        console.log(Object.values(this.itens));
    }
}

//Testando a classe Conjunto
const A = new Conjunto();
A.adicionar(1);
A.adicionar(2);
A.adicionar(3);

const B = new Conjunto();
B.adicionar(3);
B.adicionar(4);
B.adicionar(5);

console.log("Conjunto A:");
A.imprimir(); // [1, 2, 3]

console.log("Conjunto B:");
B.imprimir(); // [3, 4, 5]

console.log("União A ∪ B:");
A.uniao(B).imprimir(); // [1, 2, 3, 4, 5]

console.log("Interseção A ∩ B:");
A.interseccao(B).imprimir(); // [3]

console.log("Diferença A - B:");
A.diferenca(B).imprimir(); // [1, 2]

console.log("A é subconjunto de B?");
console.log(A.ehSubconjunto(B)); // false