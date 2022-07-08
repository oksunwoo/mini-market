//
//  Data+Extension.swift
//  mini-market
//
//  Created by Sunwoo on 2022/07/08.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        
        self.append(data)
    }
}
