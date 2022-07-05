//
//  AddAndEditViewController.swift
//  mini-market
//
//  Created by Sunwoo on 2022/07/01.
//

import UIKit

class AddAndEditViewController: UIViewController {

    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productDiscountedPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productImageView.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        
    }
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func makeProduct() -> AddProduct? {
        guard let productName = productNameTextField.text,
              let productStringPrice = productPriceTextField.text,
              let productStringDiscountedPrice = productDiscountedPriceTextField.text,
              let productStringStock = productStockTextField.text,
              let productDescription = productDescriptionTextView.text,
              let productStringCurrency = currencySegmentedControl.titleForSegment(at: currencySegmentedControl.selectedSegmentIndex) else {
                  return nil
              }
        
        guard let productPrice = Double(productStringPrice),
              let productDiscountedPrice = Double(productStringDiscountedPrice),
              let productStock = Int(productStringStock),
              let productCurrency = Currency(rawValue: productStringCurrency) else {
                  return nil
              }
        
        return AddProduct(name: productName, descriptions: productDescription, price: productPrice, discountedPrice: productDiscountedPrice, currency: productCurrency, stock: productStock)
    }
}

extension AddAndEditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBAction func addProductImageButton(_ sender: UIButton) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: false) {
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                return
            }
            
            self.productImageView.image = image
        }
    }
}
