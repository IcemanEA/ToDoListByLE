//
//  LoginInteractor.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 21.02.2023.
//

import Foundation

/// Протокол для Интерактора экрана логина
protocol ILoginInteractor {
	/// Передача данных для логина
	/// - Parameter request: Модель передачи от представления в интерактор
	func login(request: LoginModels.Request)
}

/// Интерактор экрана логина
final class LoginInteractor: ILoginInteractor {
	private var worker: ILoginWorker
	private var presenter: ILoginPresenter?
	
	init(worker: ILoginWorker, presenter: ILoginPresenter) {
		self.worker = worker
		self.presenter = presenter
	}
	
	func login(request: LoginModels.Request) {
		let result = worker.login(login: request.login, password: request.password)
		
		let responce = LoginModels.Responce(
			success: result.success == 1,
			login: result.login,
			lastLoginDate: result.lastLoginDate
		)
		
		presenter?.present(responce: responce)
	}
	
}
