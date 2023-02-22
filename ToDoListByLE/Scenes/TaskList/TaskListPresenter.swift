//
//  TaskListPresenter.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 18.02.2023.
//

import Foundation

/// Протокол презентора списка задач
protocol ITaskListPresenter {
	/// Представление данных для отрисовки на представлении
	/// - Parameter responce: модель данных для перобразования
	func present(responce: TaskListModels.Responce)
}

/// Презентор отображения списка задач
final class TaskListPresenter: ITaskListPresenter {
	
	private weak var view: ITaskListViewController?
		
	init(view: ITaskListViewController?) {
		self.view = view
	}
	
	func present(responce: TaskListModels.Responce) {
		view?.render(viewData: mapViewData(responseSections: responce.tasksBySection))
	}
	
	// MARK: - Private Methods
	/// Подготавливаем данные по секционно
	private func mapViewData(responseSections: [TaskListModels.Responce.Section]) -> TaskListModels.ViewData {
		var sections = [TaskListModels.ViewData.Section]()
		
		for (index, responseSection) in responseSections.enumerated() {
			let sectionData = TaskListModels.ViewData.Section(
				title: responseSection.title,
				tasks: mapTasksData(tasks: responseSections[index].tasks)
			)
			
			sections.append(sectionData)
		}
		
		return TaskListModels.ViewData(tasksBySection: sections)
	}
	
	/// Преобразуем Массив задач модели в массив для отображения
	private func mapTasksData(tasks: [Task]) -> [TaskListModels.ViewData.Task] {
		tasks.map{ mapTaskData(task: $0) }
	}
	
	/// Преобразуем отдельную задачу модели в задачу для отображения относительно её класса
	private func mapTaskData(task: Task) -> TaskListModels.ViewData.Task {
		if let task = task as? ImportantTask {
			let expiredDateString = task.expiredDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
			
			let result = TaskListModels.ViewData.ImportantTask(
				title: task.title,
				isCompleted: task.completed,
				secondaryTitle: task.completed ? nil : "Expired \(expiredDateString)",
				isExpired: task.isExpired,
				priority: task.priority
			)
			return .importantTask(result)
		} else {
			let result = TaskListModels.ViewData.RegularTask(
				title: task.title,
				isCompleted: task.completed
			)
			return .regularTask(result)
		}
	}
	
}
