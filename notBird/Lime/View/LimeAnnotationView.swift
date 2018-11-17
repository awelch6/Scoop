//
//  LimeAnnotationView.swift
//  notBird
//


import Foundation
import MapKit

class LimeAnnotationView : MKAnnotationView {

  private let notBirdAnnotation : NotBirdAnnotation?
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    self.notBirdAnnotation = annotation as? NotBirdAnnotation
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    clusteringIdentifier = "lime"
    configureView()
  }
  
  let batteryIndicator : UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    view.layer.cornerRadius = 5
    return view
  }()
  
  private func configureView() {
    addSubview(batteryIndicator)
    image = UIImage(named: "grapefruit")
    batteryIndicator.backgroundColor = self.notBirdAnnotation?.batteryColor
  }
}
