//
//  BirthAuthentication.swift
//  notBird
//

import Foundation

struct BirdAuthentication : Decodable {
	let id: String
	let token : String?
	let expires_at : String?
	
	var isExpired : Bool {
		let dateFormater = DateFormatter()
		dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		if let date = dateFormater.date(from: expires_at ?? "") {
			return date < Date()
		}
		return false
	}
}
