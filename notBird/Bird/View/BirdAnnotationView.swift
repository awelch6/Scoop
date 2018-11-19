//
//  BirdAnnotationView.swift
//  notBird
//


import UIKit
import MapKit

class BirdAnnotationView : MKAnnotationView {

  public let birdAnnotation : BirdAnnotation?
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    birdAnnotation = annotation as? BirdAnnotation
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
    batteryIndicator.backgroundColor = birdAnnotation?.bird.batteryLevelColor
  }
}
