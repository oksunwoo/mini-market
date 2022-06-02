//
//  APIService.swift
//  mini-market
//
//  Created by Sunwoo on 2022/05/20.
//

import Foundation

struct HealthCheckerAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(baseURL: URLProtocol = MarketURL()) {
        self.url = URL(string: "\(baseURL.baseURL)" + "healthChecker")
    }
}

struct ProductDetailAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(id: Int, baseURL: URLProtocol = MarketURL()) {
        self.url = URL(string: "\(baseURL.baseURL)" + "api/products/"+"\(id)")
    }
}

class APIService {
    func getData(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = HealthCheckerAPI().url else {
            completion(.failure(NetworkError.urlIsNil))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.requestError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                      completion(.failure(NetworkError.statusCodeError))
                      return
                  }
            
            guard let data = data else {
                completion(.failure(NetworkError.unknownError))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    func requestProduct(id: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = ProductDetailAPI(id: id).url else {
            completion(.failure(NetworkError.urlIsNil))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.requestError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.statusCodeError))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.unknownError))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
}
