//
//  APIService.swift
//  mini-market
//
//  Created by Sunwoo on 2022/05/20.
//

import Foundation

struct APIService {
    private func request(api: APIProtocol) -> URLRequest? {
        guard let url = api.url else {
            return nil
        }
         
        return URLRequest(url: url)
    }
    
    private func loadData(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
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
    
    func fetchData<T: Codable>(api: APIProtocol, decodingType: T.Type, completion: @escaping (_ data: T) -> Void) {
        guard let request = request(api: api) else {
            return
        }
        
        loadData(request: request) { result in
            switch result {
            case .success(let data):
                let decodeData = JSONParser<T>().decode(from: data)
                
                switch decodeData {
                case .success(let decodedData):
                    completion(decodedData)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
