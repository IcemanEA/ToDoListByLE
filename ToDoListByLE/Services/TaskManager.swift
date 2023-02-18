//
//  TaskManager.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 12.02.2023.
//

import Foundation

protocol ITaskManager {
	func getTasksList(isCompleted: Bool?) -> [Task]
	func getTasksCount(isCompleted: Bool?) -> Int
	func addTask(_ task: Task)
	func deleteTask(_ task: Task)
	func setTaskAsCompleted(_ task: Task)
}

class TaskManager: ITaskManager {
	private var tasksList: [Task] = []
	
	/// Получение списка задач, относительно заданного параметра
	/// - Parameter isCompleted: Если nil, то выводит все задачи, иначе в зависимости от свойства
	/// - Returns: Список задач
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
	
	/// Получение количества задач, относительно заданного параметра
	/// - Parameter isCompleted: Если nil, то выводит все задачи, иначе в зависимости от свойства
	/// - Returns: Количество задач
	func getTasksCount(isCompleted: Bool? = nil) -> Int {
		getTasksList(isCompleted: isCompleted).count
	}
	
	/// Добавление задачи в список
	/// - Parameter task: задача
	func addTask(_ task: Task) {
		tasksList.append(task)
	}
	
	/// Удаление задачи из списка
	/// - Parameter task: задача
	func deleteTask(_ task: Task) {
		tasksList.removeAll(where: { $0 == task })
	}
	
	/// Отмечаем выполнение задачи с поиском по индексу
	/// - Parameter index: index задачи
	func setTaskAsCompleted(_ task: Task) {
		if let index = tasksList.firstIndex(where: { $0 == task }) {
			tasksList[index].completed = true
		}
	}
	
}
