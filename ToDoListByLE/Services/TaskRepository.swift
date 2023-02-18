//
//  TaskRepository.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 15.02.2023.
//

import Foundation

protocol ITaskRepository {
	func list(completion: ([Task]) -> Void)
}
