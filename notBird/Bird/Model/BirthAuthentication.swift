//
//  BirthAuthentication.swift
//  notBird
//

import Foundation

struct BirdAuthentication : Decodable {
	let id: String
	let token : String?
	let expiration : String?
	var deviceId : String = ""

	var isExpired : Bool {
		let dateFormater = DateFormatter()
		dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		if let date = dateFormater.date(from: expiration ?? "") {
			return date < Date()
		}
		return false
	}
	
	init(dictionary: [String : Any]) {
		self.id = dictionary["id"] as! String
		self.token = dictionary["token"] as? String
		self.expiration = dictionary["expires_at"] as? String
	}
}
