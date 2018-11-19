//
//  BirdService.swift
//  notBird
//


import CoreLocation.CLLocation
import Alamofire

class BirdService {
	static let shared = BirdService()
	
	typealias BirdResponseCompletionBlock = ([Birds]?) -> Void
	
	public func getBirdLocations(location: CLLocationCoordinate2D, completion: @escaping BirdResponseCompletionBlock) {
		
		let token = UserDefaults.standard.value(forKey: BirdConstants.BRD_TKN) as! String

		let headers: HTTPHeaders = [
			"Authorization" : "Bird \(token)",
			"App-Version" : "3.0.5",
			"Location" : "{\"latitude\":\(location.latitude),\"longitude\":\(location.longitude),\"altitude\":500,\"accuracy\":100,\"speed\":-1,\"heading\":-1}"
		]
		
		let params : [String : Any] = [
			"latitude": location.latitude,
			"longitude": location.longitude,
			"radius": 1000
		]
		
		Alamofire.request(URL(string: "https://api.bird.co/bird/nearby")!, method: .get, parameters: params, headers: headers).responseJSON { (response) in
			if let error = response.error {
				print(error.localizedDescription)
				completion(nil)
			} else if let data = response.data {
				do {
					let bird = try JSONDecoder().decode(Bird.self, from: data)
					completion(bird.birds)
				} catch let error {
					print(error.localizedDescription)
					completion(nil)
				}
			}
		}
	}
}
