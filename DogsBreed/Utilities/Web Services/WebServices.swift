//  WebServices.swift
//  DogsBreed
//  Created by Sazid Saifi on 09/07/24.

import Foundation
import Alamofire
import SwiftyJSON

enum NetworkError: Error {
    
    case decodingError(String)
    case domainError(String)
    case urlError(String)
    case networkError(String)
    case serverErorr(String)
    
    func get() -> String {
        switch self {
        case .decodingError(let error):
            return error
        case .domainError(let error):
            return error
        case .urlError(let error):
            return error
        case .networkError(let error):
            return error
        case .serverErorr(let error):
            return error
        }
    }
}

enum ErrorDescription: String {
    case decodingErrorDesc = "Server not found. Please try again later."
    case domainErrorDesc = "Server Not Found!"
    case urlErrorDesc = "Unauthorized Access!"
    case networkErrorDesc = "You have a poor network connection. Please reconnect & try again."
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIKey: String {
    case apiKey = "sBES0NksSthaizzle2021ZmMbg8F6Bo87A"
}

struct Resource<T: Codable> {
    let url: URL
    var httpMethods: HttpMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

class WebService {
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T,NetworkError>,Data?) -> Void) {
        
        if Connectivity.isConnectedToInternet {
            var request = URLRequest(url: resource.url)
            request.httpMethod = resource.httpMethods.rawValue
            request.httpBody = resource.body
      
                request.allHTTPHeaderFields = [
                    "Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"
                ]
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(.domainError(ErrorDescription.decodingErrorDesc.rawValue)), nil)
                    return
                }
                print(JSON(data))
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        let result = try? JSONDecoder().decode(T.self, from: data)
                        if let result = result {
                            DispatchQueue.main.async {
                                completion(.success(result), data)
                            }
                        } else {
                            completion(.failure(.domainError(ErrorDescription.decodingErrorDesc.rawValue)), nil)
                        }
                    } else {
                        let result = try? JSONDecoder().decode(ErrorModel.self, from: data)
                        if let result = result {
                            DispatchQueue.main.async {
                                completion(.failure(.serverErorr(result.message ?? "Server Not Found.")), nil)
                            }
                        } else {
                            completion(.failure(.domainError(ErrorDescription.decodingErrorDesc.rawValue)), nil)
                        }
                    }
                } else {
                    completion(.failure(.domainError(ErrorDescription.decodingErrorDesc.rawValue)), nil)
                }
            }.resume()
        } else {
            completion(.failure(.domainError(ErrorDescription.networkErrorDesc.rawValue)), nil)
        }
    }
}

//MARK: -> Connectivity
struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()
    static var isConnectedToInternet:Bool {
        return self.sharedInstance?.isReachable ?? false
    }
}
