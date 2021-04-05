//
//  PastOrdersTVCell.swift
//  GoLocalDriver
//
//  Created by C110 on 15/01/21.
//

import UIKit
import Cosmos

class PastOrdersTVCell: UITableViewCell {

    @IBOutlet weak var mainView: CardView!
//    {
//            didSet{
//                mainView.layer.borderWidth = 1
//                mainView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            }
//    }
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDeliveryAddress : UILabel!
    @IBOutlet var lblUserNo: UILabel!
    @IBOutlet var lblTime: MZTimerLabel!
    @IBOutlet weak var vwTimer: UIView!
    var orderRequestTime : TimeInterval = 0.0
    @IBOutlet weak var lbltimerDec: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblDriverName: UILabel!
   
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var imgDottedLine: UIView!{
        didSet{
            
        }
    }
    @IBOutlet weak var viewSecondOrder: UIView!
    @IBOutlet weak var heightSecondOrderView: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var ratingViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var heightLabelOrderId: NSLayoutConstraint!
    @IBOutlet weak var leftPadding: NSLayoutConstraint!
    @IBOutlet weak var rightPadding: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
