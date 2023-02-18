//
//  TaskRepository.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 15.02.2023.
//

import Foundation

/// Протокол для работы с различными хранилищами списка задача.
protocol ITaskRepository {
	func list(completion: ([Task]) -> Void)
}
