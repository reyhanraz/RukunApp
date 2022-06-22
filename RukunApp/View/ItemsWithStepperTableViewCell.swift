//
//  ItemsWithStepperTableViewCell.swift
//  RukunApp
//
//  Created by Reyhan Rifqi on 20/06/22.
//

import UIKit

protocol ItemsWithStepperTableViewCellDelegate: AnyObject{
    func quantityUpdated(index: Int, quantity: Int)
}

class ItemsWithStepperTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    weak var delegate: ItemsWithStepperTableViewCellDelegate?
    private var _index = -1
    private var _price = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupContent(index: Int, title: String?, quanity: Int, price: Double){
        _index = index
        _price = price
        numberLabel.text = "\(index+1)."
        nameLabel.text = title
        quantityTextField.isEnabled = false
        quantityTextField.text = "\(quanity)"
        priceLabel.text = "\(price)"
        totalPriceLabel.text = "\(price * Double(quanity))"
        quantityStepper.value = Double(quanity)
    }
    
    @IBAction func valueChanged(_ sender: UIStepper) {
        totalPriceLabel.text = "\(_price * sender.value)"
        quantityTextField.text = "\(Int(sender.value))"
        delegate?.quantityUpdated(index: _index, quantity: Int(sender.value))
    }
    
    
}
