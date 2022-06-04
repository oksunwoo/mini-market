//
//  ViewController.swift
//  mini-market
//
//  Created by Sunwoo on 2022/04/18.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var products: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        setProducts()
    }
    
    private func setProducts() {
        APIService().fetchData(api: ProductListAPI(pageNumber: 1, itemsPerPage: 100), decodingType: ProductPage.self) { data in
            self.products = data.products
        }
    }
}

//MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
