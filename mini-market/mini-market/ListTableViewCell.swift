//
//  ListTableViewCell.swift
//  mini-market
//
//  Created by Sunwoo on 2022/06/04.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productStockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        productImageView.image = nil
        productStockLabel.textColor = .systemGray
    }
    
    func updateView(with data: Product) {
        loadImage(url: data.thumbnail)
        productNameLabel.text = data.name
        productPriceLabel.text = String(data.currency.rawValue) + " " + format(number: data.bargainPrice)
        updateStockLabel(by: data.stock)
    }

    private func loadImage(url: String) {
        guard let imageURL = URL(string: url), let imageData = try? Data(contentsOf: imageURL), let loadedImage = UIImage(data: imageData) else {
            return
        }
        
        productImageView.image = loadedImage
    }
    
    private func updateStockLabel(by stock: Int) {
        if stock == 0 {
            productStockLabel.text = "품절"
            productStockLabel.textColor = .systemRed
        } else if stock >= 100000 {
            productStockLabel.text = "수량 : 10만 ↑"
        } else {
            productStockLabel.text = "수량 : " + format(number: stock)
        }
    }
    
    private func format(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(for: number) ?? ""
    }
}
