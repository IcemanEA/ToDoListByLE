//
//  TaskListPresenter.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 18.02.2023.
//

import Foundation

/// Протокол презентора списка задач
protocol ITaskListPresenter {
	/// Инициализатор
	/// - Parameters:
	///   - view: Связка с окном отображения Вью
	///   - sectionTaskManager: Секционное управление задачами для выбора и отрисовке конкретной
	init(view: ITaskListViewController, sectionTaskManager: ISectionForTaskManagerAdapter)
	
	/// Готовность к сборке View
	func viewIsReady()
	
	/// Обновляем конкретную строку
	/// - Parameter indexPath: Секция и номер строки
	/// - Returns: Возврат значения нового положения в списке
	func updateRow(at indexPath: IndexPath) -> IndexPath
}

/// Презентор отображения списка задач
final class TaskListPresenter: ITaskListPresenter {
	
	private unowned let view: ITaskListViewController
	private let sectionTaskManager: ISectionForTaskManagerAdapter
		
	init(view: ITaskListViewController, sectionTaskManager: ISectionForTaskManagerAdapter) {
		self.view = view
		self.sectionTaskManager = sectionTaskManager
	}
	
	func viewIsReady() {
		view.render(viewData: mapViewData())
	}
	
	func updateRow(at indexPath: IndexPath) -> IndexPath {
		guard let task = sectionTaskManager.getTask(from: indexPath) else { return indexPath }
		
		task.completed.toggle()
		
		view.render(viewData: mapViewData())
		return sectionTaskManager.getPosition(for: task)
	}
	
	// Подготавливаем данные по секционно
	private func mapViewData() -> TaskModel.ViewData {
		var sections = [TaskModel.ViewData.Section]()
		
		for (index, title) in sectionTaskManager.getSectionTitles().enumerated() {
			let sectionData = TaskModel.ViewData.Section(
				title: title,
				tasks: mapTasksData(tasks: sectionTaskManager.getTasksInSection(in: index))
			)
			
			sections.append(sectionData)
		}
		
		return TaskModel.ViewData(tasksBySection: sections)
	}
	
	// Преобразуем Массив задач модели в массив для отображения
	private func mapTasksData(tasks: [Task]) -> [TaskModel.ViewData.Task] {
		tasks.map{ mapTaskData(task: $0) }
	}
	
	// Преобразуем отдельную задачу модели в задачу для отображения относительно её класса
	private func mapTaskData(task: Task) -> TaskModel.ViewData.Task {
		if let task = task as? ImportantTask {
			let expiredDateString = task.expiredDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
			
			let result = TaskModel.ViewData.ImportantTask(
				title: task.title,
				isCompleted: task.completed,
				secondaryTitle: task.completed ? nil : "Expired \(expiredDateString)",
				isExpired: task.isExpired,
				priority: task.priority
			)
			return .importantTask(result)
		} else {
			let result = TaskModel.ViewData.RegularTask(
				title: task.title,
				isCompleted: task.completed
			)
			return .regularTask(result)
		}
	}
	
}
