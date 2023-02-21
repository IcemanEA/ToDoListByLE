//
//  MainRouter.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 21.02.2023.
//

import UIKit

protocol ILoginRouter {
	func routeToMain()
}

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
