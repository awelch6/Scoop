//
//  BirdAuthenticationService.swift
//  notBird
//


import Foundation
import Alamofire

class BirdAuthenticationService {
  static let shared = BirdAuthenticationService()
  
  typealias token = String?
  typealias BirdAuthCompletionBlock = (token) -> Void

  private let headers: HTTPHeaders = [
      "Content-Type" : "application/json",
      "Platform" : "ios",
      "Device-Id" : NSUUID().uuidString
      ]

  private var params : Parameters {
    let randomNum = arc4random_uniform(10000) + 1;
    return ["email" : "awe\(randomNum)s@email\(randomNum).com"]
  }

  public func Auth(completion: @escaping BirdAuthCompletionBlock) {
    Alamofire.request(URL(string: "https://api.bird.co/user/login")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
      if let error = response.error {
        print(error.localizedDescription)
        completion(nil)
      } else if let data = response.data {
        do {
          let birdAuthentication = try JSONDecoder().decode(BirdAuthentication.self, from: data)
          completion(birdAuthentication.token)
        } catch let error {
          print(error.localizedDescription)
          completion(nil)
        }
      }
    }
  }
}
