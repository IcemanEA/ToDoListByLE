//
//  LoginPresenter.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 21.02.2023.
//

protocol ILoginPresenter {
	func present(responce: LoginModels.Responce)
}

class LoginPresenter: ILoginPresenter {
	private weak var viewController: ILoginViewController?
	
	init(viewController: ILoginViewController?) {
		self.viewController = viewController
	}
	
	func present(responce: LoginModels.Responce) {
		let viewModel = LoginModels.ViewModel(
			success: responce.success,
			userName: responce.login,
			lastLoginDate: "\(responce.lastLoginDate)"
		)
		
		viewController?.render(viewModel: viewModel)
	}
}
