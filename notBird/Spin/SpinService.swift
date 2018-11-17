//
//  SpinService.swift
//  notBird
//


import Alamofire

class SpinService {
  
  static let shared = SpinService()
  
  typealias SpinResponseCompletionBlock = ([Spin]?) -> Void

  private func getSpinLocations(with token: String, completion: @escaping SpinResponseCompletionBlock) {
	let headers: HTTPHeaders = ["Authorization" : "Bearer \(token)"]
    
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
	
  public func getSpins(_ completion: @escaping SpinResponseCompletionBlock) {
    SpinAuthenticationService.shared.Auth { (token) in
      if let token = token {
        self.getSpinLocations(with: token, completion: { (spins) in
          if let spins = spins {
            completion(spins)
          }
        })
      }
    }
    completion(nil)
  }
}
