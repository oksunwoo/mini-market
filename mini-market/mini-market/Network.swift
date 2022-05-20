//
//  Network.swift
//  mini-market
//
//  Created by Sunwoo on 2022/05/20.
//

import Foundation

class APIService {
    func getData(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "https://market-training.yagom-academy.kr/healthChecker") else {
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
}
