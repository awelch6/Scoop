//
//  LimeAnnotationView.swift
//  notBird
//


import Foundation
import MapKit

class LimeAnnotationView : MKAnnotationView {

  public let limeAnnotation : LimeAnnotation?
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    limeAnnotation = annotation as? LimeAnnotation
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    clusteringIdentifier = "scooter"
    configureView()
  }
  
  let batteryIndicator : UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    view.layer.cornerRadius = 5
    return view
  }()
  
  private func configureView() {
    addSubview(batteryIndicator)
	image = UIImage(named: "scooter")
    batteryIndicator.backgroundColor = limeAnnotation?.lime.batteryLevelColor
  }
}
