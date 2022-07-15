//
//  APIProtocol.swift
//  mini-market
//
//  Created by Sunwoo on 2022/06/02.
//

import Foundation

protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
}

enum HttpMethod {
    case get
    case post
    case delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}
