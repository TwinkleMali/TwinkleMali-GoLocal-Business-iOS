//
//  ChatViewDataSource.swift
//  GoLocal
//
//  Created by C100-17 on 02/03/21.
//

import Foundation
import UIKit
class ChatViewDataSource: NSObject{
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: ChatViewModel
    private let viewController: UIViewController
    private var isScrolling = false
    private var chatViewController : ChatViewController? {
        get{
            viewController as? ChatViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: ChatViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("ReceiverMessageCell")
        tableView.register("SenderMessageCell")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 40, right: 0)
    }
}
extension ChatViewDataSource  : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if isScrolling && (viewModel.getRowCount() % 20 == 0) && row <= 2{
            isScrolling = false
            self.chatViewController?.GetAllMessgae()
        }
        let message = viewModel.getMessage(atPos: row)
        let isSender = (message.senderId ?? 0) == (USER_DETAILS?.id ?? 0)
        if isSender{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SenderMessageCell", for: indexPath) as? SenderMessageCell {
                cell.selectionStyle = .none
                cell.lblMessageText.text = message.message ?? ""
                cell.lblDateTime.text = ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateStr = dateFormatter.string(from: (message.updatedAt ?? "").toDate()!)
                var date = dateFormatter.date(from:dateStr)!
                date = date.UTCtoLocal().toDate()!
                 let cdate = dateFormatter.string(from: date)
                let strDate = (message.updatedAt ?? "").getChatDateFromServer()
                cell.lblDateTime.text = "\(strDate) \((cdate.toDate()!).timeAgoSinceDate(numericDates: false))"
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverMessageCell", for: indexPath) as? ReceiverMessageCell {
                cell.selectionStyle = .none
                cell.lblMessageText.text = message.message ?? ""
                cell.lblDateTime.text = ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateStr = dateFormatter.string(from: (message.updatedAt ?? "").toDate()!)
                var date = dateFormatter.date(from:dateStr)!
                date = date.UTCtoLocal().toDate()!
                 let cdate = dateFormatter.string(from: date)
                let strDate = (message.updatedAt ?? "").getChatDateFromServer()
                cell.lblDateTime.text = "\(strDate) \((cdate.toDate()!).timeAgoSinceDate(numericDates: false))"
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (viewModel.getRowCount() - 1) == indexPath.row && !((self.chatViewController?.viewNewMessage.isHidden)!) {
            UIView.animate(withDuration: 0.3) {
                self.chatViewController?.viewNewMessage.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            } completion: { (_) in
                self.chatViewController?.viewNewMessage.isHidden = true
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrolling = true
    }
}
