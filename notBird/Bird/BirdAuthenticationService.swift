//
//  BirdAuthenticationService.swift
//  notBird
//


import Foundation
import Alamofire

class BirdAuthenticationService {
	
	static let shared = BirdAuthenticationService()
	
	typealias BirdAuthCompletionBlock = (Error?) -> Void
	
	var needsRefresh : Bool {
		guard let expiration = UserDefaults.standard.value(forKey: BirdConstants.BRD_EXP) as? String else { return false }
		let dateFormater = DateFormatter()
		dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		if let date = dateFormater.date(from: expiration) {
			return date < Date()
		}
		return false
	}
	
	public func authenticate(completion: @escaping BirdAuthCompletionBlock) {
		
		guard let email = UserDefaults.standard.value(forKey: Constants.EML_KEY) as? String else { return completion(NSError.init()) }
		
		let deviceId = NSUUID().uuidString
		
		let headers : HTTPHeaders = [
			"Content-Type" : "application/json",
			"Platform" : "ios",
			"Device-Id" : deviceId
		]
		
		let params : Parameters = [
			"email" : email
		]
		
		Alamofire.request(URL(string: "https://api.bird.co/user/login")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
			if let error = response.error {
				completion(error)
			} else if let data = response.data {
				self.parseCookies(response: response)
				if var birdAuthObject = self.parseBirdAuthenticationObject(data: data) {
					birdAuthObject.deviceId = deviceId
					self.storeAuthenticationData(birdAuthentication: birdAuthObject)
					return completion(nil)
				}
				return completion(NSError.init())
			}
		}
	}
	public func getCurrentUserAccount(completion: @escaping BirdAuthCompletionBlock) {
		
		guard let token = UserDefaults.standard.value(forKey: BirdConstants.BRD_TKN) as? String else { return completion(NSError.init()) }
		
		let headers : HTTPHeaders = [
			"Autorization" : "Bird \(token)",
			"platform" : "ios",
			"app-version" : "4.8.1"
		]
		
		Alamofire.request(URL(string: "https://api.bird.co/user")!, method: .get, headers: headers).responseJSON { (response) in
			if let error = response.error {
				completion(error)
			} else if let data = response.data {
				do {
					print(try JSONSerialization.jsonObject(with: data, options: []))
					let birdAuthentication = try JSONDecoder().decode(BirdAuthentication.self, from: data)
					self.storeAuthenticationData(birdAuthentication: birdAuthentication)
					completion(nil)
				} catch let error {
					completion(error)
				}
			}
		}
	}
	
	private func parseBirdAuthenticationObject(data: Data) -> BirdAuthentication? {
		do {
			guard let birdAuthObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
				return nil
			}
			return BirdAuthentication(dictionary: birdAuthObject)
		} catch let error {
			print(error.localizedDescription)
			return nil
		}
	}
	
	private func parseCookies(response: DataResponse<Any>) {
		if let headerFields = response.response?.allHeaderFields as? [String: String], let url = response.request?.url {
			let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
			Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: nil)
		}
	}
	
	private func storeAuthenticationData(birdAuthentication: BirdAuthentication) {
		let userDefaults = UserDefaults.standard
		userDefaults.set(birdAuthentication.token ?? "", forKey: BirdConstants.BRD_TKN)
		userDefaults.set(birdAuthentication.id, forKey: BirdConstants.BRD_ID)
		userDefaults.set(birdAuthentication.expiration, forKey: BirdConstants.BRD_EXP)
		userDefaults.set(birdAuthentication.deviceId, forKey: BirdConstants.BRD_DVC_ID)
	}
}
