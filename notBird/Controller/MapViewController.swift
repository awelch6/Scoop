//
//  ViewController.swift
//  notBird
//

import UIKit
import MapKit

class MapViewController: UIViewController  {
	var mapView : NotBirdMapView!

	override func loadView() {
		super.loadView()
		mapView = NotBirdMapView(frame: UIScreen.main.bounds)
		self.view.addSubview(mapView)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		BirdService.shared.getBirdLocations(location: mapView.currentUserLocation) { (birds) in
			if let birds = birds {
				for bird in birds {
					let pin = BirdAnnotation()
					pin.bird = bird
					pin.coordinate = CLLocationCoordinate2D(latitude: bird.location.latitude, longitude: bird.location.longitude)
					let annotation = MKPinAnnotationView(annotation: pin, reuseIdentifier: "scooter")
					self.mapView.addAnnotation(annotation.annotation!)
				}
			}
		}
		LimeService.shared.getLimeLocations(location: mapView.currentUserLocation) { (limes) in
			if let limes = limes {
				for lime in limes {
					let pin = LimeAnnotation()
					pin.lime = lime
					pin.coordinate = CLLocationCoordinate2D(latitude: lime.latitude , longitude: lime.longitude)
					let annotation = MKPinAnnotationView(annotation: pin, reuseIdentifier: "scooter")
					self.mapView.addAnnotation(annotation.annotation!)
				}
			}
		}

		SpinService.shared.getSpinLocations(location: mapView.currentUserLocation) { (spins) in
			if let spins = spins {
				for spin in spins {
					let pin = SpinAnnotation()
					pin.spin = spin
					pin.coordinate = CLLocationCoordinate2D(latitude: spin.latitude , longitude: spin.longitude)
					let annotation = MKPinAnnotationView(annotation: pin, reuseIdentifier: "scooter")
					self.mapView.addAnnotation(annotation.annotation!)
				}
			}
		}
	}
}
