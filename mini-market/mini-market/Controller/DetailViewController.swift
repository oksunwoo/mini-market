//
//  DetailViewController.swift
//  mini-market
//
//  Created by Sunwoo on 2022/07/01.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productStockLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDiscountedLabel: UILabel!
    
    private var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setView(with: product)
        
    }
    
    init?(coder: NSCoder, product: Product?) {
        self.product = product
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(with product: Product?){
        guard let product = product else {
            return
        }
        
        setNavigation(title: product.name)
        setImageView(url: product.thumbnail)
        setNameLabel(name: product.name)
        setStockLabel(stock: product.stock)
        setPriceLabel(price: product.price, discountedPrice: product.discountedPrice, currency: product.currency)
    }
    
    private func setNavigation(title: String) {
        navigationItem.title = title
    }
    
    private func setImageView(url: String) {
        productImageView.loadImage(url: url)
    }
    
    private func setNameLabel(name: String) {
        productNameLabel.text = name
    }
    
    private func setStockLabel(stock: Int) {
        productStockLabel.text = "수량: " + String(stock)
    }
    
    private func setPriceLabel(price: Int, discountedPrice: Int, currency: Currency) {
        if discountedPrice == 0 {
            productPriceLabel.text = currency.rawValue + " " + price.formatted()
        } else {
            productPriceLabel.text = currency.rawValue + " " + price.formatted()
            productDiscountedLabel.text = currency.rawValue + " " + discountedPrice.formatted()
        }
    }
}
