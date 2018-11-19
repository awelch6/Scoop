//
//  NotBirdClusterAnnotation.swift
//  notBird


import MapKit

class NotBirdCluster : MKClusterAnnotation {
	//add custom Cluster properties
	override init(memberAnnotations: [MKAnnotation]) {
		super.init(memberAnnotations: memberAnnotations)
	}
}
