//
//  NetworkError.swift
//  mini-market
//
//  Created by Sunwoo on 2022/05/20.
//

import Foundation

enum NetworkError: Error {
    case requestError
    case statusCodeError
    case unknownError
    case urlIsNil
}
