//
//  TradeHomeViewDataSource.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 05/05/21.
//

import Foundation
import UIKit
class TradeHomeViewDataSource: NSObject{
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: TradeHomeViewModel
    private let viewController: UIViewController
    private var tradeHomeViewController : TradeHomeViewController? {
        get{
            viewController as? TradeHomeViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: TradeHomeViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("OrderCommonDetailsTVCell")
    }
}

extension TradeHomeViewDataSource : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getRequestCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCommonDetailsTVCell", for: indexPath) as? OrderCommonDetailsTVCell {
            cell.selectionStyle = .none
            
            let row = indexPath.row
            if let servicesRequest = viewModel.getServiceRequests(),let arrRequest = servicesRequest.ser_requests {
                let request = arrRequest[row]
                
                if let customer = request.customerDetails {
                    let name = customer.name ?? ""
                    let lName = customer.lname ?? ""
                    cell.lblCustomerName.text = name + " " + lName
                    let phone = customer.phone ?? ""
                    let countryCode = customer.countryCode ?? 00
                    cell.lblCustomerPhone.text = "+\(countryCode) \(phone)"
                    cell.lblCustomerAddress.text = request.userAddress ?? ""
                }
                if let arrRequestSchedule = request.requestSchedule{
                    let requestSchedule = arrRequestSchedule[0]
                    let dateStr =  requestSchedule.startRequestDatetime
                    let date = dateStr?.toDate()?.UTCtoLocal(format: "dd/MM/yyyy") ?? ""
                    let time = dateStr?.toDate()?.UTCtoLocal(format: "hh:mm a") ?? ""
                    cell.lblRequestedDateTime.text = "\(date) at \(time)"
                }
                if let arrQueAns = request.questionAnswers{
                    let result = arrQueAns.filter({($0.isEmergency ?? 0) == 1})
                    if result.count > 1 , let queAns = result.first{
                        cell.lblBookingType.text = (queAns.optionValue ?? "") == "Yes" ? "Emergency" : "General"
                    }
                }
                if let arrServiceType = request.serviceCategories, let serviceType = arrServiceType.first{
                    cell.lblServiceType.text = serviceType.serviceName
                }
                cell.labelTimer.reset()
                cell.labelTimer.timeFormat = "mm:ss"
                cell.labelTimer.timerType = MZTimerLabelTypeTimer
                cell.labelTimer.delegate =  self
                cell.labelTimer.tag = row
                let timerValue = servicesRequest.timerValue ?? 0
                let createdDate = request.createdAt ?? ""
                let orderRequestTime = getSecondsBetweenDates(date1: Date(), date2: serverToLocal(date: createdDate)!, orderTimerValue: Double(timerValue))
                cell.labelTimer.setCountDownTime(TimeInterval(orderRequestTime))
                //cell.labelTimer.addTimeCounted(byTime: TimeInterval(orderRequestTime))
                cell.labelTimer.start()
            }
            
            
            
            cell.SetUpCell(.QuoteationRequest)
            //cell.ViewSaperater1.addBottomBorder(with: .green, andWidth: 1)
            cell.btnViewDetails.tag = row
            cell.btnReject.tag = row
            cell.btnReject.addTarget(self, action: #selector(self.rejectQuoteRequest(_:)), for: .touchUpInside)
            cell.btnViewDetails.addTarget(self, action: #selector(self.showQuotationRequestDetails(_:)), for: .touchUpInside)
            
            cell.layoutIfNeeded()
            return cell
        }
        return UITableViewCell()
    }
    @objc func rejectQuoteRequest(_ sender : UIButton) {
    //rejectQuoteRequest
        let index = sender.tag
        if let quote = viewModel.getServiceRequests() , let requests = quote.ser_requests{
            let request = requests[index]
            tradeHomeViewController?.rejectQuoteRequest(customerId: request.customerDetails?.id ?? 0, requestId: request.id ?? 0)
        }
    }
    @objc func showQuotationRequestDetails(_ sender : UIButton) {
        let vc = TradeServiceDetailsViewController.loadFromNib()
        vc.QuotationId = viewModel.getServiceRequests()?.ser_requests?[sender.tag].id ?? 0
        vc.customerId = viewModel.getServiceRequests()?.ser_requests?[sender.tag].customerDetails?.id ?? 0
        self.viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TradeHomeViewDataSource : MZTimerLabelDelegate {
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval) {
        timerLabel.reset()
        timerLabel.text = "00:00"
        //self.tradeHomeViewController?.getAvailableQuote()
        let tag = timerLabel.tag
        viewModel.removeService(atPos: tag)
        self.tableView.reloadData()
//        if let data = viewModel.getServiceRequests() {
//            if data.ser_requests?.count ?? 0 <= tag {
//                if let requests = data.ser_requests {
//                    let request = requests[tag]
//
//                }
//            }
//        }
    }
}
