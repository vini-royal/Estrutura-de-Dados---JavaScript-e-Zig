class Conjunto {
    constructor() {
        this.itens = {};
    }

    // Adiciona um elemento ao conjunto (se não existir)
    adicionar(elemento) {
        if (!this.contem(elemento)) {
            this.itens[elemento] = elemento;
            return true;
        }
        return false;
    }

    // Remove um elemento do conjunto
    remover(elemento) {
        if (this.contem(elemento)) {
            delete this.itens[elemento];
            return true;
        }
        return false;
    }

    // Verifica se um elemento pertence ao conjunto
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

    // União: combina este conjunto com outro, retornando um novo conjunto
    uniao(outroConjunto) {
        const conjuntoUniao = new Conjunto();
        this.valores().forEach(item => conjuntoUniao.adicionar(item));
        outroConjunto.valores().forEach(item => conjuntoUniao.adicionar(item));
        return conjuntoUniao;
    }

    // Interseção: retorna um novo conjunto com elementos comuns a ambos
    interseccao(outroConjunto) {
        const conjuntoInter = new Conjunto();
        this.valores().forEach(item => {
            if (outroConjunto.contem(item)) {
                conjuntoInter.adicionar(item);
            }
        });
        return conjuntoInter;
    }

    // Diferença: retorna um novo conjunto com elementos que estão apenas no primeiro
    diferenca(outroConjunto) {
        const conjuntoDiff = new Conjunto();
        this.valores().forEach(item => {
            if (!outroConjunto.contem(item)) {
                conjuntoDiff.adicionar(item);
            }
        });
        return conjuntoDiff;
    }

    // Verifica se este conjunto é subconjunto de outro
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