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
		let expiredTask = ImportantTask(title: "Оплатить интернет", completed: false, priority: .high)
		expiredTask.expiredDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
		
		tasks = [
			ImportantTask(title: "Оплатить телефон", completed: false, priority: .high),
			ImportantTask(title: "Купить яйца", completed: true, priority: .medium),
			RegularTask(title: "Выбросить коробки", completed: false),
			ImportantTask(title: "Оплатить учебу", completed: true, priority: .high),
			RegularTask(title: "Разобрать шкаф", completed: false),
			ImportantTask(title: "Зайти на почту за письмом", completed: false, priority: .low),
			RegularTask(title: "Помыть посуду", completed: true),
			expiredTask,
			ImportantTask(title: "Купить масло", completed: false, priority: .medium),
			RegularTask(title: "Помыть зимнюю обувь", completed: false)
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
