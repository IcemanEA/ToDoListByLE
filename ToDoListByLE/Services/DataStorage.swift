//
//  DataStorage.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 12.02.2023.
//

import Foundation

/// Моковое хранилище списка задач.
final class DataStorage {
	private var tasks: [Task] = []
	
	init() {
		createTasks()
	}
	
	private func createTasks() {
		let expiredTask = ImportantTask(title: "Забыл купить", completed: false, priority: .high)
		expiredTask.expiredDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
		
		tasks = [
			ImportantTask(title: "Пышки", completed: false, priority: .high),
			ImportantTask(title: "Бублики", completed: true, priority: .medium),
			RegularTask(title: "Обои", completed: false),
			ImportantTask(title: "Сушки", completed: true, priority: .high),
			RegularTask(title: "Веники", completed: false),
			ImportantTask(title: "Баранки", completed: false, priority: .low),
			RegularTask(title: "Ведра", completed: true),
			expiredTask,
			ImportantTask(title: "Пончики", completed: false, priority: .medium),
			RegularTask(title: "Бутылки", completed: false)
		]
	}
}

// MARK: - ITaskRepository
extension DataStorage: ITaskRepository {
	/// Список всех данных из БД
	/// - Parameter completion: Комплитион со значением
	func list(completion: ([Task]) -> Void) {
		completion(tasks)
	}
}
