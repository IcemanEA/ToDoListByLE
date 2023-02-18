//
//  ViewController.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 12.02.2023.
//

import UIKit

/// Вью, которая отвечает за отображение Списка задач
final class TaskListViewController: UITableViewController {

	private var sectionForTaskManager: ISectionForTaskManagerAdapter!
	private var colorScheme: UIColor!
	
	private let cellID = "task"
	
	convenience init(sectionForTaskManager: ISectionForTaskManagerAdapter, colorScheme: UIColor) {
		self.init()
		self.sectionForTaskManager = sectionForTaskManager
		self.colorScheme = colorScheme
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		view.backgroundColor = .systemBackground
		
		setupNavigationBar()
	}
	
	// MARK: - Setup UI
	private func setupNavigationBar() {
		title = "Task List"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.backgroundColor = colorScheme
		
		navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		
		navigationController?.navigationBar.standardAppearance = navBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
		
		navigationController?.navigationBar.tintColor = .white
	}
}

// MARK: - TableView
extension TaskListViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		sectionForTaskManager.getSectionTitles().count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		sectionForTaskManager.getSectionTitles()[section]
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		sectionForTaskManager.getTasksInSection(in: section).count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {		
		let task = sectionForTaskManager.getTasksInSection(in: indexPath.section)[indexPath.row]
		
		return renderTaskCell(task, for: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let task = sectionForTaskManager.getTasksInSection(in: indexPath.section)[indexPath.row]
		task.completed.toggle()
		
		let newIndexPath = sectionForTaskManager.getPosition(for: task)
		tableView.moveRow(at: indexPath, to: newIndexPath)
		tableView.reloadRows(at: [newIndexPath], with: .automatic)
	}
}

// MARK: - UITableViewCell
extension TaskListViewController {
	
	/// Отрисовываем ячейку таблицы на основе выбранной Задачи
	/// - Parameters:
	///   - task: Задача
	///   - indexPath: номер секции и строки в таблице
	/// - Returns: Отображение ячейки
	func renderTaskCell(_ task: Task, for indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		var content = cell.defaultContentConfiguration()
		
		content.text = task.title

		var expiredColor = UIColor.systemBackground
		var uiImage = UIImage(isCompleted: task.completed)
		if let task = task as? ImportantTask {
			if !task.completed {
				content.secondaryText = task.secondaryTitle
				if task.isExpired {
					expiredColor = .systemPink.withAlphaComponent(0.2)
				}
			}
			
			switch task.priority {
			case .low:
				uiImage = uiImage.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
			case .medium:
				uiImage = uiImage.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
			case .high:
				uiImage = uiImage.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
			}
		}
		content.image = uiImage
		
		cell.contentConfiguration = content
		cell.backgroundColor = expiredColor
		
		return cell
	}
}

// MARK: - Extension ImportantTask
extension ImportantTask {
	/// Рассчитываем подзаголовок для Задач с временем исполнения
	var secondaryTitle: String {
		let date = expiredDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
		return "Expired \(date)"
	}
}
