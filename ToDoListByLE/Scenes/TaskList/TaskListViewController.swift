//
//  ViewController.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 12.02.2023.
//

import UIKit

protocol ITaskListViewController: AnyObject {
	/// Отрисовка ячейки информации в списке задач
	/// - Parameter viewData: Единица хранения информации для отрисовки
	func render(viewData: TaskModel.ViewData)
}

/// View, которая отвечает за отображение Списка задач
final class TaskListViewController: UITableViewController {
	/// Связка с презентором представления
	var presenter: ITaskListPresenter!
	/// Данные презентора для предоставления
	private var viewData: TaskModel.ViewData = TaskModel.ViewData(tasksBySection: [])

	private let cellID = "task"
	
	private var colorScheme: UIColor!
	
	convenience init(colorScheme: UIColor) {
		self.init()
		self.colorScheme = colorScheme
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		view.backgroundColor = .systemBackground
		
		setupNavigationBar()
		presenter.viewIsReady()
	}
	
	// MARK: - Setup UI
	private func setupNavigationBar() {
		title = "Task List"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.hidesBackButton = true
		
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
		viewData.tasksBySection.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		viewData.tasksBySection[section].title
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewData.tasksBySection[section].tasks.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		var content = cell.defaultContentConfiguration()
				
		let task = viewData.tasksBySection[indexPath.section].tasks[indexPath.row]
		
		var expiredColor = UIColor.systemBackground
		var uiImage: UIImage
		switch task {
		case .regularTask(let task):
			content.text = task.title
			uiImage = UIImage(isCompleted: task.isCompleted)
		case .importantTask(let task):
			content.text = task.title
			uiImage = UIImage(isCompleted: task.isCompleted)
			
			if let secondaryTitle = task.secondaryTitle {
				content.secondaryText = secondaryTitle
			}
			if task.isExpired ?? false {
				expiredColor = .systemPink.withAlphaComponent(0.2)
			}
			if let priority = task.priority {
				switch priority {
				case .low:
					uiImage = uiImage.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
				case .medium:
					uiImage = uiImage.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
				case .high:
					uiImage = uiImage.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
				}
			}
		}
		content.image = uiImage
		
		cell.contentConfiguration = content
		cell.backgroundColor = expiredColor
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		_ = presenter.updateRow(at: indexPath)
		// в такой реализации не подвинуть строку, она не успеваем обновиться
//		tableView.moveRow(at: indexPath, to: newIndexPath)
//		tableView.reloadRows(at: [newIndexPath], with: .automatic)
	}
}

// MARK: - Extension ITaskListViewController
extension TaskListViewController: ITaskListViewController {
	/// Отрисовываем таблицу на основе полученной информации презентера
	/// - Parameters:
	///   - viewData: Структура презентора
	func render(viewData: TaskModel.ViewData) {
		self.viewData = viewData
		tableView.reloadData()
	}
}
