//
//  TaskManager.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 12.02.2023.
//

import Foundation

/// Интерфейс для управления списком задач.
protocol ITaskManager {
	/// Получение списка задач, относительно заданного параметра.
	/// - Parameter isCompleted: Если nil, то выводит все задачи, иначе в зависимости от свойства
	/// - Returns: Список задач
	func getTasksList(isCompleted: Bool?) -> [Task]
	/// Добавление задачи в список
	/// - Parameter task: задача
	func addTask(_ task: Task)
	/// Удаление задачи из списка
	/// - Parameter task: задача
	func deleteTask(_ task: Task)
}

/// Стандартный менеджер управления списком задач.
final class TaskManager: ITaskManager {
	private var tasksList: [Task] = []
	
	func getTasksList(isCompleted: Bool? = nil) -> [Task] {
		if let isCompleted {
			return tasksList.compactMap {
				if $0.completed == isCompleted {
					return $0
				}
				return nil
			}
		} else {
			return tasksList
		}
	}
	
	func addTask(_ task: Task) {
		tasksList.append(task)
	}
	
	func deleteTask(_ task: Task) {
		tasksList.removeAll(where: { $0 == task })
	}
}
