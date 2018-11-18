//
//  PasswordTextField.swift
//  notBird

import UIKit

class PasswordTextField : BaseTextField {
	
	let minimumPasswordLength : Int = 6
	
	override func setProperties() {
		keyboardType = .default
		isSecureTextEntry = true
		backgroundColor = .white
		placeholder = "Create a password..."
	}
	
	var isValidPassword : Bool {
		return (text!.count >= minimumPasswordLength)
	}
}
