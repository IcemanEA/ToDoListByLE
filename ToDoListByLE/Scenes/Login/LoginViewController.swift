//
//  LoginViewController.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 21.02.2023.
//

import UIKit

protocol ILoginViewController: AnyObject {
	func render(viewModel: LoginModels.ViewModel)
	func assembly(interactor: ILoginInteractor, router: ILoginRouter)
}

class LoginViewController: UIViewController {
	private var interactor: ILoginInteractor?
	private var router: ILoginRouter?
	
	@IBOutlet weak var textFieldLogin: UITextField!
	@IBOutlet weak var textFieldPass: UITextField!
	
	@IBAction func buttonLogin(_ sender: Any) {
		if let email = textFieldLogin.text, let password = textFieldPass.text {
			let request = LoginModels.Request(login: email, password: password)
			interactor?.login(request: request)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension LoginViewController: ILoginViewController {
	func render(viewModel: LoginModels.ViewModel) {
		if viewModel.success {
			router?.routeToMain()
		} else {
			let alert: UIAlertController
			alert = UIAlertController(
				title: "Error",
				message: "",
				preferredStyle: UIAlertController.Style.alert
			)
			let action = UIAlertAction(title: "Ok", style: .default)
			alert.addAction(action)
			present(alert, animated: true, completion: nil)
		}
	}
	
	func assembly(interactor: ILoginInteractor, router: ILoginRouter) {
		self.interactor = interactor
		self.router = router
	}
}
