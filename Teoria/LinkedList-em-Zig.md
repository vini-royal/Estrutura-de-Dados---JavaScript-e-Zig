# Linked List 

### O conceito de std.SinglyLinkedList(T) em Zig
A Lista Encadeada Simples (std.SinglyLinkedList(T)) é 
a estrutura de dados de lista baseada em nós (nodes) 
na biblioteca padrão de Zig. Ao contrário do 
ArrayList, que armazena dados em memória contígua e 
redimensionável, a Linked List armazena dados em 
blocos discretos (nós), onde cada nó contém o dado e 
um ponteiro para o próximo nó.
<br></br>
Essa arquitetura tem implicações de performance:
- Vantagem: Inserções e remoções no início (cabeça) são extremamente rápidas (O(1)), pois basta reajustar um único ponteiro.
- Desvantagem: Acessar um elemento no meio da lista exige percorrer todos os nós desde o início (O(N)), e a memória não é contígua, o que pode ser menos eficiente para o cache da CPU.

---
### A Filosofia Intrusiva em Zig
As Linked Lists em std de Zig são geralmente 
intrusivas (como no exemplo do Histórico Web). Isso 
significa que os ponteiros de ligação da lista (next) 
não são estruturas separadas, mas sim um campo 
embutido dentro da sua própria estrutura de dados 
(Page no nosso exemplo).
Para isso funcionar, a estrutura que você deseja 
armazenar (Page) deve conter um campo especial:

    - Sua Estrutura→Page={dados,link: std.SinglyLinkedList(Page).Node}

---
### O Fluxo de Vida e os Comandos Chave da Linked List
O gerenciamento de memória em uma Linked List é mais 
granular que no ArrayList, pois cada nó é uma alocação 
separada na heap.

---
### 1. Definição e Alocação dos Nós
O alocador é usado para criar cada nó individualmente.
- const L = std.SinglyLinkedList(Page);: Define o tipo da nossa lista encadeada, especializada para armazenar o struct Page.
- list: L = L.init();: Inicializa a instância da lista (apenas define o ponteiro first como null).
- try self.allocator.create(Page);: Este comando aloca o espaço de memória para a nova struct Page (que é o nosso nó). O alocador (Allocator) é fundamental, pois ele é quem reserva memória para cada novo nó que entra na lista.
### 2. Inserção de Elementos (prepend)
A inserção no início (prepend) é o principal caso de uso para as Linked Lists.
- self.list.prepend(new_page);: Esta é a operação O(1). Ela insere o ponteiro new_page na cabeça da lista.
    - O ponteiro link.next do new_page é definido para apontar para a antiga cabeça da lista.
    - O ponteiro list.first é atualizado para apontar para new_page.
- new_page.* = .{ .link = .{}, ... };: Antes de usar prepend, precisamos inicializar o conteúdo do novo nó alocado. O campo link: .{} garante que o nó da lista encadeada seja inicializado corretamente.
### 3. Remoção, Limpeza e Desalocação
A desinicialização é a parte mais crítica, pois cada nó deve ser desalocado individualmente.
- while (self.list.popFirst()) |node_ptr|: O loop de limpeza. O método popFirst() remove o primeiro nó da lista e o retorna como um ponteiro opcional (?*Page). O loop continua até que a lista esteja vazia.
- self.allocator.destroy(node_ptr);: Após remover o nó da estrutura da lista, este comando libera a memória que foi originalmente alocada para aquela struct Page usando allocator.create. Este é o par obrigatório para a alocação de nós.
- defer history.deinit();: Garantido pelo defer, esta função chama o loop de limpeza acima, liberando todos os nós alocados um por um antes que a memória do GPA (gpa.deinit()) seja liberada.
### 4. Travessia (Percorrendo a Lista)
A única maneira de acessar um elemento específico é percorrendo a lista desde o início.
- var current_node_ptr = self.list.first;: Começa-se no ponteiro first (a cabeça).
- while (current_node_ptr) |page_ptr| : (current_node_ptr = page_ptr.link.next): O loop percorre a lista. A cada iteração:

    - page_ptr é o ponteiro para o nó atual (*Page).
    - A instrução de continuação (: (...)) avança para o próximo nó, pegando o ponteiro contido no campo de ligação embutido: page_ptr.link.next.

<br></br>
Em resumo, a Lista Encadeada é a escolha ideal em Zig quando você precisa de inserções e remoções rápidas nas extremidades, aceitando a complexidade de gerenciar a memória de nós individuais e a travessia lenta no acesso aleatório.

## Exemplo na prática: 