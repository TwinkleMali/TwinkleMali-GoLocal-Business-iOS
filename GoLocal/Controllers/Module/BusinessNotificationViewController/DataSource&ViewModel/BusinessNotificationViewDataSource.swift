//
//  BusinessNotificationViewDataSource.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 17/06/21.
//

import Foundation
class BusinessNotificationViewDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel : BusinessNotificationViewModel
    private let viewController : UIViewController
    private var businessNotificationViewController : BusinessNotificationViewController? {
        get{
            viewController as? BusinessNotificationViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: BusinessNotificationViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("CommonLeftRightLabelTVCell")
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
}
extension BusinessNotificationViewDataSource: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.getNotificationCount() > 0{
            self.businessNotificationViewController?.lblNoData.isHidden = true
            tableView.isHidden = false
        }else {
            self.businessNotificationViewController?.lblNoData.isHidden = false
            tableView.isHidden = true
        }
        return viewModel.getNotificationCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonLeftRightLabelTVCell", for: indexPath) as? CommonLeftRightLabelTVCell{
            cell.selectionStyle = .none
            let notification = self.viewModel.getNotification(at: indexPath.row)
            cell.lblLeftValue.attributedText = getAttributedText(value1: notification.notificationTitle.asStringOrEmpty(), value2: "\n" + notification.notificationMessage.asStringOrEmpty(), value3: "")
            
            let time = notification.createdAt ?? ""
            let local = time.toDate()?.UTCtoLocal() ?? ""
            cell.lblRightValue.text = (local.toDate() ?? Date()).timeAgoDisplay()
            
            let ip = indexPath
            if (tableView.indexPathsForVisibleRows!.contains(ip)) && businessNotificationViewController?.isScrolling ?? false && ( ip.row == self.viewModel.getNotificationCount() - 2) && viewModel.isLoadMoreEnabled(){
                businessNotificationViewController?.getNotificationHistory(isLoadMore: true)
                businessNotificationViewController?.isScrolling = false
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        businessNotificationViewController?.isScrolling  = true
    }
    func getAttributedText(value1:String,value2:String,value3:String) -> NSMutableAttributedString{
        
            let size = calculateFontForWidth(size: 15)
//            let size2 = calculateFontForWidth(size: 13)
        
        let headerAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: fFONT_BOLD, size: size)!, NSAttributedString.Key.foregroundColor : UIColor.black]
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: fFONT_MEDIUM, size: size)!, NSAttributedString.Key.foregroundColor : UIColor.gray]
            
            let headerString = NSMutableAttributedString(string: value1, attributes: headerAttributes)
            let typeString = NSMutableAttributedString(string: value2, attributes: textAttributes)
            let dateString = NSMutableAttributedString(string: value3, attributes: textAttributes)
            
            typeString.append(dateString)
            headerString.append(typeString)
            
            let paragraphStyle2 = NSMutableParagraphStyle()
            paragraphStyle2.lineSpacing =  3
            paragraphStyle2.alignment = .left
            headerString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle2, range:NSMakeRange(0, headerString.length))
            
            return headerString
            
    }
}
