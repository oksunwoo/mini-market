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
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                      print("error")
                      return
                  }
            
            guard let data = data else {
                print("error")
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}
