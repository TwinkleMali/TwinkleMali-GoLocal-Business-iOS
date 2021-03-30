//
//  OrderButtonTVCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 15/01/21.
//

import UIKit

class OrderButtonTVCell: UITableViewCell {

    @IBOutlet weak var vwDot: UIView!{
        didSet{
            vwDot.layer.cornerRadius = vwDot.frame.size.width / 2
        }
    }
    @IBOutlet weak var lblOrderTotal: UILabel!
    @IBOutlet weak var lblOrderDescription: UILabel!
    @IBOutlet weak var lblRequestedTime: UILabel!
    @IBOutlet weak var lblUserComment: UILabel!    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var stView: UIStackView!
    @IBOutlet weak var heightvw: NSLayoutConstraint!
    @IBOutlet weak var widhtDetailButton: NSLayoutConstraint!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var buttonConstaints: NSLayoutConstraint!
    
//    {
//            didSet{
//                mainView.layer.borderWidth = 1
//                mainView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            }
//    }
    @IBOutlet weak var btnAccept: UIButton!{
        didSet{
            btnAccept.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var btnReject: UIButton!
    {
        didSet{
            btnReject.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var btnOrderDetail: UIButton!{
        didSet{
            btnOrderDetail.layer.cornerRadius = 7
            btnOrderDetail.layer.borderWidth = 1
            btnOrderDetail.layer.borderColor = GreenCGColor
        }
    }
    @IBOutlet weak var btnOrderStatus: UIButton!{
        didSet{
            btnOrderStatus.layer.cornerRadius = 7
            btnOrderStatus.layer.borderWidth = 1
            btnOrderStatus.layer.borderColor = GreenCGColor
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnOrderDelivered(_ sender: Any) {
    }
    @IBAction func btnOrderDetail(_ sender: Any) {
    }
}
