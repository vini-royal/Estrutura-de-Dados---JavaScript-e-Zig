const std = @import("std");

const Aluno = struct {
    nome: []const u8,
    nota: f64,
};

//Cria HashMap de alunos
const AlunoMap = std.StringHashMap(Aluno);

//Metódo que casdastra um aluno no HashMap
fn cadastrarAluno(map: *AlunoMap, matricula: []const u8, nome: []const u8, nota: f64) !void {
    //Não sobrescreve o aluno se já cadastrado
    map.putNoClobber(matricula, Aluno{ .nome = nome, .nota = nota }) catch |err| {
        if (err == error.KeyAlreadyExists) {
            std.debug.print("Aluno {s} ja existe.\n", .{matricula});
            return;
        }
        return err;
    };
}

//Metódo que busca um aluno no Hashmap, se já cadastrado
fn buscarAluno(map: *AlunoMap, matricula: []const u8) !void {
    if (map.get(matricula)) |aluno| {
        std.debug.print("Aluno: {s}, Nota: {d:.2}\n", .{ aluno.nome, aluno.nota });
    } else {
        std.debug.print("Aluno {s} não encontrado\n", .{matricula});
    }
}

//Metódo que mostra todos os alunos cadastrados no HashMap
fn listarTodosAlunos(map: *AlunoMap) void {
    var it = map.iterator(); //cria o iterador
    std.debug.print("\n--- Todos os alunos cadastrados ---\n", .{});
    while (it.next()) |entry| { //percorre cada entrada do Hashmap
        std.debug.print("Matricula: {s}, Nome: {s}, Nota: {d:.2}\n", .{ entry.key_ptr.*, entry.value_ptr.*.nome, entry.value_ptr.*.nota });
    }
}

//Metódo que atualiza o nome e a nota de um aluno já cadastrado no Hashmap
fn atualizarAluno(map: *AlunoMap, matricula: []const u8, novoNome: []const u8, novaNota: f64) !void {
    if (map.getPtr(matricula)) |alunoPtr| {
        alunoPtr.nome = novoNome;
        alunoPtr.nota = novaNota;
        std.debug.print("\nAluno com matricula {s} atualizado: Nome = {s}, Nota = {d:.2}\n", .{ matricula, novoNome, novaNota });
    } else {
        std.debug.print("\nAluno com matricula {s} nao encontrado para atualizar\n", .{matricula});
    }
}

//Metódo que remove um aluno do HashMap
fn removerAluno(map: *AlunoMap, matricula: []const u8) !void {
    if (map.remove(matricula)) { //remove usando a matrícula como chave
        std.debug.print("\nAluno com matricula {s} removido\n", .{matricula});
    } else {
        std.debug.print("\nAluno com matricula {s} nao encontrado para remocao\n", .{matricula});
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){}; //Cria alocador
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var map = AlunoMap.init(allocator); //Inicializa o HashMap
    defer map.deinit(); //Libera a memória ao final, evita vazamentos

    try cadastrarAluno(&map, "123", "Joao", 8.5);
    try cadastrarAluno(&map, "456", "Maria", 9.2);
    try cadastrarAluno(&map, "789", "Antonio", 8.7);
    try cadastrarAluno(&map, "234", "Vanessa", 7.7);
    try cadastrarAluno(&map, "567", "Manuela", 7.1);
    try cadastrarAluno(&map, "891", "Natan", 9.5);

    listarTodosAlunos(&map); // Lista todos

    std.debug.print("\n--- Aluno buscado ---\n", .{});
    try buscarAluno(&map, "456"); // Busca aluno específico

    try atualizarAluno(&map, "123", "Jonas", 9.7); // Atualiza nome e nota
    std.debug.print("\n--- Aluno buscado ---\n", .{});
    try buscarAluno(&map, "123");

    try removerAluno(&map, "789");
    try removerAluno(&map, "567"); // Remove aluno

    listarTodosAlunos(&map); // Lista novamente
}
