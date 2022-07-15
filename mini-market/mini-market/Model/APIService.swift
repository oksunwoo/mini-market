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
    
    private func request(api: APIProtocol) -> URLRequest? {
        guard let url = api.url else {
            return nil
        }
        
       return URLRequest(url: url)
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
    
    private func makeRegisterDataBody(json: Data, boundary: String, image: AddProductImage) -> Data? {
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
    
    func postData(api: APIProtocol, httpMethod: String, product: AddProduct, image: AddProductImage , completion: @escaping (Result<Data, Error>) -> Void) {
        guard var request = request(api: api) else {
            return
        }
        
        request.httpMethod = httpMethod
        
        let boundary = UUID().uuidString
        let headers: [String: String] = ["Content-Type": "multipart/form-data; boundary=\(boundary)", "identifier": "b82914a6-71fc-11ec-abfa-bb4b58856698"]
        
        headers.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let encodedData = JSONParser().encode(from: product)
        switch encodedData {
        case .success(let data):
            let body = makeRegisterDataBody(json: data, boundary: boundary, image: image)
            request.httpBody = body
        case .failure(_):
            return
        }
        
        loadData(request: request, completion: completion)
    }
    
    func makeDataBody(json: Data, boundary: String) -> Data? {
        
    }
    
    func postSecret(api: APIProtocol) {
        
    }
}
