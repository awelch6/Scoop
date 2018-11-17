//
//  NotBirdMapView.swift
//  notBird
//


import Foundation
import MapKit

class NotBirdMapView : MKMapView {
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    setProperties()
  }

  private func setProperties() {
    self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
}
