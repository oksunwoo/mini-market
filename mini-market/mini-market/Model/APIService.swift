//
//  APIService.swift
//  mini-market
//
//  Created by Sunwoo on 2022/05/20.
//

import Foundation

struct APIService {
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
    
    func request(api: APIProtocol, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = api.url else {
            completion(.failure(NetworkError.urlIsNil))
            return
        }
    
        let request = URLRequest(url: url)
        loadData(request: request, completion: completion)
    }
    
    func fetchData<T: Codable>(api: APIProtocol, decodingType: T.Type, completion: @escaping (_ data: T) -> Void) {
        request(api: api) { result in
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
    
    func makeRegisterDataBody(json: Data, boundary: String, image: AddProductImage) -> Data? {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        body.append(boundaryPrefix)
        body.append("Content-Disposition: form-data; name=\"params\"\r\n")
        body.append("Content-Type: application/json\r\n\r\n")
        body.append(json)
        body.append("\r\n")
        
        guard let imageData = makeRegisterImageData(image: image, boundary: boundaryPrefix) else {
            return nil
        }
        
        body.append(imageData)
        body.append("--\(boundary)--\r\n")
        
        return body
    }
    
    private func makeRegisterImageData(image: AddProductImage, boundary: String) -> Data? {
        guard let fileData = image.data else {
            return nil
        }
        
        let fileName = image.fileName
        let type = "image/\(image.type.description)"
        var data = Data()
        
        data.append(boundary)
        data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName)\"\r\n")
        data.append("Content-Type: \(type)\r\n\r\n")
        data.append(fileData)
        data.append("\r\n")
        
        return data
    }
    
}
