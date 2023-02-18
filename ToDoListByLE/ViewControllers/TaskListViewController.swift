//
//  ViewController.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 12.02.2023.
//

import UIKit

class TaskListViewController: UITableViewController {

	private var taskManager: ITaskManager!
	private var taskController: ITaskController!
	private var taskRepository: ITaskRepository!
	private var colorScheme: UIColor!
	
	private let cellID = "task"
	
	convenience init(taskManager: ITaskManager, taskController: ITaskController, taskRepository: ITaskRepository, colorScheme: UIColor) {
		self.init()
		self.taskManager = taskManager
		self.taskController = taskController
		self.taskRepository = taskRepository
		self.colorScheme = colorScheme
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		view.backgroundColor = .systemBackground
		
		setupNavigationBar()
		fetchData()
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
	
	// MARK: - Private methods
	private func fetchData() {
		taskRepository.list { tasks in
			for task in tasks {
				taskManager.addTask(task)
			}
			taskController.updateSections(with: tasks)
		}
	}
}

// MARK: - TableView
extension TaskListViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		taskController.sections.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		taskController.sections[section].name
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		taskController.sections[section].tasks.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let task = taskController.sections[indexPath.section].tasks[indexPath.row]
		
		return renderTaskCell(task, for: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let task = taskController.sections[indexPath.section].tasks[indexPath.row]
		taskManager.setTaskAsCompleted(task)
		taskController.updateSections(with: taskManager.getTasksList(isCompleted: nil))
		tableView.reloadData()
	}
}

// MARK: - UITableViewCell
extension TaskListViewController {
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
	var secondaryTitle: String {
		let date = expiredDate?.formatted(date: .abbreviated, time: .omitted) ?? ""
		return "Expired \(date)"
	}
}
