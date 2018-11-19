//
//  SpinService.swift
//  notBird
//

import CoreLocation.CLLocation
import Alamofire

class SpinService {
	
	static let shared = SpinService()
	
	typealias SpinResponseCompletionBlock = ([Spin]?) -> Void
	
	public func getSpinLocations(location: CLLocationCoordinate2D, completion: @escaping SpinResponseCompletionBlock) {
		
		let token = UserDefaults.standard.value(forKey: SpinConstants.SPN_TKN) as! String
		
		let headers: HTTPHeaders = [
			"Authorization" : "Bearer \(token)"
		]
		
		let params : [String : Any] = [
			"lat": location.latitude,
			"lng": location.longitude,
			"distance": 2000,
			"mode" : "undefined"
		]
		
		Alamofire.request(URL(string: "https://web.spin.pm/api/v3/vehicles")!, method: .get, parameters: params, headers: headers).responseJSON { (response) in
			if let error = response.error {
				print(error.localizedDescription)
				completion(nil)
			} else if let data = response.data {
				do {
					guard let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
						  let nearbySpins = response["vehicles"] as? [[String : Any]]
					else {
						print("Error: could not parse Spin API response.")
						return completion(nil)
					}
					completion(nearbySpins.map({ Spin(dicationary: $0) }))
				} catch let error {
					print(error.localizedDescription)
					completion(nil)
				}
			}
		}
	}
}
