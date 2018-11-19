//
//  LimeAuthentication.swift
// 	notBird

import JWTDecode

struct LimeAuthentication {
	
	let id : String
	let token : String
	
	var user_token : String? {
		return parseLimeJWTToken(token: token)
	}
	
	init(id: String, token: String) {
		self.id = id
		self.token = token
	}
	
	private func parseLimeJWTToken(token: String) -> String? {
		do {
			let jwt = try decode(jwt: token)
			return jwt.body["user_token"] as? String
		} catch let error {
			print(error.localizedDescription)
			return nil
		}
	}
}
