//
//  VerificationTextField.swift
//  notBird

import UIKit

class VerificationTextField : BaseTextField {
	override func setProperties() {
		keyboardType = .numberPad
		placeholder = "Enter verification code..."
		backgroundColor = .white
	}
	var isValidCode : Bool {
		return (text!.count == 6)
	}
}
