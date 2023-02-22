//
//  MainRouter.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 21.02.2023.
//

import UIKit

/// Протокол для роутера экрана ввода данных пользователя
protocol ILoginRouter {
	/// Переход на главный экран приложения после успешного логина
	func routeToMain()
}

/// Роутер экрана ввода данных пользователя
final class LoginRouter: ILoginRouter {
	private let source: LoginViewController
	private let destination: TaskListViewController
	
	init(source: LoginViewController, destination: TaskListViewController) {
		self.source = source
		self.destination = destination
	}
	
	func routeToMain() {
		source.show(destination, sender: nil)
	}
}
