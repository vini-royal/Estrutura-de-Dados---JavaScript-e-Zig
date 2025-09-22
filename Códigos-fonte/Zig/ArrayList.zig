const std = @import("std");
const Allocator = std.mem.Allocator;

// Estrutura principal da aplicação que contém o ArrayList
pub const TodoList = struct {
    // O ArrayList armazena fatias de bytes ([]const u8) para representar as tarefas (strings).
    // O tipo '[]const u8' é a representação de uma fatia de bytes constante (string) em Zig.
    // **Importante:** Cada string adicionada deve ser duplicada (dupe) para que o ArrayList
    // seja o dono da memória, evitando referências a dados temporários ou liberados.
    list: std.ArrayList([]const u8),

    // O alocador da lista é o mesmo que precisamos para duplicar as strings
    allocator: Allocator,

    // Função para inicializar o gerenciador de tarefas
    pub fn init(allocator: Allocator) TodoList {
        return TodoList{
            .list = std.ArrayList([]const u8).init(allocator),
            .allocator = allocator,
        };
    }

    // Função para desinicializar e liberar a memória
    // Deve ser chamada com 'defer' no código principal.
    pub fn deinit(self: *Self) void {
        // 1. Liberar a memória de CADA string alocada (duplicada) no ArrayList
        for (self.list.items) |item| {
            self.allocator.free(item);
        }
        // 2. Desinicializar o próprio ArrayList (libera a memória interna do ArrayList)
        self.list.deinit();
    }

    // Adiciona uma nova tarefa à lista
    // Retorna um 'error' se a alocação de memória falhar.
    pub fn add(self: *Self, task: []const u8) !void {
        // Duplica a string para que o ArrayList seja o proprietário da memória.
        // Isso é crucial, pois `task` pode ser uma fatia temporária.
        const owned_task = try self.allocator.dupe(u8, task);

        // Adiciona a fatia de bytes (string) duplicada ao ArrayList.
        try self.list.append(owned_task);
        std.debug.print("Tarefa adicionada: {s}\n", .{task});
    }

    // Remove uma tarefa pelo índice (remove de forma não ordenada - mais rápido)
    // Retorna um 'error' se o índice for inválido.
    pub fn remove(self: *Self, index: usize) !void {
        if (index >= self.list.items.len) {
            return error.IndexOutOfBounds;
        }

        // Obtém a tarefa para liberar sua memória antes de removê-la da lista
        const removed_task = self.list.items[index];

        // Libera a memória da string que estava armazenada
        self.allocator.free(removed_task);

        // Remove o elemento do ArrayList
        _ = self.list.orderedRemove(index);

        std.debug.print("Tarefa removida no índice {d}: {s}\n", .{index, removed_task});
    }

    // Lista todas as tarefas
    pub fn list_all(self: *const Self) void {
        std.debug.print("\n--- Lista de Tarefas ---\n", .{});
        if (self.list.items.len == 0) {
            std.debug.print("Nenhuma tarefa pendente.\n", .{});
            return;
        }

        // Itera sobre a fatia de itens (`.items`) do ArrayList
        for (self.list.items, 0..) |task, i| {
            std.debug.print("{d}. {s}\n", .{i, task});
        }
        std.debug.print("------------------------\n", .{});
    }
};


pub fn main() !void {
    // 1. Configuração do Alocador
    // Em Zig, a alocação de memória é explícita. Usamos um GeneralPurposeAllocator (GPA)
    // para gerenciar a memória do ArrayList e das strings.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // `defer` garante que o alocador seja desinicializado no final da função,
    // liberando a memória alocada pelo GPA.
    defer _ = gpa.deinit();

    // 2. Inicialização do TodoList
    var todo_list = TodoList.init(allocator);

    // `defer` garante que a lista e todas as suas strings internas sejam desinicializadas.
    defer todo_list.deinit();

    // 3. Aplicação Prática

    // Adicionando tarefas
    try todo_list.add("Aprender Zig e ArrayList");
    try todo_list.add("Fazer o deploy da aplicação");
    try todo_list.add("Comprar café para o código");

    // Listando
    todo_list.list_all();

    // Removendo uma tarefa (índice 1: "Fazer o deploy da aplicação")
    try todo_list.remove(1);

    // Adicionando outra tarefa
    try todo_list.add("Revisar o código de memória");

    // Listando novamente
    todo_list.list_all();

    // Tentativa de remover um índice inválido (lançará um erro)
    // Se você rodar com `zig run`, isso causará um pânico (panic) ou você pode
    // tratar o erro com `catch`.
    try todo_list.remove(10) catch |err| {
        std.debug.print("\nErro ao remover: {s}\n", .{@errorName(err)});
    };
}