//
//  BaseTextField.swift
//  notBird

import UIKit

class BaseTextField : UITextField {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		setProperties()
	}
	public func setProperties() {}
	
}
