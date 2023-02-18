//
//  OrderedTaskManager.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 18.02.2023.
//

import Foundation

/// Виды сортировки заданий
enum TaskSorting {
	case forExpiredDate
	case forImportant
	case forNoImportant
}

/// Декоратор для сортировки списка задач в менеджер управления
final class OrderedTaskManager: ITaskManager {
	
	private let taskManager: ITaskManager
	private let sorting: TaskSorting
	
	/// Инициализация отсортированного списка.
	/// - Parameters:
	///   - taskManager: Менеджер управления списком задач
	///   - sorting: Вид сортировки
	internal init(taskManager: ITaskManager, sorting: TaskSorting) {
		self.taskManager = taskManager
		self.sorting = sorting
	}
	
	/// Получение списка задач, относительно заданного параметра
	/// - Parameter isCompleted: Если nil, то выводит все задачи, иначе в зависимости от свойства
	/// - Returns: Список задач
	func getTasksList(isCompleted: Bool?) -> [Task] {
		var tasks = taskManager.getTasksList(isCompleted: isCompleted)
		sortingTasks(&tasks)
		return tasks
	}
	
	/// Добавление задачи в список
	/// - Parameter task: задача
	func addTask(_ task: Task) {
		taskManager.addTask(task)
	}
	
	/// Удаление задачи из списка
	/// - Parameter task: задача
	func deleteTask(_ task: Task) {
		taskManager.deleteTask(task)
	}
	
	private func sortingTasks(_ tasks: inout [Task]) {
		tasks = tasks.sorted {
			if let task0 = $0 as? ImportantTask, let task1 = $1 as? ImportantTask {
				switch sorting {
				case .forExpiredDate:
					return task0.expiredDate ?? Date() < task1.expiredDate ?? Date()
				case .forImportant:
					return task0.priority.rawValue < task1.priority.rawValue
				case .forNoImportant:
					return task0.priority.rawValue > task1.priority.rawValue
				}
			}
			
			if $0 is ImportantTask, $1 is RegularTask {
				return true
			}
		
			if  $0 is RegularTask, $1 is ImportantTask {
				return false
			}
			
			return true
		}
	}
}
