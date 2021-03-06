//
//  MarketURL.swift
//  mini-market
//
//  Created by Sunwoo on 2022/05/25.
//

import Foundation

struct MarketURL: URLProtocol {
    var baseURL = "https://market-training.yagom-academy.kr/"
}

struct HealthCheckerAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(baseURL: URLProtocol = MarketURL()) {
        self.url = URL(string: "\(baseURL.baseURL)" + "healthChecker")
    }
}

struct ProductDetailAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(id: Int, baseURL: URLProtocol = MarketURL()) {
        self.url = URL(string: "\(baseURL.baseURL)" + "api/products/"+"\(id)")
    }
}

struct ProductListAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(pageNumber: Int, itemsPerPage: Int, baseURL: URLProtocol = MarketURL()) {
        self.url = URL(string: "\(baseURL.baseURL)" + "api/products/?page_no=" + "\(pageNumber)" + "&items_per_page=" + "\(itemsPerPage)")
    }
}

struct ProductAddAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .post
    
    init(baseURL: URLProtocol = MarketURL()) {
        self.url = URL(string: "\(baseURL.baseURL)" + "api/products")
    }
}

struct ProductPageAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .get
    
    init(baseURL: URLProtocol = MarketURL(), productID: Int) {
        self.url = URL(string: "\(baseURL.baseURL)" + "api/products/\(productID)")
    }
}

struct ProductSecretAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .post
    
    init(baseURL: URLProtocol = MarketURL(), productID: Int) {
        self.url = URL(string: "\(baseURL.baseURL)" + "api/products/\(productID)/secret")
    }
}

struct ProductDeleteAPI: APIProtocol {
    var url: URL?
    var method: HttpMethod = .delete
    
    init(baseURL: URLProtocol = MarketURL(), productID: Int, userPassword: String) {
        self.url = URL(string: "\(baseURL.baseURL)" + "api/products/\(productID)/\(userPassword)")
    }
}
