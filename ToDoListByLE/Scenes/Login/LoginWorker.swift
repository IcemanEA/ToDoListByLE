//
//  LoginWorker.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 21.02.2023.
//

import Foundation

public struct LoginDTO {
	var success: Int
	var login: String
	var lastLoginDate: Date
}

/// Протокол для менеджера обработки данных экрана логина
protocol ILoginWorker {
	func login(login: String, password: String) -> LoginDTO
}

/// Менеджер обработки данных экрана логина
final class LoginWorker: ILoginWorker {
	func login(login: String, password: String) -> LoginDTO {
		
		if login == "Admin" && password == "pa$$32!" {
			return LoginDTO(
				success: 1,
				login: login,
				lastLoginDate: Date()
			)
		} else {
			return LoginDTO(
				success: 0,
				login: login,
				lastLoginDate: Date()
			)
		}
	}

}


