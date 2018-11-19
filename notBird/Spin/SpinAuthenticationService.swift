//
//  SpinAuthentication.swift
//  notBird
//

import Alamofire
import JWTDecode

class SpinAuthenticationService {
	
	static let shared = SpinAuthenticationService()
	
	typealias SpinAuthCompletionBlock = (Error?) -> Void
	
	public var needsRefresh : Bool {
		let tokenExpiration = UserDefaults.standard.value(forKey: SpinConstants.SPN_EXP) as! Int
		let now = Int(Date().timeIntervalSince1970)
		return (tokenExpiration < now)
	}
	
	public func authenticate(completion: @escaping SpinAuthCompletionBlock) {
		let email = UserDefaults.standard.value(forKey: Constants.EML_KEY)
		let password = UserDefaults.standard.value(forKey: Constants.PSW_KEY)
		
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
	
	public func refreshSpinToken(completion: @escaping (Error?) -> Void) {
		guard let uid = UserDefaults.standard.value(forKey: SpinConstants.SPN_UID) as? String,
			let refreshToken = UserDefaults.standard.value(forKey: SpinConstants.SPN_RFSHTKN) as? String
		else {
			return completion(NSError.init())
		}
		
		let headers: HTTPHeaders = [
			"Content-Type" : "application/json"
		]
		
		let params : Parameters = [
			"userUniqueKey" : uid,
			"refreshToken" : refreshToken,
			"grantType" : "refresh_token"
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
		parseSpinJWTToken(token: spinAuthentication.token)
	}
	
	public func parseSpinJWTToken(token: String) {
		do {
			let jwt = try decode(jwt: token)
			
			if let uid = jwt.body["userUniqueKey"] as? String, let expiration = jwt.body["exp"] as? Int {
				UserDefaults.standard.set(uid, forKey: SpinConstants.SPN_UID)
				UserDefaults.standard.set(expiration, forKey: SpinConstants.SPN_EXP)
			}
		} catch let error {
			print(error.localizedDescription)
		}
	}
}
