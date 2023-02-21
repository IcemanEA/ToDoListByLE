//
//  LoginInteractor.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 21.02.2023.
//

import Foundation

protocol LoginDataStore
{
	var email: String? { get set }
	var password: String? { get set }
}

protocol ILoginInteractor {
	func login(request: LoginModels.Request)
}

class LoginInteractor: ILoginInteractor {
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
