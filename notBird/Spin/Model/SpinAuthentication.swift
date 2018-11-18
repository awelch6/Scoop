//
//  SpinAuthentication.swift
//  notBird

struct SpinAuthentication {
	let token : String
	let existingAccount: Int
	let refreshToken: String
	
	init(dictionary: [String : Any]){
		self.token = dictionary["jwt"] as! String
		self.refreshToken = dictionary["refreshToken"] as! String
		self.existingAccount = dictionary["existingAccount"] as! Int
	}
}
