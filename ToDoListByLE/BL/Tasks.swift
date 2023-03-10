//
//  Tasks.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 12.02.2023.
//

import Foundation

/// Модель хранения задачи.
class Task {
	/// Название
	let title: String
	/// Статус готовности
	var completed: Bool

	/// Внутренний id
	private let id: UUID
	
	init(title: String, completed: Bool) {
		self.id = UUID()
		self.title = title
		self.completed = completed
	}
}

// MARK: - RegularTask
/// Обычная задача.
final class RegularTask: Task {}


// MARK: - ImportantTask

/// Приоритет для выполнения задач.
enum TaskPriority: String, CaseIterable {
	case low = "Low"
	case medium = "Medium"
	case high = "High"
}

/// Важная задача с приоритетом и сроком выполнения.
final class ImportantTask: Task {
	/// Приоритет выполнения
	let priority: TaskPriority
	/// Срок исполнения задача
	var expiredDate: Date?
	/// Рассчетное свойство истечения срока выполнения задачи
	var isExpired: Bool {
		expiredDate ?? Date() < Date()
	}
	
	init(title: String, completed: Bool, priority: TaskPriority) {
		self.priority = priority
		super.init(title: title, completed: completed)
		
		createExpiredDate()
	}
	
	private func createExpiredDate() {
		let today = Date()
		switch priority {
		case .low:
			expiredDate = Calendar.current.date(byAdding: .day, value: 3, to: today)
		case .medium:
			expiredDate = Calendar.current.date(byAdding: .day, value: 2, to: today)
		case .high:
			expiredDate = Calendar.current.date(byAdding: .day, value: 1, to: today)
		}
	}
}

// MARK: - Task: Equatable
extension Task: Equatable {
	
	static func == (lhs: Task, rhs: Task) -> Bool {
		lhs.id == rhs.id
	}
		
}
