class Fila {
  constructor() {
    this.itens = [];
  }

  // Adiciona um elemento no final da fila
  enfileirar(elemento) {
    this.itens.push(elemento);
  }
  // Utiliza o método Array.push( )  para adicionar o elemento ao final do array (o final da fila).

  // Remove o elemento do início da fila
  desenfileirar() {
    if (this.estaVazia()) {
      return "A fila está vazia";
    }
    return this.itens.shift();
  }
  //Utiliza o método Array.shift( ) para remover e retornar o primeiro elemento do array (a frente da fila).

  // Mostra o primeiro elemento da fila sem removê-lo
  frente() {
    if (this.estaVazia()) {
      return "A fila está vazia";
    }
    return this.itens[0];
  }
  // Acessa o elemento no índice [0] do array para inspecionar o próximo a ser atendido sem removê-lo.

  // Verifica se a fila está vazia (comprimento(length) igual a zero)
  estaVazia() {
    return this.itens.length === 0;
  }

  // Mostra todos os elementos da fila
  print() {
    console.log(this.itens.join(", "));
  }
}

// --- Testando a Fila ---
const fila = new Fila();

fila.enfileirar(10);
fila.enfileirar(20);
fila.enfileirar(30);

console.log("Fila atual:");
fila.print();

console.log("Primeiro da fila:", fila.frente());

console.log("Removendo:", fila.desenfileirar());
console.log("Fila após remover:");
fila.print();