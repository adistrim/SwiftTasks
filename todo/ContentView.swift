//
//  ContentView.swift
//  todo
//
//  Created by Aditya Raj on 29/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var todoManager = TodoManager()
    @State private var newTodoTitle: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // todo input field and button here
                HStack {
                    TextField("New todo", text: $newTodoTitle).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: addTodo) {
                        Image(systemName: "plus.circle.fill").foregroundColor(.blue)
                    }
                }
                .padding()
                
                // displaying todo list
                List {
                    ForEach(todoManager.todos) { todo in
                        HStack {
                            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle").foregroundColor(todo.isCompleted ? .green : .gray).onTapGesture {todoManager.toggleTodo(todo)}
                            
                            Text(todo.title).strikethrough(todo.isCompleted)
                        }
                    }
                    // deleting todo on left swipe
                    .onDelete(perform: todoManager.deleteTodos)
                }
                Text("Swipe left to delete todo")
            }
            .navigationTitle("Todo List")
        }
    }
    
    private func addTodo() {
        guard !newTodoTitle.isEmpty else { return }
        todoManager.addTodo(newTodoTitle)
        newTodoTitle = ""
    }
}

#Preview("Dark Mode") {
    ContentView().preferredColorScheme(.dark)
}
