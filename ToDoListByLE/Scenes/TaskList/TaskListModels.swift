//
//  TaskListView.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 18.02.2023.
//

import Foundation


/// Пространство имен сцены Списка задач
enum TaskListModels {
	
	/// Отработка потока данных из ViewController на Interactor
//	struct Request { }
	
	/// Отработка потока данных из Interactor На Presentor
	struct Responce {
		/// Хранение списка общих задач с разбивкой по секциям
		struct Section {
			let title: String
			let tasks: [Task]
		}
		
		let tasksBySection: [Section]
	}
	
	/// Отработка потока данных из Presentor на ViewController
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
		
		/// Хранение списка скомпонованных задач с разбивкой по секциям
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
