//
//  NotBirdMapView.swift
//  notBird
//

import MapKit
import CoreLocation

class NotBirdMapView : MKMapView {
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureView()
	}
	
	var locationManager : CLLocationManager!
	
	var currentUserLocation : CLLocationCoordinate2D {
		return locationManager.location!.coordinate
	}
	
	private func configureView() {
		delegate = self
		
		setupLocationManager()
		setupProperties()
	}
	
	private func setupLocationManager() {
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}
	
	private func setupProperties() {
		showsUserLocation = true
		autoresizingMask = [.flexibleHeight, .flexibleWidth]
		
		register(BirdAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		register(LimeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		register(BirdClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
	}
	
}
extension NotBirdMapView : MKMapViewDelegate {
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
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		print("Selected a view")
	}
}

extension NotBirdMapView : CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			print("location services status = ", status)
		} else if status == .denied || status == .restricted {
			print("Locaiton services disabled.")
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.first?.coordinate else { return }
		setCenter(location, animated: true)
		setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
}
