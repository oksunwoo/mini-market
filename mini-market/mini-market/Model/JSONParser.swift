//
//  JSONParser.swift
//  mini-market
//
//  Created by Sunwoo on 2022/05/22.
//

import Foundation

struct JSONParser<Item: Codable> {
    func decode(from json: Data?) -> Result<Item,JSONParseError> {
        guard let data = json else {
            return .failure(.decodingFail)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let decodedData = try? decoder.decode(Item.self, from: data) else {
            return .failure(.decodingFail)
        }
        
        return .success(decodedData)
    }
}
