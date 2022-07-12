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
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    private func setStockLabel(stock: Int) {
        if stock == 0 {
            productStockLabel.text = "품절"
            productStockLabel.textColor = .systemRed
        } else {
            productStockLabel.text = "남은수량: " + String(stock)
            productStockLabel.textColor = .systemGray
        }
        
    }
    
    private func setPriceLabel(price: Int, discountedPrice: Int, currency: Currency) {
        if discountedPrice == 0 {
            productPriceLabel.text = currency.rawValue + " " + price.formatted()
        } else {
            productPriceLabel.text = currency.rawValue + " " + price.formatted()
            productPriceLabel.textColor = .systemRed
            productPriceLabel.attributedText = productPriceLabel.text?.strikeThrough()
            productDiscountedLabel.text = currency.rawValue + " " + discountedPrice.formatted()
        }
    }
    
    @IBAction func DeleteOrEditButton(_ sender: UIBarButtonItem) {
        let editAction = UIAlertAction(title: "Edit", style: .default)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let alert = AlertFactory().createAlert(actions: editAction, deleteAction, cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
}
