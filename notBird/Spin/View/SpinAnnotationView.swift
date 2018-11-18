//
//  SpinAnnotationView.swift
//  notBird
//

import Foundation
import MapKit

class SpinAnnotationView : MKAnnotationView {
	
	private let notBirdAnnotation : NotBirdAnnotation?
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		self.notBirdAnnotation = annotation as? NotBirdAnnotation
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		clusteringIdentifier = "spin"
		configureView()
	}
	
	let batteryIndicator : UIView = {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
		view.layer.cornerRadius = 5
		return view
	}()
	
	private func configureView() {
		addSubview(batteryIndicator)
		image = notBirdAnnotation?.image
		batteryIndicator.backgroundColor = self.notBirdAnnotation?.batteryColor
	}
}
