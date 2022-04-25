//
//  ProductPage.swift
//  mini-market
//
//  Created by Sunwoo on 2022/04/26.
//

import Foundation

struct ProductPage {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let products: [Product]
    let lastPage: Int
    let hasNextPage: Bool
    let hasPrevPage: Bool
}
