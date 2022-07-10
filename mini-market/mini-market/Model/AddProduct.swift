//
//  AddProduct.swift
//  mini-market
//
//  Created by Sunwoo on 2022/07/04.
//

import Foundation

struct AddProduct: Codable {
    let name: String
    let descriptions: String
    let price: Double
    let discountedPrice: Double?
    let currency: Currency
    let stock: Int?
    var secret: String = "t_#_X=&@H=bTT4t+"
}
