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
    weak var delegate: reloadView?
    
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
        let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
            guard let product = self.product else {
                return
            }
            
            let editStoryboard = UIStoryboard(name: "AddAndEditView", bundle: nil)
            let editViewController = editStoryboard.instantiateViewController(identifier: "AddAndEditViewController"){ coder in
            
                return AddAndEditViewController(coder: coder, page: .edit, product: product)
            }
            
            let editViewNavigationController = UINavigationController(rootViewController: editViewController)
            editViewNavigationController.modalPresentationStyle = .fullScreen
            
            self.present(editViewNavigationController, animated: true, completion: nil)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            let okAction = UIAlertAction(title: "Confirm", style: .default) { _ in
                guard let id = self.product?.id else {
                    return
                }
                let productSecret = ProductSecretAPI(productID: id)
                let secret = ProductSecret(secret: "password")
                
                APIService().postSecret(api: productSecret, httpMethod: productSecret.method.description, secret: secret) { result in
                    switch result {
                    case .success(let secret):
                        print(secret)
                        let userPassword = String(decoding: secret, as: UTF8.self)
                        let productDelete = ProductDeleteAPI(productID: id, userPassword: userPassword)
                        
                        APIService().deleteData(api: productDelete, httpMethod: productDelete.method.description) { result in
                            switch result {
                            case .success(_):
                                self.delegate?.reloadTableView()
                                DispatchQueue.main.async {
                                    let okAction = UIAlertAction(title: "Confirm", style: .default) { _ in
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                    let alert = AlertFactory().createAlert(style: .alert, title: "삭제 완료", message: "제품 정보를 찾을 수 없어 메인화면으로 이동합니다.", actions: okAction)
                                    
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            case .failure(_):
                                DispatchQueue.main.async {
                                    let okAction = UIAlertAction(title: "Confirm", style: .default)
                                    let alert = AlertFactory().createAlert(style: .alert, title: "삭제 실패", message: "본인의 제품만 삭제할 수 있습니다.", actions: okAction)
                                    
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                        
                    case .failure(_):
                        DispatchQueue.main.async {
                            let okAction = UIAlertAction(title: "Confirm", style: .default)
                            let alert = AlertFactory().createAlert(style: .alert, title: "삭제 실패", message: "본인의 제품만 삭제할 수 있습니다.", actions: okAction)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let alert = AlertFactory().createAlert(style: .alert, title: "정말 삭제하시겠습니까?", message: nil, actions: okAction, cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
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
