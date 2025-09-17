const std = @import("std");

const Task = struct {
    priority: u32,
    name: []const u8,
};

// Método de comparação usada pela PriorityQueue
fn compare(context: void, a: Task, b: Task) std.math.Order {
    // Context permite passar dados adicionais para a função comparação
    // Neste caso, context não precisa ser usado, ficando então como void,
    // porque não é necessário nenhum contexto externo
    _ = context;
    // Compara os números de prioridade e organiza os elementos de forma que
    // o com maior prioridade fique na frente
    return std.math.order(a.priority, b.priority);
}

// Inicializa a PriorityQueue
fn initQueue(allocator: std.mem.Allocator) std.PriorityQueue(Task, void, compare) {
    return std.PriorityQueue(Task, void, compare).init(allocator, {});
}

// Adiciona uma tarefa na fila
fn add(queue: *std.PriorityQueue(Task, void, compare), task: Task) !void {
    try queue.add(task);
    std.debug.print("Tarefa '{s}' adicionada com prioridade {d}\n", .{ task.name, task.priority });
}

// Consulta a tarefa com maior prioridade sem remover
fn peek(queue: *std.PriorityQueue(Task, void, compare)) void {
    if (queue.peek()) |task| {
        std.debug.print("Tarefa com maior prioridade: {s} (prioridade {d})\n", .{ task.name, task.priority });
    } else {
        std.debug.print("Fila vazia\n", .{});
    }
}

// Remove e processa a próxima tarefa com maior prioridade.
fn remove(queue: *std.PriorityQueue(Task, void, compare)) void {
    if (queue.items.len > 0) {
        const task = queue.remove();
        std.debug.print("Processando a tarefa com maior prioridade: {s} (prioridade {d})\n", .{ task.name, task.priority });
    } else {
        std.debug.print("A fila esta vazia. Nenhuma tarefa para processar.\n", .{});
    }
}

// Atualiza a prioridade da primeira tarefa (simulando update)
fn updateFirstTask(queue: *std.PriorityQueue(Task, void, compare), new_priority: u32) !void {
    if (queue.peek()) |task| {
        var updated_task = task;
        updated_task.priority = new_priority;
        _ = queue.remove(); // Remove o elemento antigo e descarta o valor de retorno
        try queue.add(updated_task);
        std.debug.print("Tarefa '{s}' atualizada para prioridade {d}\n", .{ updated_task.name, updated_task.priority });
    } else {
        std.debug.print("Nenhuma tarefa para atualizar\n", .{});
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){}; // Cria alocador
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var queue = initQueue(allocator); // Inicializa a PriorityQueue
    defer queue.deinit(); // Libera a memória ao final, evita vazamento

    try add(&queue, Task{ .priority = 2, .name = "Pagar contas" }); // Tarefa importante
    try add(&queue, Task{ .priority = 3, .name = "Lavar pratos" }); // Tarefa normal
    try add(&queue, Task{ .priority = 1, .name = "Consertar vazamento de agua" }); // Tarefa importante

    std.debug.print("\n--- Peek da fila ---\n", .{});
    peek(&queue); // Mostra a tarefa mais importante no momento

    std.debug.print("\n--- Update da primeira tarefa ---\n", .{});
    try updateFirstTask(&queue, 0); // Atualiza a tarefa para mais urgente

    std.debug.print("\n--- Peek apos update ---\n", .{});
    peek(&queue); // Mostra a tarefa mais importante no momento

    std.debug.print("\n--- Removendo tafera com maior prioridade ---\n", .{});
    remove(&queue); // Todas as tarefas são removidas

    std.debug.print("\n--- Adicionando mais tarefas ---\n", .{});
    try add(&queue, Task{ .priority = 4, .name = "Dobrar roupa" }); // Nova tarefa normal
    try add(&queue, Task{ .priority = 1, .name = "Estudar para prova" }); // Nova tarefa importante

    std.debug.print("\n--- Lista final da fila ---\n", .{});
    peek(&queue); // Mostra a tarefa mais importante no momento
}
