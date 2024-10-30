//
//  TodoRowView.swift
//  todo
//
//  Created by Aditya Raj on 30/10/24.
//

import SwiftUI

struct TodoRowView: View {
    let todo: Todo
    let toggleAction: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggleAction) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            
            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .secondary : .primary)
        }
        .padding(.vertical, 4)
    }
}
