//
//  TradeOrderDetailsViewDataSource.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 09/06/21.
//

import Foundation
import KRProgressHUD
import SwiftyJSON
import Alamofire
class TradeOrderDetailsViewDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: TradeOrderDetailsViewModel
    private let viewController: UIViewController
    private var tradeOrderDetailsViewController : TradeOrderDetailsViewController? {
        get{
            viewController as? TradeOrderDetailsViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: TradeOrderDetailsViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("OrderCommonDetailsTVCell")
        tableView.register("CommonButtonTVCell")
        tableView.register("SingleAddonsItemTVCell")
        tableView.register("ZigZagfooterTVCell")
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 45, right: 0)
    }
}
extension TradeOrderDetailsViewDataSource : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = viewModel.getOrderDetails() {
            return 6
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == TradeOrderDetailScreenField.billDetails.rawValue ,let cell = tableView.dequeueReusableCell(withIdentifier: "SingleAddonsItemTVCell") as? SingleAddonsItemTVCell {
            cell.selectionStyle = .none
            cell.viewAddOnItem.isHidden = true
            cell.viewAddOnCategory.isHidden = false
            cell.viewAddOnCategory.backgroundColor = .clear
            cell.viewTopSaprator.isHidden = true
            cell.lblCategoryType.text = ""
            cell.lblCategoryName.text = "Bill Details"
            cell.lblCategoryName?.font = UIFont(name: fFONT_BOLD, size: calculateFontForWidth(size: 17))
            cell.lblCategoryName?.textColor = .black
            return cell
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == TradeOrderDetailScreenField.billDetails.rawValue ? 30 : 0.001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 1, width: tableView.bounds.width, height: 0.8))
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if TradeOrderDetailScreenField.note.rawValue == section {
            if let data = viewModel.getOrderDetails() ,let businessQuotationDetail = data.businessQuotationDetail ,let note = businessQuotationDetail.quoteDesc ,note.count > 0{
                return 2
            } else {
                return 0.001
            }
        } else if TradeOrderDetailScreenField.billDetails.rawValue == section {
            return 0.001
        } else if TradeOrderDetailScreenField.separator.rawValue == section {
            return 0.001
        }  else if TradeOrderDetailScreenField.buttons.rawValue == section {
            return 0.001
        } else {
            return 2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TradeOrderDetailScreenField(rawValue: section)! {
        case .CustomerAndServiceDetails:
            return 1
        case .PaymentDetails:
            return 3
        case .note:
            return 1
        case .billDetails:
            return 5
        case .separator:
            return 1
        case .buttons:
            if viewModel.isPastOrder() {
                return 1
            } else {
                return viewModel.getOrderDetails()?.businessQuotationDetail?.tradeRequestBillingDetails?.isPaymentDone ?? false ? 2 : 3
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        switch TradeOrderDetailScreenField(rawValue: section)! {
        case .CustomerAndServiceDetails:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCommonDetailsTVCell", for: indexPath) as? OrderCommonDetailsTVCell {
                cell.SetUpCell(.OrderDetails)
                if let order = viewModel.getOrderDetails() ,let request = order.serRequest{
                    let dateStr =  request.createdAt ?? ""
                    let date = dateStr.toDate()?.UTCtoLocal(format: "dd/MM/yyyy") ?? ""
                    let time = dateStr.toDate()?.UTCtoLocal(format: "hh:mm a") ?? ""
                    cell.lblRequestedDateTime.text = "\(date) at \(time.uppercased())"
                    cell.lblRequestedDateTime.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 17))
                    cell.mainView.shadowColor = .clear
                    if let customer = request.customerDetails {
                        let name = customer.name ?? ""
                        let lName = customer.lname ?? ""
                        cell.lblPastCustomerName.text = name + " " + lName
                        cell.lblPastCustomerName.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 17))
                        let phone = customer.phone ?? ""
                        let countryCode = customer.countryCode ?? 00
                        
                        cell.lblCustomerPhone.text = "+\(countryCode) \(phone)"
                        cell.lblCustomerPhone.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 13))
                        
                        cell.imgPastPhone.isHidden = false
                        cell.btnPastCallCustomer.isHidden = false
                        cell.btnPastCallCustomer.isUserInteractionEnabled = true
                        cell.btnPastCallCustomer.accessibilityHint = "+\(customer.countryCode ?? 0)\(customer.phone ?? "")"
                        cell.btnPastCallCustomer.addTarget(self, action: #selector(CallCustomer(_:)), for: .touchUpInside)
                        
                        cell.lblCustomerAddress.text = request.userAddress ?? ""
                        cell.lblCustomerAddress.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                        
                    }
                    if let arrQueAns = request.questionAnswers{
                        let result = arrQueAns.filter({($0.isEmergency ?? 0) == 1})
                        if result.count > 1 , let queAns = result.first{
                            cell.lblBookingType.text = (queAns.optionValue ?? "") == "Yes" ? "Emergency" : "General"
                            cell.lblBookingType.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                        }
                    }
                    if let arrServiceType = request.serviceCategories, let serviceType = arrServiceType.first{
                        cell.lblServiceType.text = serviceType.serviceName
                        cell.lblServiceType.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                    }
                    if let businessQuotationDetail = order.businessQuotationDetail ,let billingDetails = businessQuotationDetail.tradeRequestBillingDetails{
                        cell.lblBidAmount.text = (billingDetails.bidAmount ?? 0).getAmountInString()
                    }
                    cell.lblBidAmountTitle.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                    cell.lblArrivalTimeTitle.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                    cell.lblBidAmount.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 15))
                    cell.lblArrivalDateTime.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 15))
                    
                    cell.btnNextPayment.isHidden = true
                    if self.viewModel.isPastOrder() {
                        cell.btnOrderDetails.isHidden = true
                    } else {
                        cell.btnOrderDetails.isHidden = order.businessQuotationDetail?.tradeRequestBillingDetails?.isPaymentDone ??  false
                    }
                    cell.btnOrderDetails.setTitle("  Cancel Service  ", for: .normal)
                    cell.btnOrderDetails.setTitleColor(.systemRed, for: .normal)
                    cell.btnOrderDetails.titleLabel?.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 10))
                    cell.btnOrderDetails.layer.borderColor = UIColor.systemRed.cgColor
                    cell.btnOrderDetails.addTarget(self, action: #selector(cancelTradeService(_:)), for: .touchUpInside)
                    if let arrRequestSchedule = request.requestSchedule{
                        let requestSchedule = arrRequestSchedule[0]
                        let dateStr =  requestSchedule.startRequestDatetime
                        let date = dateStr?.toDate()?.UTCtoLocal(format: "dd/MM/yyyy") ?? ""
                        let time = dateStr?.toDate()?.UTCtoLocal(format: "hh:mm a") ?? ""
                        cell.lblArrivalDateTime.text = "\(date) at \(time.uppercased())"
                    }
                    
                }

                
                cell.layoutIfNeeded()
                return cell
            }
        case .PaymentDetails:
            if  row == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "Details Cell")
                cell.selectionStyle = .none
                cell.textLabel?.numberOfLines = 0
                if let data = viewModel.getOrderDetails() ,let businessQuotationDetail = data.businessQuotationDetail{
                    cell.textLabel?.attributedText = getAttributedText(value1: "Payment Way", value2: businessQuotationDetail.depositOption ?? "")
                }
                cell.addBottomBorder(with: UIColor.lightGray.withAlphaComponent(0.8), andWidth: 0.8)
                return cell
            } else if  row == 1 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "Details Cell")
                cell.selectionStyle = .none
                cell.textLabel?.numberOfLines = 0
                if let data = viewModel.getOrderDetails() ,let payment = data.businessQuotationDetail?.tradeRequestBillingDetails{
                    cell.textLabel?.attributedText = getAttributedText(value1: "Amount", value2: (payment.totalAmount ?? 0).getAmountInString())
                }
                cell.addBottomBorder(with: UIColor.lightGray.withAlphaComponent(0.8), andWidth: 0.8)
                return cell
            } else if  row == 2 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "Details Cell")
                cell.textLabel?.numberOfLines = 0
                if let data = viewModel.getOrderDetails() ,let paymentOptions = data.businessQuotationDetail?.paymentOptions{
                    let arrcards = paymentOptions.map({$0.paymentOption ?? ""})
                    let cards = arrcards.joined(separator: ",")
                    cell.textLabel?.attributedText = getAttributedText(value1: "Confirm Payment Option", value2: cards)
                }
                cell.addBottomBorder(with: UIColor.lightGray.withAlphaComponent(0.8), andWidth: 0.8)
                cell.selectionStyle = .none
                return cell
            }
        case .note:
            if let data = viewModel.getOrderDetails() ,let businessQuotationDetail = data.businessQuotationDetail ,let note = businessQuotationDetail.quoteDesc ,note.count > 0{
                let cell = UITableViewCell(style: .default, reuseIdentifier: "Details Cell")
                cell.selectionStyle = .none
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.attributedText = getAttributedText(value1: "Note", value2: note)
                return cell
            }
        case .billDetails:
            if let data = viewModel.getOrderDetails() ,let payment = data.businessQuotationDetail?.tradeRequestBillingDetails{
            switch row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SingleAddonsItemTVCell", for: indexPath) as? SingleAddonsItemTVCell {
                    cell.selectionStyle = .none
                    cell.viewAddOnItem.isHidden = true
                    cell.viewAddOnCategory.isHidden = false
                    cell.viewAddOnCategory.backgroundColor = .clear
                    cell.viewTopSaprator.isHidden = true
                    cell.btnInfo.isHidden = true
                    
                    cell.lblCategoryName?.text = "Bid Amount"
                    cell.lblCategoryName?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15))
                    cell.lblCategoryName?.textColor = .gray
                    
                    cell.lblCategoryType?.text = (payment.bidAmount ?? 0).getAmountInString()
                    cell.lblCategoryType?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15))
                    cell.lblCategoryType?.textColor = .gray
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SingleAddonsItemTVCell", for: indexPath) as? SingleAddonsItemTVCell {
                    cell.selectionStyle = .none
                    cell.viewAddOnItem.isHidden = true
                    cell.viewAddOnCategory.isHidden = false
                    cell.viewAddOnCategory.backgroundColor = .clear
                    cell.viewTopSaprator.isHidden = true
                    cell.btnInfo.isHidden = true
                    
                    cell.lblCategoryName?.text = "Service Total"
                    cell.lblCategoryName?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15))
                    cell.lblCategoryName?.textColor = .gray
                    
                    cell.lblCategoryType?.text = (payment.serviceCharge ?? 0).getAmountInString()
                    cell.lblCategoryType?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15))
                    cell.lblCategoryType?.textColor = .gray
                    return cell
                }
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SingleAddonsItemTVCell", for: indexPath) as? SingleAddonsItemTVCell {
                    cell.selectionStyle = .none
                    cell.viewAddOnItem.isHidden = true
                    cell.viewAddOnCategory.isHidden = false
                    cell.viewAddOnCategory.backgroundColor = .clear
                    cell.viewTopSaprator.isHidden = true
                    cell.btnInfo.isHidden = true
                    
                    cell.lblCategoryName?.text = "Extra Bid"
                    cell.lblCategoryName?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15))
                    cell.lblCategoryName?.textColor = .gray
                    
                    cell.lblCategoryType?.text = (payment.extraCharge ?? 0).getAmountInString()
                    cell.lblCategoryType?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15))
                    cell.lblCategoryType?.textColor = .gray
                    return cell
                }
            case 3:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SingleAddonsItemTVCell", for: indexPath) as? SingleAddonsItemTVCell {
                    cell.selectionStyle = .none
                    cell.viewAddOnItem.isHidden = true
                    cell.viewAddOnCategory.isHidden = false
                    cell.viewAddOnCategory.backgroundColor = .clear
                    cell.viewTopSaprator.isHidden = true
                    cell.btnInfo.isHidden = true
                    if let extraChargeDetail = payment.extraChargeDetail ,(extraChargeDetail.extra ?? 0) > 0{
                        let status = extraChargeDetail.isApproved
                        switch status {
                        case 0: //pending
                            cell.lblCategoryType?.text = "Requested"
                            cell.lblCategoryType?.textColor = .systemYellow
                            break
                        case 1: // accepted
                            cell.lblCategoryType?.text = "Accepted"
                            cell.lblCategoryType?.textColor = .systemGreen
                            break
                        case 2:// rejected
                            cell.lblCategoryType?.text = "Rejected"
                            cell.lblCategoryType?.textColor = .systemRed
                            break
                        default:
                            break
                        }
                    } else {
                        
                        cell.btnInfo.setTitle("ADD", for: .normal)
                        cell.btnInfo.addTarget(self, action: #selector(requstExtraCharge(_:)), for: .touchUpInside)
                        cell.btnInfo.setTitleColor(GreenColor, for: .normal)
                        cell.btnInfo.titleLabel?.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 13))
                        cell.btnInfo.isHidden = viewModel.isPastOrder() || viewModel.isCustomerPaymentDone()!
                        cell.lblCategoryType?.text = "NO"
                        cell.lblCategoryType?.textColor = .gray
                    }
                    cell.lblCategoryName?.text = "Extra Charge"
                    cell.lblCategoryName?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15))
                    cell.lblCategoryName?.textColor = .gray
                    
                    
                    
                    cell.lblCategoryType?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 15))
                    
                    return cell
                }
            case 4:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "SingleAddonsItemTVCell", for: indexPath) as? SingleAddonsItemTVCell {
                    cell.selectionStyle = .none
                    cell.btnInfo.isHidden = true
                    cell.viewAddOnItem.isHidden = true
                    cell.viewAddOnCategory.backgroundColor = .clear
                    cell.viewAddOnCategory.isHidden = false
                    cell.viewTopSaprator.isHidden = false
                    cell.lblCategoryName?.text = "Total"
                    cell.lblCategoryName?.font = UIFont(name: fFONT_BOLD, size: calculateFontForWidth(size: 15))
                    cell.lblCategoryName?.textColor = .black
                    
                    cell.lblCategoryType?.text = (payment.totalAmount ?? 0).getAmountInString()
                    cell.lblCategoryType?.font = UIFont(name: fFONT_BOLD, size: calculateFontForWidth(size: 15))
                    cell.lblCategoryType?.textColor = .black
                    return cell
                }
            default:
                break
            }
            }
        case .separator:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ZigZagfooterTVCell", for: indexPath) as? ZigZagfooterTVCell{
             return cell
            }
        case .buttons:
            let buttonIndex = viewModel.isPastOrder() ? 1 : row
            switch buttonIndex {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVCell", for: indexPath) as? CommonButtonTVCell{
                    cell.selectionStyle = .none
                    cell.btnSubmit.layer.borderWidth = 1
                    cell.btnSubmit.backgroundColor = .white
                    cell.btnSubmit.setTitleColor(.systemOrange, for: .normal)
                    cell.btnSubmit.setTitle("Chat with Customer", for: .normal)
                    cell.btnSubmit.setTitleColor(.systemOrange, for: .highlighted)
                    cell.btnSubmit.addTarget(self, action: #selector(chatWithCustomer(_:)), for: .touchUpInside)
                    cell.btnSubmit.layer.borderColor = UIColor.systemOrange.cgColor
                    return cell
                }
            case 1:
                if  let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVCell", for: indexPath) as? CommonButtonTVCell{
                   cell.selectionStyle = .none
                   cell.btnSubmit.layer.borderWidth = 1
                   cell.btnSubmit.backgroundColor = .white
                   cell.btnSubmit.setTitleColor(GreenColor, for: .normal)
                   cell.btnSubmit.setTitle("Customer Questionnaires", for: .normal)
                   cell.btnSubmit.setTitleColor(GreenColor, for: .highlighted)
                   cell.btnSubmit.addTarget(self, action: #selector(openQuestionAnswers(_:)), for: .touchUpInside)
                   cell.btnSubmit.layer.borderColor = GreenCGColor
                   return cell
               }
            case 2:
                if row == 2, let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVCell", for: indexPath) as? CommonButtonTVCell{
                    cell.selectionStyle = .none
                    cell.btnSubmit.layer.borderWidth = 1
                    cell.btnSubmit.backgroundColor = .white
                    cell.btnSubmit.setTitleColor(GreenColor, for: .normal)
                    cell.btnSubmit.setTitle("Request payment", for: .normal)
                    cell.btnSubmit.setTitleColor(GreenColor, for: .highlighted)
                    cell.btnSubmit.addTarget(self, action: #selector(requestPayment(_:)), for: .touchUpInside)
                    cell.btnSubmit.layer.borderColor = GreenCGColor
                    return cell
                }
            default:
                break
            }
        }
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if TradeOrderDetailScreenField.note.rawValue == indexPath.section {
            if let data = viewModel.getOrderDetails() ,let businessQuotationDetail = data.businessQuotationDetail ,let note = businessQuotationDetail.quoteDesc ,note.count > 0{
                return UITableView.automaticDimension
            } else {
                return 0
            }
        } else {
            return UITableView.automaticDimension
        }
    }
    @objc func cancelTradeService(_ sender : UIButton) {
        let vc = LogoutViewController.loadFromNib()
        vc.modalPresentationStyle = .overFullScreen
       vc.isForCancelService = true
        vc.setView { (result) in
            if result == .success {
                if let data = self.viewModel.getOrderDetails(), let customer = data.serRequest?.customerDetails,let request = data.businessQuotationDetail{
                    self.tradeOrderDetailsViewController?.updateServicesStatus(customerId: customer.id ?? 0, requestId: request.requestId ?? 0, businessId: USER_DETAILS?.shopId ?? 0, businessOwnerId: USER_DETAILS?.id ?? 0, requestStatus: 2)
                }
            }
        }
       self.viewController.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func CallCustomer(_ sender : UIButton) {
        let Num = sender.accessibilityHint ?? ""
        guard let number = URL(string: "tel://\(Num)") else { return }
        UIApplication.shared.open(number)
    }
    @objc func requestPayment(_ sender : UIButton){
        switch APP_DELEGATE?.socketIOHandler?.socket?.status{
            case .connected?:
                let param : Parameters = [
                    "customer_id": viewModel.getOrderDetails()?.serRequest?.customerDetails?.id ?? 0,
                    "shop_id":USER_DETAILS?.shopId ?? 0,
                    "business_owner_id":USER_DETAILS?.id ?? 0,
                    "request_id":viewModel.getOrderDetails()?.serRequest?.id ?? 0,
                    "response_id":viewModel.getOrderDetails()?.businessQuotationDetail?.id ?? 0
                ]
                
                APP_DELEGATE?.socketIOHandler?.makeServicePaymentRequest(dic: param)
                KRProgressHUD.show()
                break
            default:
                self.tradeOrderDetailsViewController?.showBanner(bannerTitle: .failed, message: "Disconnected from server.", type: .warning)
                print("Socket Not Connected")
                break;
        }
    }
    @objc func openQuestionAnswers(_ sender : UIButton){
        let vc = TradeSubmittedQueAnsViewController.loadFromNib()
        if let data = viewModel.getOrderDetails(),let details = data.serRequest{
            vc.viewModel.setQueAns(value: details.questionAnswers ?? [])
            vc.viewModel.setAttachement(value: details.requestAttachments ?? [])
        }
        self.viewController.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func chatWithCustomer(_ sender : UIButton){
        if let customer = viewModel.getOrderDetails()?.serRequest?.customerDetails ,let requestId = viewModel.getOrderDetails()?.serRequest?.id{
            let chatVC = ChatViewController.loadFromNib()
            chatVC.customerDetails = customer
            chatVC.requestId = requestId
            self.viewController.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    @objc func requstExtraCharge(_ sender : UIButton){
        let vc = TradeExtraChargeRequestViewController.loadFromNib()
        if let data = viewModel.getOrderDetails(),let customerDetails = data.serRequest?.customerDetails,let quoteDetails = data.businessQuotationDetail{
            vc.responseId = quoteDetails.id ?? 0
            vc.requestId = quoteDetails.requestId ?? 0
            vc.customerId = customerDetails.id ?? 0
            vc.setView { result in
                if result == .success {
                    self.tradeOrderDetailsViewController?.getsingleTradeOrderDetails()
                }
            }
        }
        self.viewController.navigationController?.pushViewController(vc, animated: true)
        
    }
    func getAttributedText(value1:String,value2:String,value3:String = "") -> NSMutableAttributedString{
        
            let size = calculateFontForWidth(size: 15)
            let size2 = calculateFontForWidth(size: 16)
        
        let headerAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: fFONT_MEDIUM, size: size)!, NSAttributedString.Key.foregroundColor : UIColor.gray]
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: fFONT_SEMIBOLD, size: size)!, NSAttributedString.Key.foregroundColor : UIColor.black]
            
            let firstString = NSMutableAttributedString(string: value1, attributes: headerAttributes)
            let secondString = NSMutableAttributedString(string: "\n" + value2, attributes: textAttributes)
            let thirdString = NSMutableAttributedString(string: value3, attributes: textAttributes)
            
            secondString.append(thirdString)
            firstString.append(secondString)
            
            let paragraphStyle2 = NSMutableParagraphStyle()
            paragraphStyle2.lineSpacing =  10
            paragraphStyle2.alignment = .left
            firstString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle2, range:NSMakeRange(0, firstString.length))
            
            return firstString
            
    }
}
