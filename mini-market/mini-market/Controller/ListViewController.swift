//
//  ViewController.swift
//  mini-market
//
//  Created by Sunwoo on 2022/04/18.
//

import UIKit

final class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var products: [Product]?
    private let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        setNavigationTitle()
        setProducts()
        self.initRefresh()
    }
    
    private func setProducts() {
        APIService().fetchData(api: ProductListAPI(pageNumber: 1, itemsPerPage: 100), decodingType: ProductPage.self) { data in
            self.products = data.products
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setNavigationTitle() {
        navigationItem.title = "mini-market"
    }
    
    //MARK: - IBAction
    @IBAction func productAddButton(_ sender: UIBarButtonItem) {
        let addStoryboard = UIStoryboard(name: "AddAndEditView", bundle: nil)
        let addViewController = addStoryboard.instantiateViewController(identifier: "AddAndEditViewController") { coder in
            return AddAndEditViewController(coder: coder, page: .add, product: nil)
        }
        
        let addViewNavigationController = UINavigationController(rootViewController: addViewController)
        addViewNavigationController.modalPresentationStyle = .fullScreen
        present(addViewNavigationController, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70.0)
    }
}

//MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        guard let product = products?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.updateView(with: product)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailStoryboard = UIStoryboard(name: "DetailView", bundle: nil)
        let detailViewController = detailStoryboard.instantiateViewController(identifier: "DetailViewController") { coder in
            return DetailViewController(coder: coder, product: self.products?[indexPath.row])
        }
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ListViewController {
    func initRefresh() {
        refresh.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        refresh.backgroundColor = UIColor.clear
        self.tableView.refreshControl = refresh
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.setProducts()
            refresh.endRefreshing()
        }
    }
}
