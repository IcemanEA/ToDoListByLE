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
	init(view: ITaskListView, sectionTaskManager: ISectionForTaskManagerAdapter)
	
	/// Выбор конкретной строки для перерисовки
	/// - Parameter indexPath: Секция и номер строки
	func selectRow(_ indexPath: IndexPath)
}

/// Презентор отображения списка задач
final class TaskListPresenter: ITaskListPresenter {
	private unowned let view: ITaskListView
	private let sectionTaskManager: ISectionForTaskManagerAdapter
	
	init(view: ITaskListView, sectionTaskManager: ISectionForTaskManagerAdapter) {
		self.view = view
		self.sectionTaskManager = sectionTaskManager
	}
	
	func selectRow(_ indexPath: IndexPath) {
		guard let task = sectionTaskManager.getTask(from: indexPath) else { return }
		let viewData = TaskViewData(task, in: indexPath)
		view.render(viewData: viewData)
	}
}
