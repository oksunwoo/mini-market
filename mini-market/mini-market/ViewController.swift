//
//  ViewController.swift
//  mini-market
//
//  Created by Sunwoo on 2022/04/18.
//

import UIKit

class ViewController: UIViewController {
    let api = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkAPIData()
        request()
    }
    
    func checkAPIData() {
        api.getData { result in
            switch result {
            case .success(let data):
                let result = String(data: data, encoding: .utf8)
                print(result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func request() {
        api.requestProduct(id: 224) { result in
            switch result {
            case .success(let data):
                let product = try? JSONParser<Product>().decode(from: data).get()
                print(product?.name)
            case .failure(let error):
                print(error)
            }
        }
    }

}

