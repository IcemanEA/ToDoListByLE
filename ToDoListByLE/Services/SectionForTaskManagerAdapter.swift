//
//  SectionForTaskManagerAdapter.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 15.02.2023.
//

import Foundation

/// Протокол для адаптера отрисовки табличных секций списка задач.
protocol ISectionForTaskManagerAdapter {
	/// Получение списка наименования секций.
	/// - Returns: Список секций
	func getSectionTitles() -> [String]
	/// Получение списка задач в конкретной секции.
	/// - Parameter index: Номер секции
	/// - Returns: Список задач
	func getTasksInSection(in index: Int) -> [Task]
	/// Получение позиции в списке конкретной задачи.
	/// - Parameter task: Конкретная задача
	/// - Returns: Структура с номером секции и строки
	func getPosition(for task: Task) -> IndexPath
}

/// Адаптер отрисовки табличных секций списка задач.
final class SectionForTaskManagerAdapter: ISectionForTaskManagerAdapter {
	
	private let taskManager: ITaskManager
	
	private var sections: [String] = []
	
	init(taskManager: ITaskManager) {
		self.taskManager = taskManager
		
		createNamesOfSections()
	}
	
	func getSectionTitles() -> [String] {
		sections
	}
	
	func getTasksInSection(in index: Int) -> [Task] {
		getGroupingOnCompletedTasks(in: index)
	}
	
	func getPosition(for task: Task) -> IndexPath {
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
	
	private func getGroupingOnCompletedTasks(in index: Int) -> [Task] {
		switch index {
		case 1:
			return taskManager.getTasksList(isCompleted: true)
		default:
			return taskManager.getTasksList(isCompleted: false)
		}
	}

	private func createNamesOfSections() {
		sections.removeAll()
		sections.append("In Work")
		sections.append("Completed")
	}
}
