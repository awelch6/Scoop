//
//  LimeAuthentication.swift
//  notBird
//

import Alamofire

class LimeAuthenticationService {
	static let shared = LimeAuthenticationService()
	
	typealias LimeAuthCompletionBlock = (Error?) -> Void
	
	public func retreiveVerificationCode(with phone: String, completion: @escaping LimeAuthCompletionBlock) {
		let headers: HTTPHeaders = [
			"Content-Type" : "application/json"
		]
		
		let params : Parameters = [
			"phone" : phone
		]
		
		Alamofire.request(URL(string: "https://web-production.lime.bike/api/rider/v1/login?")!, method: .get, parameters: params, headers: headers).responseJSON { (response) in
			if let error = response.error {
				completion(error)
			} else if let headerFields = response.response?.allHeaderFields as? [String: String],
				let url = response.request?.url {
				let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
				Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: nil)
			}
			completion(nil)
		}
	}
	public func authenticate(with code: String, completion: @escaping LimeAuthCompletionBlock) {
		let headers: HTTPHeaders = [
			"Content-Type" : "application/json"
		]
		
		let params : Parameters = [
			"login_code" : code,
			"phone" : UserDefaults.standard.value(forKey: Constants.PHN_KEY) as! String,
			"platform" : "ios"
		]
		
		Alamofire.request(URL(string: "https://web-production.lime.bike/api/rider/v1/login?")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
			if let error = response.error {
				completion(error)
			} else if let data = response.data {
				guard let limeAuthetication = self.parseLimeAuthenticationAPI(limeObject: data) else { return completion(NSError.init()) }
				self.storeAuthenticationData(limeAuthentication: limeAuthetication)
				completion(nil)
			}
		}
	}
	
	private func parseLimeAuthenticationAPI(limeObject: Data) -> LimeAuthentication? {
		do {
			guard let response = try JSONSerialization.jsonObject(with: limeObject, options: []) as? [String : Any],
				let token = response["token"] as? String,
				let user = response["user"] as? [String : Any],
				let id = user["id"] as? String
			else {
				return nil
			}
			return LimeAuthentication(id: id, token: token)
		} catch {
			return nil
		}
	}
	
	private func storeAuthenticationData(limeAuthentication: LimeAuthentication) {
		let userDefaults = UserDefaults.standard
		userDefaults.set(limeAuthentication.token, forKey: LimeConstants.LME_TKN)
		userDefaults.set(limeAuthentication.id, forKey: LimeConstants.LME_ID)
	}
}
