//
//  UIImage.swift
//  ToDoListByLE
//
//  Created by Egor Ledkov on 12.02.2023.
//

import UIKit

extension UIImage {
	/// Создании картинки для отображения выполнения задачи.
	/// - Parameter isCompleted: статус выполнения задачи
	convenience init(isCompleted: Bool) {
		if isCompleted {
			self.init(systemName: "checkmark.seal")!
		} else {
			self.init(systemName: "seal")!
		}
	}
}

