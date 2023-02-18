//
//  TaskListView.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 18.02.2023.
//

import Foundation

protocol ITaskListView: AnyObject {
	/// Отрисовка ячейки информации в списке задач
	/// - Parameter viewData: Единица хранения информации для отрисовки
	func render(viewData: TaskViewData)
}

/// Структура для хранения информации по отрисовкеданных на Вью
struct TaskViewData {
	/// Положение в списке
	let indexPath: IndexPath
	/// Заголовок задачи
	let title: String
	/// Статус выполнения задачи
	let isCompleted: Bool
	/// Подзаголовок для Задач с временем исполнения
	var secondaryTitle: String?
	/// Просрочена ли важная задача
	var isExpired: Bool?
	/// Приоритет важной задачи
	var priority: TaskPriority?
	
	init(_ task: Task, in indexPath: IndexPath) {
		self.indexPath = indexPath
		self.title = task.title
		self.isCompleted = task.completed
		
		if let task = task as? ImportantTask {
			if !task.completed {
				let date = task.expiredDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
				self.secondaryTitle = "Expired \(date)"
			}
			self.isExpired = task.isExpired
			self.priority = task.priority
		}
	}
}
