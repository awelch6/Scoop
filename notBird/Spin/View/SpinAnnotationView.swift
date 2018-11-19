//
//  SpinAnnotationView.swift
//  notBird
//

import Foundation
import MapKit

class SpinAnnotationView : MKAnnotationView {
	
	public let spinAnnotation : SpinAnnotation?
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		spinAnnotation = annotation as? SpinAnnotation
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
		batteryIndicator.backgroundColor = self.spinAnnotation?.spin.batteryLevelColor
	}
}
