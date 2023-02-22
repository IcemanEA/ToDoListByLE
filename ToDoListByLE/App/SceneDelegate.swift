//
//  SceneDelegate.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 12.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	private let dataStorage: ITaskRepository = DataStorage()
	private let taskManager: ITaskManager = TaskManager()
	
	private var colorScheme: UIColor {
		UIColor(red: 56/255, green: 68/255, blue: 211/255, alpha: 194/255)
	}
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)
						
		window.rootViewController = UINavigationController(rootViewController: assembly())
		window.tintColor = colorScheme
		
		window.makeKeyAndVisible()
		self.window = window
	}
	

	private func assembly() -> UIViewController {
		let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
		guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
				as? LoginViewController
		else {
			fatalError("Нет на Login.storyboard LoginViewController!")
		}
		
		let taskListBuilder = TaskListBuilder(repository: dataStorage, taskManager: taskManager)
		let taskListVC = TaskListViewController(colorScheme: colorScheme)
		let taskListPresenter = TaskListPresenter(view: taskListVC)
		let taskListInteractor = TaskListInteractor(builder: taskListBuilder, presenter: taskListPresenter)
		taskListVC.assembly(interactor: taskListInteractor)
		
		let loginRouter = LoginRouter(source: loginVC, destination: taskListVC)
		let worker = LoginWorker()
		let loginPresenter = LoginPresenter(viewController: loginVC)
		let loginInteractor = LoginInteractor(worker: worker, presenter: loginPresenter)
		loginVC.assembly(interactor: loginInteractor, router: loginRouter)
				
		return loginVC
	}
}

