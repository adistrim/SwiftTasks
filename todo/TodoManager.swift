//
//  TodoManager.swift
//  todo
//
//  Created by Aditya Raj on 30/10/24.
//

import Foundation

class TodoManager: ObservableObject {
    @Published private(set) var todos: [Todo] = []
    
    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent("todos.json")
    }
    
    init() {
        loadTodos()
    }
    
    private func loadTodos() {
        do {
            let data = try Data(contentsOf: fileURL)
            todos = try JSONDecoder().decode([Todo].self, from: data)
        } catch {
            todos = []
        }
    }
    
    private func saveTodos() {
        do {
            let data = try JSONEncoder().encode(todos)
            try data.write(to: fileURL)
        } catch {
            print("Error saving todo: \(error)")
        }
    }
    
    func addTodo(_ title: String) {
        let todo = Todo(title: title)
        todos.append(todo)
        saveTodos()
    }
    
    func toggleTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    func deleteTodos(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        saveTodos()
    }
}
