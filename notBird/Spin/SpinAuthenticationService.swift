//
//  SpinAuthentication.swift
//  notBird
//


import Foundation
import Alamofire

class SpinAuthenticationService {
	static let shared = SpinAuthenticationService()
	
	typealias token = String?
	typealias SpinAuthCompletionBlock = (token) -> Void
	
	
	private let headers: HTTPHeaders = ["Content-Type" : "application/json"]
	
	private var params : Parameters {
		let randomNum = arc4random_uniform(10000) + 1;
		return [
			"email" : ["email" : "email\(randomNum)@asd\(randomNum).com", "password" : randomNum],
			"isApplePayDefault" : false,
			"grantType" : "email"
		]
	}
	
	public func Auth(completion: @escaping SpinAuthCompletionBlock) {
		Alamofire.request(URL(string: "https://web.spin.pm/api/v1/auth_tokens")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
			if let error = response.error {
				print(error.localizedDescription)
				completion(nil)
			} else if let data = response.data {
				do {
					guard let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
						let token = response["jwt"] as? String else { print("ERROR PARSING"); return completion(nil) }
					completion(token)
				} catch let error {
					print(error.localizedDescription)
					completion(nil)
				}
			}
		}
	}
}
