const std = @import("std");
const Allocator = std.mem.Allocator;

// 1. Definição do Item de Dados (Intrusive Node)
// O struct 'Page' contém a informação (URL) e o campo 'node' que o torna um nó.
pub const Page = struct {
    // O campo 'link' é o nó da lista encadeada (SinglyLinkedList.Node).
    // O tipo 'std.SinglyLinkedList(*Page).Node' define a estrutura de encadeamento
    // que aponta para o próximo *Page (a próxima struct Page).
    link: std.SinglyLinkedList(Page).Node,

    url: []const u8, // O dado que queremos armazenar (a URL)
    title: []const u8, // Um dado extra

    // Função utilitária para imprimir a página
    pub fn print(self: *const Page) void {
        std.debug.print("  [{s}] -> {s}\n", .{ self.title, self.url });
    }
};

// 2. Definição do Histórico (Lista Encadeada)
pub const WebHistory = struct {
    // A lista encadeada em si, que gerencia a cabeça (first/head) da lista de Page.
    list: std.SinglyLinkedList(Page),
    allocator: Allocator,

    const Self = @This();

    pub fn init(allocator: Allocator) Self {
        return Self{
            .list = std.SinglyLinkedList(Page).init(), // Inicialização vazia
            .allocator = allocator,
        };
    }

    // Desinicializa e libera TODA a memória alocada para CADA nó (Page).
    pub fn deinit(self: *Self) void {
        // 'popFirst' remove o nó da lista e o retorna.
        while (self.list.popFirst()) |node_ptr| {
            // O nó (node_ptr) é a struct Page. Devemos liberar sua memória.
            // Para strings (slices) alocadas, precisaríamos liberá-las primeiro.
            // Neste exemplo, simplificamos e liberamos apenas o bloco 'Page' completo.
            self.allocator.destroy(node_ptr);
        }
    }

    // Adiciona uma nova página ao topo do histórico (Início da Lista).
    // O ponteiro é sempre adicionado ao 'first' (cabeça).
    pub fn visit(self: *Self, url: []const u8, title: []const u8) !void {
        // Aloca espaço para a nova struct Page (o novo Nó).
        const new_page = try self.allocator.create(Page);

        // Inicializa o novo Nó/Page, preenchendo os dados e o campo 'link' padrão.
        new_page.* = .{
            .link = .{}, // Inicializa o nó da lista encadeada (next = null)
            .url = try self.allocator.dupe(u8, url),
            .title = try self.allocator.dupe(u8, title),
        };

        // Adiciona o novo nó na CABEÇA (prepend) da lista.
        // Isso é O(1) e o grande benefício da Linked List.
        self.list.prepend(new_page);

        std.debug.print("Visitado: {s}\n", .{title});
    }

    // Percorre o histórico do mais recente para o mais antigo.
    pub fn show_history(self: *const Self) void {
        std.debug.print("\n=== Histórico de Navegação (Mais Recente -> Mais Antigo) ===\n", .{});

        var current_node_ptr = self.list.first;

        while (current_node_ptr) |page_ptr| : (current_node_ptr = page_ptr.link.next) {
            // 'page_ptr' é o ponteiro para a struct Page atual.
            page_ptr.print();
        }
        std.debug.print("=========================================================\n", .{});
    }
};


pub fn main() !void {
    // 1. Configuração do Alocador
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // 2. Inicialização do Histórico
    var history = WebHistory.init(allocator);
    defer history.deinit(); // Garante que todos os nós alocados sejam liberados

    // 3. Aplicação Prática (Visitando Páginas)

    // A cada visita, a nova página é inserida no início (O(1)).
    try history.visit("https://ziglang.org/", "Página Inicial Zig");
    try history.visit("https://docs.ziglang.org/std/singly_linked_list.html", "Documentação da Lista");
    try history.visit("https://ziggit.dev/t/arraylist-vs-linkedlist", "Discussão ArrayList");

    // Listando o histórico - a ordem é de inserção reversa.
    history.show_history();

    // Visitando mais uma página
    try history.visit("https://ziglang.org/learn/overview/", "Visão Geral da Linguagem");

    // Listando novamente. A nova página está no topo (first).
    history.show_history();
}