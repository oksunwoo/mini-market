//
//  ImageData.swift
//  mini-market
//
//  Created by Sunwoo on 2022/07/11.
//

import Foundation

struct ImageData: Codable {
    let id: Int
    let url: String
    let thumnailUrl: String
    let succed: Bool
    let issuedAt: String
}
