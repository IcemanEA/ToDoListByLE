//
//  TaskListInteractor.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 15.02.2023.
//

import Foundation

/// Протокол для Интерактора списка задач.
protocol ITaskListInteractor {
	
	/// Готовность к сборке View
	func viewIsReady()
	
	/// Обновляем конкретную строку
	/// - Parameter indexPath: Секция и номер строки
 	func updateRow(at indexPath: IndexPath)
}

/// Интерактор списка задач.
final class TaskListInteractor: ITaskListInteractor {
	
	private let taskManager: ITaskManager
	private var presenter: ITaskListPresenter?
	
	private var sections: [String] = []
	
	init(builder: ITaskListBuilder, presenter: ITaskListPresenter) {
		self.taskManager = builder.getTaskManager(with: .forImportant)
		self.presenter = presenter
		createNamesOfSections()
	}
	
	func viewIsReady() {
		let response = TaskListModels.Responce(tasksBySection: mapSectionList())
		presenter?.present(responce: response)
	}
	
	func updateRow(at indexPath: IndexPath) {
		guard let task = getTask(from: indexPath) else { return }

		task.completed.toggle()

		viewIsReady()
	}

	// MARK: - Private Methods
	// Подготавливаем данные по секционно
	private func mapSectionList() -> [TaskListModels.Responce.Section] {
		var sections = [TaskListModels.Responce.Section]()
		
		for (index, title) in getSectionTitles().enumerated() {
			let sectionData = TaskListModels.Responce.Section(
				title: title,
				tasks: getTasksInSection(in: index)
			)
			
			sections.append(sectionData)
		}
		
		return sections
	}
	
	/// Получение списка наименования секций.
	/// - Returns: Список секций
	private func getSectionTitles() -> [String] {
		sections
	}
	
	/// Получение списка задач в конкретной секции.
	/// - Parameter index: Номер секции
	/// - Returns: Список задач
	private func getTasksInSection(in index: Int) -> [Task] {
		getGroupingOnCompletedTasks(in: index)
	}
	
	/// Получение позиции в списке конкретной задачи.
	/// - Parameter task: Конкретная задача
	/// - Returns: Структура с номером секции и строки
	private func getPosition(for task: Task) -> IndexPath {
		var section = 0
		var row = 0
		
		for sectionIndex in sections.indices {
			if let rowIndex = getGroupingOnCompletedTasks(in: sectionIndex).firstIndex(where: { $0 == task }) {
				section = sectionIndex
				row = rowIndex
			}
		}
		
		return IndexPath(row: row, section: section)
	}
	
	/// Получение конкретной задачи по номеру секции и строки.
	/// - Parameter indexPath: Номер секции и строки
	/// - Returns: Конкретная задача
	private func getTask(from indexPath: IndexPath) -> Task? {
		guard
			sections.count > indexPath.section,
			getGroupingOnCompletedTasks(in: indexPath.section).count > indexPath.row
		else { return nil }
		
		return getGroupingOnCompletedTasks(in: indexPath.section)[indexPath.row]
	}
	
	
	/// Группировка задач по секциям
	/// - Parameter index: Номер секции
	/// - Returns: Список задач
	private func getGroupingOnCompletedTasks(in index: Int) -> [Task] {
		switch index {
		case 1:
			return taskManager.getTasksList(isCompleted: true)
		default:
			return taskManager.getTasksList(isCompleted: false)
		}
	}
	
	/// Создаем Имена секций
	private func createNamesOfSections() {
		sections.removeAll()
		sections.append("In Work")
		sections.append("Completed")
	}
}
