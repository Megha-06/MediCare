//
//  APIManager.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import Foundation
enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
}

typealias ResultHandler<T> = (Result<T, DataError>) -> Void

final class APIManager {
    
    static let shared = APIManager()
    private let networkHandler: NetworkHandler
    private let responseHandler: ResponseHandler
    
    init(networkHandler: NetworkHandler = NetworkHandler(),
         responseHandler: ResponseHandler = ResponseHandler()) {
        self.networkHandler = networkHandler
        self.responseHandler = responseHandler
    }
    
    func request<T: Codable>(
        modelType: T.Type,
        type: EndPointType,
        parameters: AnyCodable? = nil,
        completion: @escaping ResultHandler<T>
    ) {
        guard let url = type.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        
        if let bodyParameters = type.body {
            let jsonCompatibleBody = bodyParameters.mapValues { $0.toJSONCompatible() }
            request.httpBody = try? JSONSerialization.data(withJSONObject: jsonCompatibleBody, options: [])
        }
        
        request.allHTTPHeaderFields = type.headers
        
        // Network Request - URL TO DATA
        networkHandler.requestDataAPI(url: request) { result in
            switch result {
            case .success(let data):
                // Json parsing - Decoder - DATA TO MODEL
                self.responseHandler.parseResonseDecode(
                    data: data,
                    modelType: modelType) { response in
                        switch response {
                        case .success(let mainResponse):
                            completion(.success(mainResponse)) 
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    static var categoriesHeaders: [String: String] {
        return [
            "Auth-Token": "4g442d3piu4mr8itfdg86bh5wrqzmbphpkoo7dam4gp27bo9oo",
            "Cookie" : "ci_sessions=dnrdbf5qo67fsocn839q1gesc6vdj3al",
            "ci_sessions" : "ci_sessions=gg5dhmv6dmvapehmcsbsp1au399uo0hn"
        ]
    }
    
    static var productListHeaders: [String: String] {
        return [
            "Auth-Token": "4g442d3piu4mr8itfdg86bh5wrqzmbphpkoo7dam4gp27bo9oo",
            "Content-Type" : "application/json",
            "Cookie" : "ci_sessions:gg5dhmv6dmvapehmcsbsp1au399uo0hn"
        ]
    }
}



class NetworkHandler {
    
    func requestDataAPI(
        url: URLRequest,
        completionHandler: @escaping (Result<Data, DataError>) -> Void
    ) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                      completionHandler(.failure(.invalidResponse))
                      return
                  }
            guard let data = data, error == nil else {
                completionHandler(.failure(.invalidData))
                return
            }
            completionHandler(.success(data))
        }
        session.resume()
    }
}



class ResponseHandler {
    
    func parseResonseDecode<T: Decodable>(
        data: Data,
        modelType: T.Type,
        completionHandler: ResultHandler<T>
    ) {
        do {
            let userResponse = try JSONDecoder().decode(modelType, from: data)
            completionHandler(.success(userResponse))
        }catch {
            completionHandler(.failure(.decoding(error)))
        }
    }
}


