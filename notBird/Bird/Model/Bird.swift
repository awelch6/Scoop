//
//  BirdModel.swift
//  notBird
//

import UIKit

struct Bird : Decodable {
	let birds : [Birds]
}

struct Birds : Decodable {
	let id : String
	let location : Location
	let code : String
	let captive: Bool
	let battery_level : Int
	
	var batteryLevelColor : UIColor {
		return battery_level.getColorForBatteryLevel()
	}
	
	struct Location : Decodable {
		let latitude: Double
		let longitude : Double
	}
}

