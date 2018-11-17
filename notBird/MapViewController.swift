//
//  ViewController.swift
//  notBird
//


import UIKit
import MapKit

enum AnnotationType : String {
	case bird = "bird"
	case spin = "spin"
	case lime = "lime"
	case jelly  = "jelly"
}


class NotBirdAnnotation : MKPointAnnotation {
	var type : String!
	var batteryColor : UIColor?
	var image : UIImage?
}

class MapViewController: UIViewController, MKMapViewDelegate  {
	var mapView : NotBirdMapView!
	
	override func loadView() {
		super.loadView()
		mapView = NotBirdMapView(frame: UIScreen.main.bounds)
		self.view.addSubview(mapView)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let location = CLLocationCoordinate2D(latitude: 42.332950, longitude: -83.049454)
		mapView.setCenter(location, animated: true)
		mapView.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
		mapView.delegate = self
		
		mapView.register(BirdAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		mapView.register(LimeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		mapView.register(BirdClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
		
		BirdService.shared.getBirds { (birds) in
			if let birds = birds {
				for bird in birds {
					let pin = NotBirdAnnotation()
					pin.image = UIImage(named: "bird")
					pin.type = "bird"
					pin.batteryColor = bird.battery_level.getColorForBatteryLevel()
					pin.coordinate = CLLocationCoordinate2D(latitude: bird.location.latitude, longitude: bird.location.longitude)
					let annotation = MKPinAnnotationView(annotation: pin, reuseIdentifier: "bird")
					self.mapView.addAnnotation(annotation.annotation!)
				}
			}
		}
		LimeService.shared.getLimes { (limes) in
			if let limes = limes {
				for lime in limes {
					let pin = NotBirdAnnotation()
					pin.image = UIImage(named: "lime")
					pin.type = "lime"
					pin.batteryColor = lime.batteryLevelColor
					pin.coordinate = CLLocationCoordinate2D(latitude: lime.latitude , longitude: lime.longitude)
					let annotation = MKPinAnnotationView(annotation: pin, reuseIdentifier: "lime")
					self.mapView.addAnnotation(annotation.annotation!)
				}
			}
		}

		SpinService.shared.getSpins { (spins) in
			if let spins = spins {
				print(spins.count)
				for spin in spins {
					let pin = NotBirdAnnotation()
					pin.image = UIImage(named: "spin")
					pin.type = "spin"
					pin.batteryColor = spin.batteryLevelColor
					pin.coordinate = CLLocationCoordinate2D(latitude: spin.latitude , longitude: spin.longitude)
					let annotation = MKPinAnnotationView(annotation: pin, reuseIdentifier: "spin")
					self.mapView.addAnnotation(annotation.annotation!)
				}
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			return nil
		}
		if let annotation = annotation as? NotBirdAnnotation {
			switch annotation.type {
			case "bird":
				return BirdAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
			case "lime":
				return LimeAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
			case "spin":
				return SpinAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
			default:
				return nil
			}
		}
		
		if let cluster = annotation as? NotBirdCluster {
			return BirdClusterView(annotation: cluster, reuseIdentifier: "birdCluster")
		}
		return nil
	}
	
	func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
		return NotBirdCluster(memberAnnotations: memberAnnotations)
	}
}



class NotBirdCluster : MKClusterAnnotation {
	//add custom Cluster properties
	override init(memberAnnotations: [MKAnnotation]) {
		super.init(memberAnnotations: memberAnnotations)
	}
}
