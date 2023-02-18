//
//  ViewController.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 12.02.2023.
//

import UIKit

/// Вью, которая отвечает за отображение Списка задач
final class TaskListViewController: UITableViewController {
	/// Связка с презентором представления
	var presenter: ITaskListPresenter!

	private let cellID = "task"
	
	private var sectionForTaskManager: ISectionForTaskManagerAdapter!
	private var colorScheme: UIColor!
	
	private var renderedCell: UITableViewCell?
	
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
		presenter.selectRow(indexPath)
		
		return renderedCell ?? UITableViewCell()
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

// MARK: - Extension ITaskListView
extension TaskListViewController: ITaskListView {
	/// Отрисовываем ячейку таблицы на основе полученной информации презентера
	/// - Parameters:
	///   - viewData: Структура презентора
	func render(viewData: TaskViewData) {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: viewData.indexPath)
		var content = cell.defaultContentConfiguration()
		
		content.text = viewData.title
		
		var expiredColor = UIColor.systemBackground
		var uiImage = UIImage(isCompleted: viewData.isCompleted)
		if let secondaryTitle = viewData.secondaryTitle {
			content.secondaryText = secondaryTitle
		}
		if viewData.isExpired ?? false {
			expiredColor = .systemPink.withAlphaComponent(0.2)
		}
		if let priority = viewData.priority {
			switch priority {
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
		
		renderedCell = cell
	}
}
