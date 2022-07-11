//
//  ProductDetail.swift
//  mini-market
//
//  Created by Sunwoo on 2022/07/11.
//

import Foundation

struct ProductDetail: Codable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let description: String
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    let images: [ImageData]
}
