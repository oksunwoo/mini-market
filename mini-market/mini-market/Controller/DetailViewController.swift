//
//  DetailViewController.swift
//  mini-market
//
//  Created by Sunwoo on 2022/07/01.
//

import UIKit

final class DetailViewController: UIViewController {
    private var productID: Int?
    private var productDetail: ProductDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNavigationTitle()
        setProduct()
    }
    
    init?(coder: NSCoder, productID: Int?) {
        self.productID = productID
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigationTitle() {
        navigationItem.title = String(productID!)
    }
    
    private func setProduct() {
        guard let id = productID else {
            return
        }
        
        APIService().fetchData(api: ProductPageAPI(productID: id), decodingType: ProductDetail.self) { data in
            self.productDetail = data
        }
    }
}
