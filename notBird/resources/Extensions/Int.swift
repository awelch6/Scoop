//
//  Int.swift
//  notBird
//

import UIKit.UIColor

extension Int {
  func getColorForBatteryLevel() -> UIColor {
    switch self {
    case _ where self > 75:
        return UIColor.green
    case 40...75:
     return UIColor.orange
    default:
      return UIColor.red
    }
  }
}
