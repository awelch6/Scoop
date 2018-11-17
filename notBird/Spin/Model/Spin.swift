//
//  Spin.swift
//  notBird
//

import UIKit.UIColor

struct Spin : Decodable {
	let latitude: Double
	let longitude : Double
	let battery_level : Int
	
	var batteryLevelColor : UIColor {
		return battery_level.getColorForBatteryLevel()
	}
	
	init(dicationary: [String : Any]) {
		self.latitude = dicationary["lat"] as! Double
		self.longitude = dicationary["lng"] as! Double
		self.battery_level = dicationary["batt_percentage"] as! Int
	}
}

