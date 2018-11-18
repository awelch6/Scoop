//
//  VerificationViewController.swift
//  notBird

import UIKit
import SnapKit

protocol VerificationDelegate {
	func validVerificationCode(code: String)
	func invalidVerificationCode(reason: String)
}

class VerificationView : UIView {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
	}
	
	let verificationTextField = VerificationTextField()
	let verificationButton = VerificationButton()
	
	var delegate : VerificationDelegate?
	
	private func configureView() {
		setupVerificationTextField()
		setupVerificationButton()
	}
	
	private func setupVerificationTextField() {
		addSubview(verificationTextField)
		verificationTextField.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.width.equalTo(300)
			make.height.equalTo(30)
		}
	}
	private func setupVerificationButton() {
		addSubview(verificationButton)
		verificationButton.addTarget(self, action: #selector(verificationButtonPressed(_:)), for: .touchUpInside)
		verificationButton.snp.makeConstraints { (make) in
			make.top.equalTo(verificationTextField.snp.bottom)
			make.centerX.equalToSuperview()
			make.width.equalTo(300)
			make.height.equalTo(30)
		}
	}
	@objc private func verificationButtonPressed(_ sender: UIButton) {
		if !verificationTextField.isValidCode {
			delegate?.invalidVerificationCode(reason: "The verification code is invalid.")
			return
		}
		delegate?.validVerificationCode(code: verificationTextField.text!)
	}
}

class VerificationViewController: UIViewController, VerificationDelegate {
	
	var verificationView : VerificationView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		verificationView = VerificationView(frame: UIScreen.main.bounds)
		verificationView.delegate = self
		view.addSubview(verificationView)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		verificationView.verificationTextField.becomeFirstResponder()
	}
	
	func validVerificationCode(code: String) {
		LimeAuthenticationService.shared.authenticate(with: code) { (error) in
			if let error = error {
				print(error.localizedDescription)
			}
			self.navigationController?.pushViewController(MapViewController(), animated: true)
		}
	}
	
	func invalidVerificationCode(reason: String) {
		let alertController = UIAlertController(title: "Error!", message: reason, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
			self.dismiss(animated: true, completion: nil)
		}
		alertController.addAction(okAction)
		self.present(alertController, animated: true, completion: nil)
	}
}
