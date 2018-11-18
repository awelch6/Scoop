//
//  EmailTextField.swift
//  notBird

import UIKit

class EmailTextField : BaseTextField {
	
	override func setProperties() {
		keyboardType = .emailAddress
		backgroundColor = .white
		placeholder = "Enter your email..."
	}
	
	var isValidEmail : Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let test = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return test.evaluate(with: text)
	}
}

