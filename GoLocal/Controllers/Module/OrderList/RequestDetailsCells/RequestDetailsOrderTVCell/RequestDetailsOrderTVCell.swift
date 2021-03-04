//
//  RequestDetailsOrderTVCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 13/01/21.
//

import UIKit

class RequestDetailsOrderTVCell: UITableViewCell {

    @IBOutlet weak var orderDescriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblOrderIdValue: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblOrderDescription: UILabel!
    @IBOutlet weak var lblOrderName: UILabel!
    @IBOutlet weak var imgVegImage: UIImageView!
    @IBOutlet weak var imgWidht : NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnView: UIButton!
    var subProductIndex : Int = 0
    var productId : Int = 0
//    {
//            didSet{
//                mainView.layer.borderWidth = 1
//                mainView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//                
//            }
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
