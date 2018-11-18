//
//  LimeService.swift
//  notBird
//


import Foundation
import Alamofire

class LimeService {
	static let shared = LimeService()
	
	typealias LimeResponseCompletionBlock = ([Lime]?) -> Void
	
	public func getLimeLocations(completion: @escaping LimeResponseCompletionBlock) {
		
		let token = UserDefaults.standard.value(forKey: LimeConstants.LME_TKN) as! String
		
		let headers: HTTPHeaders = [
			"Authorization" : "Bearer \(token)",
			]
		
		let params : [String : Any] = [
			"map_center_latitude" : 42.332950,
			"map_center_longitude" : -83.049454,
			"user_latitude" : 42.332950,
			"user_longitude" : -83.049454,
			]
		
		Alamofire.request(URL(string: "https://web-production.lime.bike/api/rider/v1/views/main")!, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
			if response.error != nil {
				completion(nil)
			} else if let data = response.data {
				var limes = [Lime]()
				guard let nearbyLimes = self.parseLimeAPIResponse(data: data) else { return completion(nil) }
				
				for lime in nearbyLimes {
					if let lime = self.parseLimeObject(limeObject: lime) {
						limes.append(lime)
					}
				}
				completion(limes)
			}
		}
	}
	
	private func parseLimeAPIResponse(data: Data) -> [[String : Any]]? {
		do {
			guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
				let data = json["data"] as? [String : Any],
				let attributes = data["attributes"] as? [String : Any],
				let nearbyLimes = attributes["nearby_locked_bikes"] as? [[String : Any]]
				else {
					return nil
			}
			return nearbyLimes
		} catch let error {
			print(error.localizedDescription)
			return nil
		}
	}
	
	private func parseLimeObject(limeObject: [String : Any]) -> Lime? {
		guard let id = limeObject["id"] as? String,
			let attributes = limeObject["attributes"] as? [String : Any]
			else {
				return nil
		}
		return Lime(id: id, attributes: attributes)
	}
}
