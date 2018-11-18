//
//  BirdAuthenticationService.swift
//  notBird
//


import Foundation
import Alamofire

class BirdAuthenticationService {
  static let shared = BirdAuthenticationService()
	
	typealias BirdAuthCompletionBlock = (Error?) -> Void
	
	public func authenticate(with email: String, completion: @escaping BirdAuthCompletionBlock) {
		let headers : HTTPHeaders = [
			"Content-Type" : "application/json",
			"Platform" : "ios",
			"Device-Id" : NSUUID().uuidString
		]
		
		let params : Parameters = [
			"email" : email
		]
		
		Alamofire.request(URL(string: "https://api.bird.co/user/login")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
			if let error = response.error {
				completion(error)
			} else if let data = response.data {
				do {
					let birdAuthentication = try JSONDecoder().decode(BirdAuthentication.self, from: data)
					self.storeAuthenticationData(birdAuthentication: birdAuthentication)
					completion(nil)
				} catch let error {
					completion(error)
				}
			}
		}
	}
	private func storeAuthenticationData(birdAuthentication: BirdAuthentication) {
		let userDefaults = UserDefaults.standard
		userDefaults.set(birdAuthentication.token ?? "", forKey: BirdConstants.BRD_TKN)
		userDefaults.set(birdAuthentication.id, forKey: BirdConstants.BRD_ID)
		userDefaults.set(birdAuthentication.expires_at, forKey: BirdConstants.BRD_EXP)
	}
}
