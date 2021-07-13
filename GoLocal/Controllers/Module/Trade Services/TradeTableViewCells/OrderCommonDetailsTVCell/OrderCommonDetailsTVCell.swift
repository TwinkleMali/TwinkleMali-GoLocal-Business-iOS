//
//  OrderCommonDetailsTVCell.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 04/05/21.
//

import UIKit

class OrderCommonDetailsTVCell: UITableViewCell {

    @IBOutlet weak var mainView: CardView!
    
    //Customer Info
    @IBOutlet weak var viewCustomerDetails: UIView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblCustomerAddress: UILabel!
    @IBOutlet weak var lblCustomerPhone: UILabel!
    @IBOutlet weak var viewTimer: UIView!
    @IBOutlet weak var labelTimer: MZTimerLabel!
    @IBOutlet weak var lblRemainingTime: UILabel!
    @IBOutlet weak var ViewSaperater1: UIView!
    @IBOutlet weak var btnCallCustomer: UIButton!
    @IBOutlet weak var imgPhone: UIImageView!
    
    // Customer Info past order
    @IBOutlet weak var viewCustomerDetailsPastOrder: UIView!
    @IBOutlet weak var lblPastCustomerName: UILabel!
    @IBOutlet weak var lblPastCustomerAddress: UILabel!
    @IBOutlet weak var lblPasrCustomerPhone: UILabel!
    @IBOutlet weak var imgPastPhone: UIImageView!
    @IBOutlet weak var btnPastCallCustomer: UIButton!
    
    @IBOutlet weak var btnOrderDetails: UIButton!{
        didSet{
            btnOrderDetails.layer.cornerRadius = 5
            btnOrderDetails.layer.borderColor = btnOrderDetails.titleColor(for: .normal)?.cgColor
            btnOrderDetails.layer.borderWidth = 0.8
        }
    }
    @IBOutlet weak var btnNextPayment: UIButton!{
        didSet{
            btnNextPayment.layer.cornerRadius = 5
            btnNextPayment.layer.borderColor = btnNextPayment.titleColor(for: .normal)?.cgColor
            btnNextPayment.layer.borderWidth = 0.8
        }
    }
    
    @IBOutlet weak var viewSaperater2: UIView!
    
    //ServicesDetails
    @IBOutlet weak var viewServicesDetails: UIView!
    @IBOutlet weak var lblRequestedDateTime: UILabel!
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var lblBookingType: UILabel!
    @IBOutlet weak var viewSaperater3: UIView!
     
    //Other Details
    @IBOutlet weak var viewOtherDetails: UIView!
    
    @IBOutlet weak var lblBidAmountTitle: UILabel!
    @IBOutlet weak var lblBidAmount: UILabel!
    @IBOutlet weak var lblArrivalTimeTitle: UILabel!
    @IBOutlet weak var lblArrivalDateTime: UILabel!
    @IBOutlet weak var btnCancel: UIButton!{
        didSet{
            btnCancel.layer.cornerRadius = 5
            btnCancel.layer.borderColor = UIColor.systemRed.cgColor
            btnCancel.layer.borderWidth = 0.8
        }
    }
    
    //OtherDetailsPast
    @IBOutlet weak var viewOtherDetailsPast: UIView!
    @IBOutlet weak var lblAmtTitle: UILabel!
    @IBOutlet weak var lblAmt: UILabel!
    @IBOutlet weak var lblCompletedDate: UILabel!
    @IBOutlet weak var viewStatusDot: UIView!
    
    //OrderButtons
    @IBOutlet weak var viewOrderButton: UIView!
    @IBOutlet weak var btnViewDetails: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func SetUpCell(_ forType : CommonTradeCellUsedFor) {
        switch forType {
        case .ActiveOrder:
            self.viewCustomerDetailsPastOrder.isHidden = false
            self.viewServicesDetails.isHidden = false
            self.viewOtherDetails.isHidden = false
            
            addDashedBorder(withColor: UIColor.lightGray.withAlphaComponent(0.5), view: self.viewSaperater3)
            //addDashedBorder(withColor: UIColor.lightGray.withAlphaComponent(0.5), view: self.viewSaperater2)
            self.viewSaperater2.addBottomBorder(with: UIColor.lightGray.withAlphaComponent(0.5), andWidth: 0.8)
            self.viewOrderButton.isHidden = true
            self.viewCustomerDetails.isHidden = true
            self.viewOtherDetailsPast.isHidden = true
            break
        case .PastOrder:
            self.viewCustomerDetailsPastOrder.isHidden = false
            self.viewServicesDetails.isHidden = false
            self.viewOtherDetailsPast.isHidden = false
            
            addDashedBorder(withColor: UIColor.lightGray.withAlphaComponent(0.5), view: self.viewSaperater3)
//            addDashedBorder(withColor: UIColor.lightGray.withAlphaComponent(0.5), view: self.viewSaperater2)
            self.viewSaperater2.addBottomBorder(with: UIColor.lightGray.withAlphaComponent(0.5), andWidth: 0.8)
            self.viewOrderButton.isHidden = true
            self.viewCustomerDetails.isHidden = true
            self.viewOtherDetails.isHidden = true
            
            break
        case .QuoteationRequest:
            self.viewCustomerDetails.isHidden = false
            self.viewServicesDetails.isHidden = false
            self.viewOrderButton.isHidden = false
            addDashedBorder(withColor: UIColor.lightGray.withAlphaComponent(0.5), view: self.ViewSaperater1)
            viewOrderButton.addTopBorder(with: UIColor.lightGray.withAlphaComponent(0.5), andWidth: 0.8)
            self.viewOtherDetails.isHidden = true
            self.viewCustomerDetailsPastOrder.isHidden = true
            self.viewOtherDetailsPast.isHidden = true
            self.viewCustomerDetailsPastOrder.isHidden = true
            break
        case .RequestDetails:
            self.viewSaperater2.addBottomBorder(with: UIColor.lightGray.withAlphaComponent(0.5), andWidth: 0.8)
            self.viewCustomerDetails.isHidden = false
            self.viewServicesDetails.isHidden = false
            self.viewOtherDetails.isHidden = true
            self.viewOrderButton.isHidden = true
            self.viewOtherDetailsPast.isHidden = true
            self.viewCustomerDetailsPastOrder.isHidden = true
            break
        case .OrderDetails:
            self.viewSaperater2.addBottomBorder(with: UIColor.lightGray.withAlphaComponent(0.5), andWidth: 0.8)
            self.viewCustomerDetailsPastOrder.isHidden = false
            self.viewServicesDetails.isHidden = false
            self.viewOtherDetails.isHidden = true
            self.viewOrderButton.isHidden = true
            self.viewCustomerDetails.isHidden = true
            self.viewOtherDetailsPast.isHidden = true
            break
        }
        //self.layoutIfNeeded()
    }
}
