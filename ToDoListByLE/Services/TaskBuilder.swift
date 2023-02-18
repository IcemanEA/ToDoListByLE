//
//  TaskBuilder.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 18.02.2023.
//

import Foundation

protocol ITaskBuilder {
	/// Генерация адаптера для отображения списка задач по секциям.
	/// - Parameter sorting: Тип сортировки внутри секции
	/// - Returns: Секционный адаптер
	func buildDataForView(with sorting: TaskSorting?) -> ISectionForTaskManagerAdapter
}

/// Строитель зависимостей для отображения и работы со списком задач
final class TaskBuilder: ITaskBuilder {
	
	private let taskManager: ITaskManager
	private var orderedTaskManager: ITaskManager!
	
	init(repository: ITaskRepository) {
		taskManager = TaskManager()
		fetchData(dataStorage: repository)
	}
			
	func buildDataForView(with sorting: TaskSorting?) -> ISectionForTaskManagerAdapter{
		if let sorting {
			orderedTaskManager = OrderedTaskManager(taskManager: taskManager, sorting: sorting)
			return SectionForTaskManagerAdapter(taskManager: orderedTaskManager)
		}
		
		return SectionForTaskManagerAdapter(taskManager: taskManager)
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
