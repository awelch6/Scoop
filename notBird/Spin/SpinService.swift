//
//  SpinService.swift
//  notBird
//


import Alamofire

class SpinService {
  
  static let shared = SpinService()
  
  typealias SpinResponseCompletionBlock = ([Spin]?) -> Void

  public func getSpinLocations(completion: @escaping SpinResponseCompletionBlock) {
	
	let token = UserDefaults.standard.value(forKey: SpinConstants.SPN_TKN) as! String

	let headers: HTTPHeaders = [
		"Authorization" : "Bearer \(token)"
	]
    
    let params : [String : Any] = [
      "lat": 42.332950,
      "lng": -83.049454,
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
			let nearbySpins = response["vehicles"] as? [[String : Any]] else { return completion(nil) }
			completion(nearbySpins.map({ Spin(dicationary: $0) }))
        } catch let error {
          print(error.localizedDescription)
          completion(nil)
        }
      }
    }
  }
}
