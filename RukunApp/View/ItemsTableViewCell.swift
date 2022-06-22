//
//  ItemsTableViewCell.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 19/06/22.
//

import UIKit

enum CellType{
    case Item(index: Int, title: String?, quanity: Int, price: Double)
    case Transaction(index: Int, title: String?, date: String, price: Double)
}

class ItemsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondRowContentLabel: UILabel!
    @IBOutlet weak var thirdRowContentLabel: UILabel!
    @IBOutlet weak var secondRowTitleLabel: UILabel!
    @IBOutlet weak var thirdRowTitleLabel: UILabel!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupContent(cellType: CellType){
        switch cellType {
        case .Item(let index, let title, let quanity, let price):
            numberLabel.text = "\(index+1)."
            nameLabel.text = title
            secondRowContentLabel.text = "\(quanity)"
            thirdRowContentLabel.text = "\(price)"
            secondRowTitleLabel.text = "Quantity:"
            thirdRowTitleLabel.text = "Price:"
        case .Transaction(let index, let title, let date, let price):
            numberLabel.text = "\(index+1)."
            nameLabel.text = "Transaction: \(title ?? "")"
            secondRowContentLabel.text = date
            thirdRowContentLabel.text = "\(price)"
            secondRowTitleLabel.text = "Date:"
            thirdRowTitleLabel.text = "Total Price:"
        }
        
    }
    
}
