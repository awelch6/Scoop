//
//  LimeAuthentication.swift
//  notBird
//


import Foundation
import Alamofire

class LimeAuthenticationService {
  static let shared = LimeAuthenticationService()
  
  typealias token = String?
  typealias LimeAuthCompletionBlock = (token) -> Void

  private let headers: HTTPHeaders = [
      "Content-Type" : "application/json"
  ]

  private var params : Parameters {
    return ["phone" : ""]
  }
  public func Auth(completion: @escaping LimeAuthCompletionBlock) {
    Alamofire.request(URL(string: "https://web-production.lime.bike/api/rider/v1/login?")!, method: .get, parameters: params, headers: headers).responseJSON { (response) in
      if let error = response.error {
        print(error.localizedDescription)
        completion(nil)
      } else if let data = response.data {
        do {
//          print(try JSONSerialization.jsonObject(with: data, options: []))
//          let limeAuth = try JSONDecoder().decode(limeAuth.self, from: data)
//          completion(limeAuth.token)
        } catch let error {
          print(error.localizedDescription)
          completion(nil)
        }
      }
    }
  }
}
