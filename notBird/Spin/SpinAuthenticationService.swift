//
//  SpinAuthentication.swift
//  notBird
//

import Alamofire

class SpinAuthenticationService {
	
	static let shared = SpinAuthenticationService()
	
	typealias SpinAuthCompletionBlock = (Error?) -> Void
	
	public func authenticate(with email: String, password: String, completion: @escaping SpinAuthCompletionBlock) {
		
		let headers: HTTPHeaders = [
			"Content-Type" : "application/json"
		]
		
		let params : Parameters = [
			"email" : [
				"email" : email, "password" : password
			],
			"isApplePayDefault" : false,
			"grantType" : "email"
		]
		
		Alamofire.request(URL(string: "https://web.spin.pm/api/v1/auth_tokens")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
			if let error = response.error {
				completion(error)
			} else if let data = response.data {
				do {
					guard let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return completion(nil) }
					self.storeAuthenticationData(spinAuthentication: SpinAuthentication(dictionary: response))
					completion(nil)
				} catch let error {
					completion(error)
				}
			}
		}
	}
	private func storeAuthenticationData(spinAuthentication: SpinAuthentication) {
		let userDefaults = UserDefaults.standard
		userDefaults.set(spinAuthentication.token, forKey: SpinConstants.SPN_TKN)
		userDefaults.set(spinAuthentication.refreshToken, forKey: SpinConstants.SPN_RFSHTKN)
		userDefaults.set(spinAuthentication.existingAccount, forKey: SpinConstants.SPN_EXST)
	}
}
