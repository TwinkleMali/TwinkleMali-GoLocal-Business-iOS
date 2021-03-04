//
//  OrderDetailsTVCell.swift
//  GoLocal
//
//  Created by C110 on 01/02/21.
//


import UIKit

class OrderDetailsTVCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    @IBOutlet weak var lblItemTotal: UILabel!
    @IBOutlet weak var lblServiceCharge: UILabel!
    @IBOutlet weak var lblShoppingFeeTotal: UILabel!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblOrderDiscount: UILabel!
    @IBOutlet weak var lblCouponDiscount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var lblValue: UILabel! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
