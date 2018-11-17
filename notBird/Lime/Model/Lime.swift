//
//  Lime.swift
//  notBird
//


import Foundation
import UIKit

struct Lime : Decodable {
  let id : String
  let status : String
  let latitude: Double
  let longitude : Double
  let battery_level : String
  
  var batteryLevelColor : UIColor {
    return battery_level.getColorForBatteryLevel()
  }
  
  init(id: String, attributes: [String : Any]) {
    self.id = id
    self.status = attributes["status"] as! String
    self.latitude = attributes["latitude"] as! Double
    self.longitude = attributes["longitude"] as! Double
    self.battery_level = attributes["battery_level"] as! String
  }
}

extension String {
  func getColorForBatteryLevel() -> UIColor {
    switch self {
    case "high":
        return UIColor.green
    case "medium":
        return UIColor.orange
    default:
      return UIColor.red
    }
  }
}


