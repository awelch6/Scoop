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
		switch annotation {
		case _ where annotation is BirdAnnotation:
			return BirdAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		case _ where annotation is LimeAnnotation:
			return LimeAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		case _ where annotation is SpinAnnotation:
			return SpinAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
		case _ where annotation is NotBirdCluster:
			return BirdClusterView(annotation: annotation, reuseIdentifier: "birdCluster")
		default:
			return nil
		}
	}
	
	func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
		return NotBirdCluster(memberAnnotations: memberAnnotations)
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		switch view {
		case _ where view is BirdAnnotationView:
			print((view as? BirdAnnotationView)?.birdAnnotation?.bird as Any)
		case _ where view is LimeAnnotationView:
			print((view as? LimeAnnotationView)?.limeAnnotation?.lime as Any)
		case _ where view is SpinAnnotationView:
			print((view as? SpinAnnotationView)?.spinAnnotation?.spin as Any)
		default:
			break
		}
	}
}

extension NotBirdMapView : CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			//TODO: ...
		} else if status == .denied || status == .restricted {
			//TODO: handle when location services are disabled.
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
