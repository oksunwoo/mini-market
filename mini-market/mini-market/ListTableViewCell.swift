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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(with data: Product) {
        productNameLabel.text = data.name
        productPriceLabel.text = String(data.bargainPrice)
        productStockLabel.text = String(data.stock)
    }

}
