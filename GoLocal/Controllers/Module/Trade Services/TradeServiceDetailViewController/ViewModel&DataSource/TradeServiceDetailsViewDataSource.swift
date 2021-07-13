//
//  TradeServiceDetailsViewDataSource.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 06/05/21.
//

import Foundation
import UIKit
import Alamofire
class TradeServiceDetailsViewDataSource : NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: TradeServiceDetailsViewModel
    private let viewController: UIViewController
    private var tradeServiceDetailsViewController : TradeServiceDetailsViewController? {
        get{
            viewController as? TradeServiceDetailsViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: TradeServiceDetailsViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("OrderCommonDetailsTVCell")
        tableView.register("DepositOptionTVCell")
        tableView.register("TradePaymentOptionTVCell")
        tableView.register("TradeYesNoTVCell")
        tableView.register("CommonSwitchTVCell")
        tableView.register("TradeCustomDateTimeTVCell")
        tableView.register("CommonButtonTVCell")
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 45, right: 0)
    }
}
extension TradeServiceDetailsViewDataSource : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch QuoteDetailsSection(rawValue: section)! {
        case .CustomerAndServiceDetails:
            count = 1
        case .DepositOptions:
            count = 2
        case .PaymentOptions:
            count = 1
        case .BusinessOptionsAndAmount:
            count = viewModel.getBidOption() == 0 ? 5 : 4
        case .ArrivalTime:
            count = 3
        case .Quote:
            count = 1
        case .XtraButtons:
            count = 2
        }
        return count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width - 40, height: 20))
        view.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 20, y: 00, width: view.bounds.width, height: 20))
        label.backgroundColor = .clear
        label.textColor = .lightGray
        switch QuoteDetailsSection(rawValue: section)! {
        case .CustomerAndServiceDetails:
            return nil
        case .DepositOptions:
            label.text = "Deposit Options (optional)"
            break
        case .PaymentOptions:
            return nil
        case .BusinessOptionsAndAmount:
            label.text = "Choose Option"
            break
        case .ArrivalTime:
            label.text = "Enter Arrival Time(Emergency)"
            break
        case .Quote:
            //label.text = "Enter ballpark quote"
            return nil
            break
        case .XtraButtons:
            return nil
        }
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch QuoteDetailsSection(rawValue: section)! {
        case .DepositOptions,.BusinessOptionsAndAmount,.ArrivalTime:
            return 30
        case .PaymentOptions,.CustomerAndServiceDetails,.XtraButtons,.Quote:
            return 0.001
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        switch QuoteDetailsSection(rawValue: section)! {
        case .CustomerAndServiceDetails:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCommonDetailsTVCell", for: indexPath) as? OrderCommonDetailsTVCell {
                cell.mainView.shadowColor = .clear
                cell.SetUpCell(.RequestDetails)
                //cell.ViewSaperater1.addBottomBorder(with: .green, andWidth: 1)
                if let data = viewModel.getRequestDetails() ,let customerDetails = data.customerDetails{
                    cell.lblCustomerName.text = (customerDetails.name ?? "") + " " + (customerDetails.lname ?? "")
                    cell.lblCustomerAddress.text = data.userAddress ?? ""
                    cell.lblCustomerPhone.text = "+\(customerDetails.countryCode ?? 0) \(customerDetails.phone ?? "")"
                    cell.imgPhone.isHidden = false
                    cell.btnCallCustomer.accessibilityHint = "+\(customerDetails.countryCode ?? 0) \(customerDetails.phone ?? "")"
                    cell.btnCallCustomer.addTarget(self, action: #selector(CallCustomer(_:)), for: .touchUpInside)
                    if let arrRequestSchedule = data.requestSchedule{
                        let requestSchedule = arrRequestSchedule[0]
                        let dateStr =  requestSchedule.startRequestDatetime
                        let date = dateStr?.toDate()?.UTCtoLocal(format: "dd/MM/yyyy") ?? ""
                        let time = dateStr?.toDate()?.UTCtoLocal(format: "hh:mm a") ?? ""
                        cell.lblRequestedDateTime.text = "\(date) at \(time)"
                    }
                    if let arrQueAns = data.questionAnswers{
                        let result = arrQueAns.filter({($0.isEmergency ?? 0) == 1})
                        if result.count > 1 , let queAns = result.first{
                            cell.lblBookingType.text = (queAns.optionValue ?? "") == "Yes" ? "Emergency" : "General"
                        }
                    }
                    if let arrServiceType = data.serviceCategories, let serviceType = arrServiceType.first{
                        cell.lblServiceType.text = serviceType.serviceName
                    }
                    cell.labelTimer.reset()
                    cell.labelTimer.timeFormat = "mm:ss"
                    cell.labelTimer.timerType = MZTimerLabelTypeTimer
                    cell.labelTimer.delegate =  self
                    cell.labelTimer.tag = row
                    let timerValue = viewModel.getTimerValue()
                    let createdDate = data.createdAt ?? ""
                    let orderRequestTime = getSecondsBetweenDates(date1: Date(), date2: serverToLocal(date: createdDate)!, orderTimerValue: Double(timerValue))
                    //cell.labelTimer.addTimeCounted(byTime: TimeInterval(orderRequestTime))
                    cell.labelTimer.resetTimerAfterFinish = true
                    cell.labelTimer.setCountDownTime(TimeInterval(orderRequestTime))
                    cell.labelTimer.start()
                }
                cell.layoutIfNeeded()
                return cell
            }
        case .DepositOptions:
            switch row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "DepositOptionTVCell", for: indexPath) as? DepositOptionTVCell {
                    cell.selectionStyle = .none
                    cell.lblTitle.text = "Pay in Advance"
                    //cell.ViewSaperater1.addBottomBorder(with: .green, andWidth: 1)
                    cell.textAmount.placeholder = "Enter amount here..."
                    cell.textAmount.isUserInteractionEnabled = true
                    cell.textAmount.keyboardType = .decimalPad
                    let selectedData = self.viewModel.getServiceRequestDetails()
                    cell.makeCurrencyPrefix()
                    if let depositeOption = selectedData?.depositOption, depositeOption == .PAY_IN_ADVANCED{
                        cell.viewTextField.isHidden = false
                        cell.isViewOpen = true
                        cell.imgArrow.image = #imageLiteral(resourceName: "top_arrow")
                        if let amount = selectedData?.depositValue {
                            cell.textAmount.text = "\(CURRENCY_SYMBOL)\(amount)"
                        }
                    } else {
                        cell.isViewOpen = false
                        cell.imgArrow.image =  #imageLiteral(resourceName: "dropdown_arrow_icon")
                        cell.viewTextField.isHidden = true
                        cell.textAmount.text = ""
                    }
                    
                    cell.setview { (isOpen,text) in
                        
                        let strValue = text.replacingOccurrences(of: "\(CURRENCY_SYMBOL)", with: "")
                        let value = Double(strValue) ?? 0
                        
                        var data = self.viewModel.getServiceRequestDetails()
                        if isOpen {
                            data?.depositOption = .PAY_IN_ADVANCED
                            data?.depositValue = value
                            self.viewModel.setServiceRequestDetails(value: data)
                        } else {
                            if let depositeOption = data?.depositOption ,depositeOption == .PAY_IN_ADVANCED{
                                data?.depositOption = .NONE
                                data?.depositValue = 0
                                self.viewModel.setServiceRequestDetails(value: data)
                            }
                        }
                        self.tableView.reloadSections([section], with: .fade)
                    }
                    cell.layoutIfNeeded()
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "DepositOptionTVCell", for: indexPath) as? DepositOptionTVCell {
                    cell.selectionStyle = .none
                    cell.lblTitle.text = "Pay deposit"
                    //cell.ViewSaperater1.addBottomBorder(with: .green, andWidth: 1)
                    cell.textAmount.placeholder = "Enter percentage (20% of \(CURRENCY_SYMBOL)100 = \(CURRENCY_SYMBOL)20)"
                    cell.textAmount.keyboardType = .numberPad
                    cell.textAmount.isUserInteractionEnabled = true
                    let selectedData = self.viewModel.getServiceRequestDetails()
                    if let depositeOption = selectedData?.depositOption, depositeOption == .PAY_DEPOSIT{
                        cell.viewTextField.isHidden = false
                        cell.isViewOpen = true
                        cell.imgArrow.image = #imageLiteral(resourceName: "top_arrow")
                        if let amount = selectedData?.depositValue ,amount > 0{
                            cell.textAmount.text = "\(Int(amount) ?? 0)"
                        } else {
                            cell.textAmount.text = ""
                        }
                    } else {
                        cell.isViewOpen = false
                        cell.imgArrow.image =  #imageLiteral(resourceName: "dropdown_arrow_icon")
                        cell.viewTextField.isHidden = true
                        cell.textAmount.text = ""
                    }
                    cell.setview { (isOpen,text) in
                        //let strValue = text.replacingOccurrences(of: "\(CURRENCY_SYMBOL)", with: "")
                        let value = Double(text) ?? 0
                        var data = self.viewModel.getServiceRequestDetails()
                        if isOpen {
                            data?.depositOption = .PAY_DEPOSIT
                            data?.depositValue = value
                            self.viewModel.setServiceRequestDetails(value: data)
                        } else {
                            if let depositeOption = data?.depositOption ,depositeOption == .PAY_DEPOSIT{
                                data?.depositOption = .NONE
                                data?.depositValue = 0
                                self.viewModel.setServiceRequestDetails(value: data)
                            }
                        }
                        self.tableView.reloadSections([section], with: .fade)
                    }
                    cell.layoutIfNeeded()
                    return cell
                }
            default:
                return UITableViewCell()
            }
            break
        case .PaymentOptions:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TradePaymentOptionTVCell", for: indexPath) as? TradePaymentOptionTVCell {
                cell.selectionStyle = .none
                let data = self.viewModel.getServiceRequestDetails()
                cell.btnApp.isSelected = data?.paymentOption.components(separatedBy: ",").contains("1") ?? false
                cell.btnCard.isSelected = data?.paymentOption.components(separatedBy: ",").contains("2") ?? false
                cell.btnCash.isSelected = data?.paymentOption.components(separatedBy: ",").contains("3") ?? false
                cell.btnBACS.isSelected = data?.paymentOption.components(separatedBy: ",").contains("4") ?? false
                cell.setView { (card, BACS, cash, app) in
                    var selectedOptions = ""
                    if card{
                        selectedOptions = "1"
                    }
                    if BACS{
                        selectedOptions = selectedOptions.count > 0 ? selectedOptions + ",2" : "2"
                    }
                    if cash{
                        selectedOptions = selectedOptions.count > 0 ? selectedOptions + ",3" : "3"
                    }
                    if app{
                        selectedOptions = selectedOptions.count > 0 ? selectedOptions + ",4" : "4"
                    }
                    print("selectedOptions : ",selectedOptions)
                    var data1 = self.viewModel.getServiceRequestDetails()
                    data1?.paymentOption = selectedOptions
                    self.viewModel.setServiceRequestDetails(value: data1)
                    
                }
                return cell
            }
        case .BusinessOptionsAndAmount:
            switch row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TradeYesNoTVCell", for: indexPath) as? TradeYesNoTVCell {
                    cell.selectionStyle = .none
                    cell.btnFirst.isHidden = false
                    cell.btnSecond.isHidden = false
                    cell.btnFirst.setTitle("Business A", for: .normal)
                    cell.btnSecond.setTitle("Business B", for: .normal)
                    var data = self.viewModel.getServiceRequestDetails()
                    cell.btnSecond.isSelected = data?.businessOption == "Business B"
                    cell.btnFirst.isSelected = data?.businessOption == "Business A"
                    cell.setHandler { (result) in
                        switch result {
                        case "First":
                            data?.businessOption = cell.btnFirst.titleLabel?.text ?? ""
                            self.viewModel.setServiceRequestDetails(value: data)
                            break
                        case "Second":
                            data?.businessOption = cell.btnSecond.titleLabel?.text ?? ""
                            self.viewModel.setServiceRequestDetails(value: data)
                            break
                        default:
                        break
                        }
                    }
                    return cell
                }
            case 1:
                let cell = UITableViewCell(style: .default, reuseIdentifier: "Quote")
                cell.textLabel?.text = "Bid Amount"
                cell.textLabel?.numberOfLines = 1
                return cell
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonSwitchTVCell", for: indexPath) as? CommonSwitchTVCell {
                    cell.selectionStyle = .none
                    cell.btnSwitchToDelivery.setTitle("Enter Bid Amount", for: .normal)
                    cell.btnSwitchToCollection.setTitle("Call Out Fee Only", for: .normal)
                    cell.setView { (result) in
                        if result == "Bid" {
                            self.viewModel.setBidOption(value: 0)
                        } else if result == "Callout" {
                            self.viewModel.setBidOption(value: 1)
                        }
                        tableView.reloadData() //reloadSections([section], with: .fade)
                    }
                    return cell
                }
            case 3:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TradeCustomDateTimeTVCell", for: indexPath) as? TradeCustomDateTimeTVCell {
                    cell.selectionStyle = .none
                    cell.btnSend.isHidden = true
                    cell.lblTitle.text = viewModel.getBidOption() == 0 ? "Enter Bid Amount" : "Call Out Fee"
                    cell.textField.placeholder = "Enter Amount"
                    cell.textField.keyboardType = .decimalPad
                    cell.makeCurrencyPrefix()
                    let data = self.viewModel.getServiceRequestDetails()
                    if self.viewModel.getBidOption() == 0 {
                        cell.textField.text = data?.bidAmount ?? 0 > 0 ? "\(CURRENCY_SYMBOL)\(data?.bidAmount ?? 0)" : ""
                    } else {
                        cell.textField.text = (data?.calloutFee ?? 0) > 0 ? "\(CURRENCY_SYMBOL)\(data?.calloutFee ?? 0)" : ""
                    }
                    
                    cell.setview { (result) in
                        var data1 = self.viewModel.getServiceRequestDetails()
                        let amount = Double(result.replacingOccurrences(of: "\(CURRENCY_SYMBOL)", with: "")) ?? 0
                        
                        if self.viewModel.getBidOption() == 0 {
                            data1?.bidAmount = amount
                        } else {
                            data1?.calloutFee = amount
                        }
                        self.viewModel.setServiceRequestDetails(value: data1)
                    }
                    
                    cell.viewTextView.isHidden = true
                    
                    cell.viewTextField.isHidden = false
                    return cell
                }
            default:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TradeCustomDateTimeTVCell", for: indexPath) as? TradeCustomDateTimeTVCell {
                    cell.selectionStyle = .none
                    cell.btnSend.isHidden = true
                    cell.lblTitle.text = "Call Out Fee"
                    cell.textField.placeholder = "Enter Amount"
                    cell.textField.keyboardType = .decimalPad
                    cell.makeCurrencyPrefix()
                    let data = self.viewModel.getServiceRequestDetails()
                    cell.textField.text = (data?.calloutFee ?? 0) > 0 ? "\(CURRENCY_SYMBOL)\(data?.calloutFee ?? 0)" : ""
                    cell.setview { (result) in
                        let amount = Double(result.replacingOccurrences(of: "\(CURRENCY_SYMBOL)", with: "")) ?? 0
                        var data1 = self.viewModel.getServiceRequestDetails()
                        data1?.calloutFee = amount
                        self.viewModel.setServiceRequestDetails(value: data1)
                    }
                    cell.viewTextView.isHidden = true
                    
                    cell.viewTextField.isHidden = false
                    return cell
                }
            }
        case .ArrivalTime:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TradeYesNoTVCell", for: indexPath) as? TradeYesNoTVCell {
                cell.selectionStyle = .none
                cell.btnSecond.isHidden = true
                switch row {
                case 0:
                    cell.btnFirst.setTitle("Within 30 minutes", for: .normal)
                    if let data = self.viewModel.getServiceRequestDetails() {
                        if data.arrivalTime == 0 || data.arrivalTime == 30 {
                            cell.btnFirst.isSelected = true
                        } else {
                            cell.btnFirst.isSelected = false
                        }
                    }
                    break
                case 1:
                    cell.btnFirst.setTitle("Within 1 Hour", for: .normal)
                    if let data = self.viewModel.getServiceRequestDetails() {
                        if data.arrivalTime == 60{
                            cell.btnFirst.isSelected = true
                        } else {
                            cell.btnFirst.isSelected = false
                        }
                    }
                    break
                default:
                    cell.btnFirst.setTitle("Within 4 Hours", for: .normal)
                    if let data = self.viewModel.getServiceRequestDetails() {
                        if data.arrivalTime == 240{
                            cell.btnFirst.isSelected = true
                        } else {
                            cell.btnFirst.isSelected = false
                        }
                    }
                    break
                }
                cell.isForMultiOption = false
                cell.setHandler { (result) in
                    print("Arrival Time : ",result)
                    if result == "Within 30 minutes" {
                        var data = self.viewModel.getServiceRequestDetails()
                        data?.arrivalTime = 30
                        self.viewModel.setServiceRequestDetails(value: data)
                    } else if result == "Within 1 Hour" {
                        var data = self.viewModel.getServiceRequestDetails()
                        data?.arrivalTime = 60
                        self.viewModel.setServiceRequestDetails(value: data)
                    } else if result == "Within 4 Hours" {
                        var data = self.viewModel.getServiceRequestDetails()
                        data?.arrivalTime = 240
                        self.viewModel.setServiceRequestDetails(value: data)
                    }
                    tableView.reloadData() //reloadSections([section], with: .none)
                }
                return cell
            }
            
        case .Quote:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TradeCustomDateTimeTVCell", for: indexPath) as? TradeCustomDateTimeTVCell {
                cell.selectionStyle = .none
                cell.btnSend.isHidden = true
                cell.lblTitle.text = "Enter ballpark quote"
                cell.lblTitle.font =  UIFont(name: fFONT_SEMIBOLD, size: 16)
                cell.viewTextView.borderWidth = 0
                cell.viewTextView.isHidden = false
                cell.viewTextField.isHidden = true
                cell.viewTextView.addBottomBorder(with: .lightGray, andWidth: 0.8)
                return cell
            }
        case .XtraButtons:
            switch row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVCell", for: indexPath) as? CommonButtonTVCell{
                    cell.selectionStyle = .none
                    cell.btnSubmit.layer.borderWidth = 1
                    cell.btnSubmit.backgroundColor = .white
                    cell.btnSubmit.isUserInteractionEnabled = false
                    cell.btnSubmit.setTitleColor(.systemOrange, for: .normal)
                    cell.btnSubmit.setTitle("Chat with Customer", for: .normal)
                    cell.btnSubmit.setTitleColor(.systemOrange, for: .highlighted)
                    //cell.btnSubmit.addTarget(self, action: #selector(chatWithCustomer(_:)), for: .touchUpInside)
                    cell.btnSubmit.layer.borderColor = UIColor.systemOrange.cgColor
                    return cell
                }
            case 1:
                if  let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVCell", for: indexPath) as? CommonButtonTVCell{
                   cell.selectionStyle = .none
                    cell.btnSubmit.isUserInteractionEnabled = false
                   cell.btnSubmit.layer.borderWidth = 1
                   cell.btnSubmit.backgroundColor = .white
                   cell.btnSubmit.setTitleColor(GreenColor, for: .normal)
                   cell.btnSubmit.setTitle("Customer Questionnaires", for: .normal)
                   cell.btnSubmit.setTitleColor(GreenColor, for: .highlighted)
                   //cell.btnSubmit.addTarget(self, action: #selector(openQuestionAnswers(_:)), for: .touchUpInside)
                   cell.btnSubmit.layer.borderColor = GreenCGColor
                   return cell
               }
            case 2:
                if row == 2, let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVCell", for: indexPath) as? CommonButtonTVCell{
                    cell.selectionStyle = .none
                    cell.btnSubmit.layer.borderWidth = 1
                    cell.btnSubmit.backgroundColor = .white
                    cell.btnSubmit.setTitleColor(GreenColor, for: .normal)
                    cell.btnSubmit.setTitle("Request next payment", for: .normal)
                    cell.btnSubmit.setTitleColor(GreenColor, for: .highlighted)
                    cell.btnSubmit.layer.borderColor = GreenCGColor
                    return cell
                }
            default:
                break
            }
            
           
        }

        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        switch QuoteDetailsSection(rawValue: section)! {
        case .XtraButtons:
            switch row {
            case 0:
                if let customer = viewModel.getRequestDetails()?.customerDetails ,let requestId = viewModel.getRequestDetails()?.id{
                    let chatVC = ChatViewController.loadFromNib()
                    chatVC.customerDetails = customer
                    chatVC.requestId = requestId
                    self.viewController.navigationController?.pushViewController(chatVC, animated: true)
                }
                break
            default:
                let vc = TradeSubmittedQueAnsViewController.loadFromNib()
                if let data = viewModel.getRequestDetails() {
                    vc.viewModel.setQueAns(value: data.questionAnswers ?? [])
                    vc.viewModel.setAttachement(value: data.requestAttachments ?? [])
                }
                self.viewController.navigationController?.pushViewController(vc, animated: true)
                break
            }
            break
        default:
            break
        }
    }
//    @objc func openQuestionAnswers(_ sender : UIButton){
//        let vc = TradeSubmittedQueAnsViewController.loadFromNib()
//        if let data = viewModel.getRequestDetails() {
//            vc.viewModel.setQueAns(value: data.questionAnswers ?? [])
//            vc.viewModel.setAttachement(value: data.requestAttachments ?? [])
//        }
//        self.viewController.navigationController?.pushViewController(vc, animated: true)
//    }
//    @objc func chatWithCustomer(_ sender : UIButton){
//        if let customer = viewModel.getRequestDetails()?.customerDetails ,let requestId = viewModel.getRequestDetails()?.id{
//            let chatVC = ChatViewController.loadFromNib()
//            chatVC.customerDetails = customer
//            chatVC.requestId = requestId
//            self.viewController.navigationController?.pushViewController(chatVC, animated: true)
//        }
//    }
    @objc func CallCustomer(_ sender : UIButton) {
        let Num = sender.accessibilityHint ?? ""
        guard let number = URL(string: "tel://\(Num)") else { return }
        UIApplication.shared.open(number)
    }
}
extension TradeServiceDetailsViewDataSource : MZTimerLabelDelegate {
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval) {
        timerLabel.reset()
        timerLabel.text = "00:00"
        //self.tradeHomeViewController?.getAvailableQuote()
        
       // self.tradeServiceDetailsViewController?.back(withAnimation: true)
        if tradeServiceDetailsViewController?.isInScreen ?? false {
            self.tradeServiceDetailsViewController?.showBanner(bannerTitle: .alert, message: "Request timeout.", type: .warning)
        }
        //BASEVIEW_CONTROLLER?.showBanner(bannerTitle: .alert, message: "Request timeout.", type: .danger)
        
        if let request = viewModel.getRequestDetails() ,let customer = request.customerDetails{
            self.rejectQuoteRequest(customerId: customer.id ?? 0, requestId: request.id ?? 0)
        }
    }
    func rejectQuoteRequest(customerId : Int,requestId : Int){
        let param : Parameters = [
            "user_id": USER_DETAILS?.id ?? 0,
            "customer_id": customerId,
            "shop_id": USER_DETAILS?.shopId ?? 0,
            "request_id": requestId,
            "deposite_option": 0,
            "deposite_value": 0,
            "business_option": 0,
            "payment_option": 0,
            "bid_amount": 0,
            "call_out_fee": 0,
            "business_option_value": 0,
            "arrival_time": 0,
            "quote_description": "",
            "is_accept": 0
        ]
        APP_DELEGATE?.socketIOHandler?.submitServiceQuotation(dic: param)
    }
}
