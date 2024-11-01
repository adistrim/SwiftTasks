//
//  ContentView.swift
//  todo
//
//  Created by Aditya Raj on 29/10/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject private var todoManager = TodoManager()
    @State private var newTodoTitle: String = ""
    @State private var showingAddTodoSheet = false
    @State private var selectedFilter: TodoFilter = .all
    
    enum TodoFilter {
        case all, active, completed
    }
    
    var filteredTodos: [Todo] {
        switch selectedFilter {
            case .all:
                return todoManager.todos
            case .active:
                return todoManager.todos.filter { !$0.isCompleted }
            case .completed:
                return todoManager.todos.filter { $0.isCompleted }
            }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    if let username = userManager.username {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Hello,")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                Text(username)
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                            
                            // Profile menu - only show for on guest users
                            if !userManager.isGuest {
                                Menu {
                                    Button(action: {
                                        // in coming
                                    }) {
                                        Label("Settings", systemImage: "gear")
                                    }
                                    Button(role: .destructive, action: {
                                        userManager.logout()
                                    }) {
                                        Label("Logout", systemImage: "arrow.right.door.fill")
                                    }
                                } label: {
                                    Image(systemName: "person.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        
                        // stats - imported from components
                        HStack(spacing: 20) {
                            StatCard(
                                title: "Active",
                                count: todoManager.todos.filter { !$0.isCompleted }.count,
                                color: .blue
                            )
                            StatCard(
                                title: "Completed",
                                count: todoManager.todos.filter { $0.isCompleted }.count,
                                color: .green
                            )
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Filter segment control
                Picker("Filter", selection: $selectedFilter) {
                    Text("All").tag(TodoFilter.all)
                    Text("Active").tag(TodoFilter.active)
                    Text("Completed").tag(TodoFilter.completed)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // displaying todo list
                List {
                    ForEach(filteredTodos) { todo in
                        TodoRowView(todo: todo, toggleAction: {
                            todoManager.toggleTodo(todo)
                        })
                    }
                    .onDelete(perform: todoManager.deleteTodos)
                }
                .listStyle(PlainListStyle())
                
                // add todo bar
                HStack(spacing: 12) {
                    TextField("Add a quick todo", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .submitLabel(.done)
                        .onSubmit(addTodo)
                    
                    Button(action: addTodo) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
        }
    }
    
    private func addTodo() {
        guard !newTodoTitle.isEmpty else { return }
        todoManager.addTodo(newTodoTitle)
        newTodoTitle = ""
    }
}
