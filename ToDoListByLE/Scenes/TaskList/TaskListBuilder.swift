//
//  TaskBuilder.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 18.02.2023.
//

import Foundation

/// Протокол для построения и наполнения данными менеджера задач
protocol ITaskListBuilder {
	/// Генерация адаптера для отображения списка задач по секциям.
	/// - Parameter sorting: Тип сортировки внутри секции
	/// - Returns: Секционный Task Manager
	func getTaskManager(with sorting: SortingType) -> ITaskManager
}

/// Строитель зависимостей для отображения и работы со списком задач
final class TaskListBuilder: ITaskListBuilder {
	
	private let taskManager: ITaskManager
	private var orderedTaskManager: ITaskManager!
	
	init(repository: ITaskRepository, taskManager: ITaskManager) {
		self.taskManager = taskManager
		fetchData(dataStorage: repository)
	}
			
	func getTaskManager(with sorting: SortingType) -> ITaskManager {
		OrderedTaskManager(taskManager: taskManager, sorting: sorting)
	}
				
	// MARK: - Private methods
	private func fetchData(dataStorage: ITaskRepository) {
		dataStorage.list { tasks in
			for task in tasks {
				taskManager.addTask(task)
			}
		}
	}
}
