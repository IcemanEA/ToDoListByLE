//
//  TaskListView.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 18.02.2023.
//

import Foundation


/// Пространство имен сцены Списка задач
enum TaskModel {
	
	/// Структура для хранения информации по отрисовкеданных на Вью
	struct ViewData {
		
		/// Обычные задания
		struct RegularTask {
			/// Заголовок задачи
			let title: String
			/// Статус выполнения задачи
			let isCompleted: Bool
		}
				
		/// Важные задачи
		struct ImportantTask {
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
		}
				
		/// Перечисление для обработки конкретных задач
		enum Task {
			case regularTask(RegularTask)
			case importantTask(ImportantTask)
		}
		
		// Хранение списка задач с разбивкой по секциям
		struct Section {
			let title: String
			let tasks: [Task]
		}
		
		/// Список секций с задачами
		let tasksBySection: [Section]
		
		init(tasksBySection: [Section]) {
			self.tasksBySection = tasksBySection
		}
	}
}
