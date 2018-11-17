//
//  BirdService.swift
//  notBird
//


import Foundation
import Alamofire

class BirdService {
  static let shared = BirdService()
  
  typealias BirdResponseCompletionBlock = ([Birds]?) -> Void

  private func getBirdLocations(with token: String, completion: @escaping BirdResponseCompletionBlock) {
    let headers: HTTPHeaders = [
      "Authorization" : "Bird \(token)",
      "App-Version" : "3.0.5",
      "Location" : "{\"latitude\":42.332950,\"longitude\":-83.049454,\"altitude\":500,\"accuracy\":100,\"speed\":-1,\"heading\":-1}"
      ]
    let params : [String : Any] = [
      "latitude": 42.332950,
      "longitude": -83.049454,
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
  public func getBirds(_ completion: @escaping BirdResponseCompletionBlock) {
    BirdAuthenticationService.shared.Auth { (token) in
      if let token = token {
        self.getBirdLocations(with: token, completion: { (birds) in
          if let birds = birds {
            completion(birds)
          }
        })
      }
      completion(nil)
    }
  }
}
