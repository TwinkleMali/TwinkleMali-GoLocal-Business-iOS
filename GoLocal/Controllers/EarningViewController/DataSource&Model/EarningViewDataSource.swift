//
//  EarningViewDataSource.swift
//  GoLocal
//
//  Created by C100-104 on 19/03/21.
//

import Foundation
class EarningViewDataSource : NSObject{
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: EarningViewModel
    private let viewController: UIViewController
    private var earningViewController : EarningViewController? {
        get{
            viewController as? EarningViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: EarningViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("CommonLeftRightLabelTVCell")
        
        
    }
}
extension EarningViewDataSource : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonLeftRightLabelTVCell", for: indexPath) as? CommonLeftRightLabelTVCell {
            cell.lblLeftValue.numberOfLines = 0
            let name = "Jagjeetsingh Labana"
            let paymentType = "Credit Card"
            let userRedeemPoints = "100"
            let billAmt = "\(CURRENCY_SYMBOL)100"
            cell.lblLeftValue?.attributedText = getAttributedText(name: name, paymentType: paymentType, userRedeemPoints: userRedeemPoints, totalBillAmount: billAmt)
            //text = "Jagjeetsingh Labana\npaymentType : Credit Card\nUser redeemed Points : 100\nTotal bill amount : \(CURRENCY_SYMBOL)100"
            cell.lblRightValue?.text = "07/12/2020"
            return cell
        }
        return UITableViewCell()
    }
    
    func getAttributedText(name:String,paymentType:String,userRedeemPoints:String,totalBillAmount:String) -> NSMutableAttributedString  {
        let size1 = calculateFontForWidth(size: 16)
        let size2 = calculateFontForWidth(size: 14)
        
        let paymentTypeLbl = "\nPayment Type : "
        let userRedeemPointsLbl = "\nUser Redeemed Points : "
        let totalBillAmtLbl = "\nTotal bill amount : "
        
        let nameAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: fFONT_SEMIBOLD, size: size1)!, NSAttributedString.Key.foregroundColor : UIColor.black]
        let labelAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: fFONT_MEDIUM, size: size2)!, NSAttributedString.Key.foregroundColor : UIColor.systemGray2]
        let valueAttributes : [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: fFONT_BOLD, size: size2)!, NSAttributedString.Key.foregroundColor : UIColor.black]
        
        let nameString = NSMutableAttributedString(string: name, attributes: nameAttributes)
        
        let lblPayTypeString = NSMutableAttributedString(string: paymentTypeLbl, attributes: labelAttributes)
        let payTypeValueString = NSMutableAttributedString(string: paymentType, attributes: valueAttributes)
        
        let lblRedeemString = NSMutableAttributedString(string: userRedeemPointsLbl, attributes: labelAttributes)
        let redeemValueString = NSMutableAttributedString(string: userRedeemPoints, attributes: valueAttributes)
        
        let lblTotalAmtString = NSMutableAttributedString(string: totalBillAmtLbl, attributes: labelAttributes)
        let totalAmtValueString = NSMutableAttributedString(string: totalBillAmount, attributes: valueAttributes)
        
        lblTotalAmtString.append(totalAmtValueString)
        redeemValueString.append(lblTotalAmtString)
        lblRedeemString.append(redeemValueString)
        payTypeValueString.append(lblRedeemString)
        lblPayTypeString.append(payTypeValueString)
        nameString.append(lblPayTypeString)
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing =  4
        nameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, nameString.length))
        return nameString
    }
}
