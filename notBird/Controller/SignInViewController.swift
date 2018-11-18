//
//  SignInViewController.swift
//  notBird

import UIKit
import SnapKit
import PhoneNumberKit

protocol SignInDelegate {
	func signInWasSuccessful(phoneNumber: String, email: String, password: String)
	func signInFailed(with reason: String)
}

class SignInView : UIView {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
	}
	let phoneTextField : PhoneNumberTextField = {
		let textField = PhoneNumberTextField()
		textField.backgroundColor = .white
		textField.maxDigits = 15
		textField.placeholder = "Enter your phone number..."
		return textField
	}()
	let emailTextField = EmailTextField()
	let passwordTextField = PasswordTextField()
	let signInButton = SignInButton()
	
	var delegate : SignInDelegate?
	
	func configureView() {
		setupPhoneTextField()
		setupEmailTextField()
		setupPasswordTextField()
		setupSignInButton()
	}
	
	private func setupPhoneTextField() {
		addSubview(phoneTextField)
		phoneTextField.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.width.equalTo(300)
			make.height.equalTo(30)
		}
	}
	
	private func setupEmailTextField() {
		addSubview(emailTextField)
		emailTextField.snp.makeConstraints { (make) in
			make.top.equalTo(phoneTextField.snp.bottom).offset(20)
			make.centerX.equalToSuperview()
			make.width.equalTo(300)
			make.height.equalTo(30)
		}
	}
	
	private func setupPasswordTextField() {
		addSubview(passwordTextField)
		passwordTextField.snp.makeConstraints { (make) in
			make.top.equalTo(emailTextField.snp.bottom).offset(20)
			make.centerX.equalToSuperview()
			make.width.equalTo(300)
			make.height.equalTo(30)
			
		}
	}
	
	private func setupSignInButton() {
		addSubview(signInButton)
		signInButton.addTarget(self, action: #selector(signInButtonPressed(_:)), for: .touchUpInside)
		signInButton.snp.makeConstraints { (make) in
			make.top.equalTo(passwordTextField.snp.bottom).offset(20)
			make.centerX.equalToSuperview()
			make.width.equalTo(100)
			make.height.equalTo(30)
		}
	}
	
	@objc private func signInButtonPressed(_ sender: UIButton) {
		if !phoneTextField.isValidNumber {
			delegate?.signInFailed(with: "Invalid Phone Number")
			return
		} else if !emailTextField.isValidEmail {
			delegate?.signInFailed(with: "Invalid Email")
			return
		} else if !passwordTextField.isValidPassword {
			delegate?.signInFailed(with: "Invalid password")
			return
		}
		delegate?.signInWasSuccessful(phoneNumber: phoneTextField.nationalNumber, email: emailTextField.text!, password: passwordTextField.text!)
	}
}

class SignInViewController: UIViewController, SignInDelegate {

	
	var signInView : SignInView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		signInView = SignInView(frame: UIScreen.main.bounds)
		signInView.delegate = self
		self.view.addSubview(signInView)
	}
	
	func signInWasSuccessful(phoneNumber: String, email: String, password: String) {
		let group = DispatchGroup()

		print(phoneNumber)
		setUserDefaults(phone: phoneNumber, email: email, password: password)
		
		group.enter()
		BirdAuthenticationService.shared.authenticate(with: email) { (error) in
			if let error = error {
				print(error.localizedDescription)
			}
			group.leave()
		}
		group.enter()
		SpinAuthenticationService.shared.authenticate(with: email, password: password) { (error) in
			if let error = error {
				print(error.localizedDescription)
			}
			group.leave()
		}
		group.enter()
		LimeAuthenticationService.shared.retreiveVerificationCode(with: phoneNumber) { (error) in
			if let error = error {
				print(error.localizedDescription)
			}
			group.leave()
		}
		group.notify(queue: .main) {
			self.navigationController?.pushViewController(VerificationViewController(), animated: true)
		}
	}
	
	func signInFailed(with reason: String) {
		let alertController = UIAlertController(title: "Error!", message: reason, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
			self.dismiss(animated: true, completion: nil)
		}
		alertController.addAction(okAction)
		self.present(alertController, animated: true, completion: nil)
	}

	private func setUserDefaults(phone: String, email: String, password: String) {
		let userDefaults = UserDefaults.standard
		userDefaults.set(phone, forKey: Constants.PHN_KEY)
		userDefaults.set(email, forKey: Constants.EML_KEY)
		userDefaults.set(password, forKey: Constants.PSW_KEY)
	}
}
