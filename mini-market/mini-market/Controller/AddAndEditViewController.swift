//
//  AddAndEditViewController.swift
//  mini-market
//
//  Created by Sunwoo on 2022/07/01.
//

import UIKit

final class AddAndEditViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productDiscountedPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var addImageButton: UIButton!
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        return imagePicker
    }()
    
    private var addImage: AddProductImage?
    private let page: Mode
    
    enum Mode {
        case edit
        case add
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboardObserver()
        setImageView()
        setNavigationTitle(page: page)
        setImageAddButton(page: page)
        // Do any additional setup after loading the view.
    }
    
    init?(coder: NSCoder, page: Mode) {
        self.page = page
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        guard let product = makeProduct(), let image = addImage else {
            return
        }
        
        let productRegister = ProductAddAPI()
        
        APIService().postData(api: productRegister, httpMethod: productRegister.method.description, product: product, image: image) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setNavigationTitle(page: Mode) {
        switch page {
        case .edit:
            navigationItem.title = "상품 수정"
        case .add:
            navigationItem.title = "상품 등록"
        }
    }
    
    private func setImageView() {
        productImageView.layer.cornerRadius = 5
    }
    
    private func setImageAddButton(page: Mode) {
        switch page {
        case .edit:
            addImageButton.layer.isHidden = true
        case .add:
            addImageButton.layer.isHidden = false
        }
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

//MARK: - imagePicker
extension AddAndEditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBAction func addProductImageButton(_ sender: UIButton) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: false) {
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                return
            }
            
            self.addImage = AddProductImage(name: "image", type: .jpeg, image: image)
            self.productImageView.image = image
        }
    }
}

//MARK: - keyboard
extension AddAndEditViewController {
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}
