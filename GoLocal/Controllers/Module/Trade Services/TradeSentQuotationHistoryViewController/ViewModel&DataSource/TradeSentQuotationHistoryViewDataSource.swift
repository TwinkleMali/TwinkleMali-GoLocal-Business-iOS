//
//  TradeSentQuotationHistoryViewDataSource.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 22/06/21.
//

import Foundation
class TradeSentQuotationHistoryViewDataSource : NSObject{
    
    private let tableView : UITableView
    private let viewModel: TradeOrderViewModel
    private let viewController: UIViewController
    private var tradeSentQuotationHistoryViewController : TradeSentQuotationHistoryViewController? {
        get{
            viewController as? TradeSentQuotationHistoryViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: TradeOrderViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("OrderCommonDetailsTVCell")
    }
}
extension TradeSentQuotationHistoryViewDataSource : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getOrderCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCommonDetailsTVCell", for: indexPath) as? OrderCommonDetailsTVCell {
            cell.selectionStyle = .none
            cell.SetUpCell(.ActiveOrder)
            let row = indexPath.row
            if let order = viewModel.getOrderDetails(atPos: row),let request = order.serRequest{
                let dateStr =  request.createdAt ?? ""
                let date = dateStr.toDate()?.UTCtoLocal(format: "dd/MM/yyyy") ?? ""
                let time = dateStr.toDate()?.UTCtoLocal(format: "hh:mm a") ?? ""
                cell.lblRequestedDateTime.text = "\(date) at \(time.uppercased())"
                cell.lblRequestedDateTime.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 17))
                if let customer = request.customerDetails {
                    let name = customer.name ?? ""
                    let lName = customer.lname ?? ""
                    cell.lblPastCustomerName.text = name + " " + lName
                    cell.lblPastCustomerName.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 17))
                    let phone = customer.phone ?? ""
                    let countryCode = customer.countryCode ?? 00
                    cell.lblCustomerPhone.text = "+\(countryCode) \(phone)"
                    cell.lblCustomerPhone.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 13))
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
                cell.btnOrderDetails.tag = row
                cell.btnOrderDetails.isHidden = true
                cell.btnNextPayment.isHidden = true
                cell.btnCancel.isHidden = true
                if let businessQuotationDetail = order.businessQuotationDetail ,let billingDetails = businessQuotationDetail.tradeRequestBillingDetails{
                    cell.lblBidAmount.text = (billingDetails.bidAmount ?? 0).getAmountInString()
                }
                cell.lblBidAmountTitle.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                cell.lblArrivalTimeTitle.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 14))
                cell.lblBidAmount.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 15))
                cell.lblArrivalDateTime.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 15))
                cell.btnCancel.tag = row
                
                if let arrRequestSchedule = request.requestSchedule{
                    let requestSchedule = arrRequestSchedule[0]
                    let dateStr =  requestSchedule.startRequestDatetime
                    let date = dateStr?.toDate()?.UTCtoLocal(format: "dd/MM/yyyy") ?? ""
                    let time = dateStr?.toDate()?.UTCtoLocal(format: "hh:mm a") ?? ""
                    cell.lblArrivalDateTime.text = "\(date) at \(time.uppercased())"
                }
            }
            let ip = indexPath
            if (tableView.indexPathsForVisibleRows!.contains(ip)) && tradeSentQuotationHistoryViewController?.isScrolling ?? false && ( ip.row == self.viewModel.getOrderCount() - 2) && viewModel.isLoadMoreEnabled(){
                self.tradeSentQuotationHistoryViewController?.getPendingQuotions(isLoadMore: true)
                self.tradeSentQuotationHistoryViewController?.isScrolling = false
            }
            
            cell.layoutIfNeeded()
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TradeOrderDetailsViewController.loadFromNib()
        let id = viewModel.getOrderDetails(atPos: indexPath.section)?.businessQuotationDetail?.id ?? 0
        vc.viewModel.setResponseId(value: id)
        vc.isPendingOrder = true
        self.viewController.navigationController?.pushViewController(vc, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tradeSentQuotationHistoryViewController?.isScrolling  = true
    }
    @objc func showQuotationRequestDetails(_ sender : UIButton) {
        
    }
}
