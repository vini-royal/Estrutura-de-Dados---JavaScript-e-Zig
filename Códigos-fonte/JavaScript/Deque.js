//Fila Dupla ou Deque(Double Ended Queue)
//A classe Deque herda a mesma base de array da fila simples,
//mas expõe uma API ampliada.
class Deque {
  constructor() {
    this.itens = [];
  }

  // --- Inserções ---
    //adicionarFrente(elemento) e adicionarTras(elemento): Usam unshift( ) e push( ), respectivamente
  adicionarFrente(elemento) {
    this.itens.unshift(elemento); // adiciona no início
  }

  adicionarTras(elemento) {
    this.itens.push(elemento); // adiciona no final
  }

  // --- Remoções ---
    //removerFrente() e removerTras(): Usam shift() e pop(), respectivamente.
  removerFrente() {
    if (this.estaVazio()) return "Deque vazio";
    return this.itens.shift(); // remove do início
  }

  removerTras() {
    if (this.estaVazio()) return "Deque vazio";
    return this.itens.pop(); // remove do final
  }

  // --- Acessar elementos ---
  frente() {
    if (this.estaVazio()) return "Deque vazio";
    return this.itens[0];
  }

  tras() {
    if (this.estaVazio()) return "Deque vazio";
    return this.itens[this.itens.length - 1];
  }

  // --- Verificar estado ---
  estaVazio() {
    return this.itens.length === 0;
  }

  print() {
    console.log(this.itens.join(", "));
  }
}

// --- Testando o Deque ---
const deque = new Deque();

deque.adicionarTras(10);
deque.adicionarTras(20);
deque.adicionarFrente(5);
deque.adicionarFrente(1);

console.log("Deque atual:");
deque.print(); // 1, 5, 10, 20

console.log("Removendo da frente:", deque.removerFrente()); // remove 1
console.log("Removendo de trás:", deque.removerTras());     // remove 20

console.log("Deque após remoções:");
deque.print(); // 5, 10

console.log("Frente:", deque.frente()); // 5
console.log("Trás:", deque.tras());     // 10