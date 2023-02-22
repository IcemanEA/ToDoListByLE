//
//  LoginPresenter.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 21.02.2023.
//

/// Протокол для Презентора экрана логина
protocol ILoginPresenter {
	/// Проработка данных для отрисовки на представлении
	/// - Parameter responce: модель данных для презентора
	func present(responce: LoginModels.Responce)
}

/// Презентор экрана логина
final class LoginPresenter: ILoginPresenter {
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
