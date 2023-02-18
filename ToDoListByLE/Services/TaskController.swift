//
//  TaskController.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 15.02.2023.
//

import Foundation

protocol ITaskController {
	var sections: [TaskSection] { get }
	
	func updateSections(with tasks: [Task])
}

enum TaskGrouping {
	case inCompleted
	case inImportant
}

enum TaskSorting {
	case forExpiredDate
	case forImportant
	case forNoImportant
	case forCompleted
}

struct TaskSection {
	let name: String
	var tasks: [Task] = []
}

final class TaskController: ITaskController {
	
	private(set) var sections: [TaskSection] = []
	
	private var grouping: TaskGrouping
	private var sorting: TaskSorting
	
	init(grouping: TaskGrouping, sorting: TaskSorting) {
		self.grouping = grouping
		self.sorting = sorting
		
		createNamesOfSections()
	}
	
	func updateSections(with tasks: [Task]) {
		var tasks = tasks
		sortingTasks(&tasks)
		
		switch grouping {
		case .inCompleted:
			updateSectionInComplete(tasks)
		case .inImportant:
			// по условию пока не требовалось
			return
		}
	}
	
	private func sortingTasks(_ tasks: inout [Task]) {
		tasks = tasks.sorted {
			if let task0 = $0 as? ImportantTask, let task1 = $1 as? ImportantTask {
				switch sorting {
				case .forExpiredDate:
					return task0.expiredDate ?? Date() < task1.expiredDate ?? Date()
				case .forImportant:
					return task0.priority.rawValue < task1.priority.rawValue
				case .forNoImportant:
					return task0.priority.rawValue > task1.priority.rawValue
				case .forCompleted:
					return task0.completed == false && task1.completed == true
				}
			}
			
			if $0 is ImportantTask, $1 is RegularTask {
				return true
			}
		
			if  $0 is RegularTask, $1 is ImportantTask {
				return false
			}
			
			return true
		}
	}
	
	private func updateSectionInComplete(_ tasks: [Task]) {
		for index in sections.indices {
			if index == 0 {
				sections[index].tasks = tasks.filter { $0.completed == false }
			} else if index == 1 {
				sections[index].tasks = tasks.filter { $0.completed == true }
			}
		}
	}
	
	private func createNamesOfSections() {
		switch grouping {
		case .inCompleted:
			sections.append(TaskSection(name: "In Work"))
			sections.append(TaskSection(name: "Completed"))
		case .inImportant:
			for priority in TaskPriority.allCases {
				sections.append(TaskSection(name: priority.rawValue))
			}
		}
	}
}
