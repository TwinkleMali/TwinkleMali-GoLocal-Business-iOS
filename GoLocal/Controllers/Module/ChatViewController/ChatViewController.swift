//
//  ChatViewController.swift
//  GoLocal
//
//  Created by C100-17 on 02/03/21.
//

import UIKit
import GrowingTextView
import SDWebImage
import Alamofire
import IQKeyboardManagerSwift
import KRProgressHUD
class ChatViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var viewNewMessage: CardView!
    @IBOutlet weak var lblUserName: UILabel!{
        didSet{
            imgUserProfile.backgroundColor = .clear
            imgUserProfile.image = #imageLiteral(resourceName: "chat_user_icon")
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var btnSend: UIButton!{
        didSet{
            btnSend.isEnabled = false
        }
    }
    @IBOutlet weak var lblMessageNotAllowed: UILabel!
    @IBOutlet weak var bottomViewConstarints: NSLayoutConstraint!
    
    //MARK:- VARIABLES
    var dataSource : ChatViewDataSource?
    var viewModel  = ChatViewModel()
    var customerDetails: CustomerDetails?
    var orderId = 0
    var requestId = 0
    var message_type = ChatMessageType.TRADE
    var fromNotification = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewNewMessage.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        setUpView()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        
        GetAllMessgae()
        if fromNotification {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.GetAllMessgae()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    override func viewDidLayoutSubviews() {
        self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.bounds.width / 2
        
    }
    
    @IBAction func actionShowNewMessage(_ sender: Any) {
        self.tableView.reloadData()
        self.tableView.scrollToBottom()
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.back(withAnimation: true)
    }
    
    @IBAction func actionSendMessage(_ sender: Any) {
        switch APP_DELEGATE?.socketIOHandler?.socket?.status{
            case .connected?:
                let param : Parameters = [
                    "sender_id": USER_DETAILS?.id ?? 0,
                    "receiver_id" : self.customerDetails?.id ?? 0,
                    "order_id" : orderId,
                    "message" : textView.text ?? "",
                    "message_type":message_type.rawValue,
                    "request_id":requestId
                ]
                print("## SEND MSG  PARAM : ",param)
                APP_DELEGATE?.socketIOHandler?.sendMessage(dic: param)
                break
            default:
                print("Socket Not Connected")
                break;
        }
    }
    @objc func receiveMessages(notification:Notification){
        print("FetchedMessage")
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let messageObjArr = dict[WSDATA] as? NSArray {
                 let messageObj = messageObjArr[0]
                if let json = try? JSONSerialization.data(withJSONObject: messageObj, options: .prettyPrinted) {
                    let message = try? JSONDecoder().decode(Message.self, from: json)
                    print(" MESSAGE IN SCREEN: ",message)
                    if let message = message{
                        viewModel.setNewMessages(value: [message])
                        if message.senderId ?? 0 ==  USER_DETAILS?.id ?? 0 {
                            self.textView.text = ""
                            self.btnSend.isEnabled = false
                            self.tableView.reloadData()
                            self.tableView.scrollToBottom()
                        } else {
                            let row = viewModel.getRowCount() - 2
                            let indexPath = IndexPath(row: row, section: 0)
                            if let indexPaths = self.tableView.indexPathsForVisibleRows ,indexPaths.contains(indexPath) {
                                self.tableView.reloadData()
                                self.tableView.scrollToBottom()
                            } else {
                                self.viewNewMessage.isHidden = false
                                UIView.animate(withDuration: 0.3) {
                                    self.viewNewMessage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                }
                            }
                        }
                    }
                }
            }
//            self.tableView.reloadData()
//            self.tableView.scrollToBottom()
        }
    }
    @objc func receiveNewMessages(notification:Notification){
        print("FetchedMessage")
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let messageObjArr = dict[WSDATA] as? NSArray {
                 let messageObj = messageObjArr[0]
                if let json = try? JSONSerialization.data(withJSONObject: messageObj, options: .prettyPrinted) {
                    let message = try? JSONDecoder().decode(Message.self, from: json)
                    print(" MESSAGE IN SCREEN: ",message)
                    if let message = message, (!viewModel.isMessageAvailable(value: message)){
                        viewModel.setNewMessages(value: [message])
                        if message.senderId ?? 0 ==  USER_DETAILS?.id ?? 0 {
                            self.textView.text = ""
                            self.btnSend.isEnabled = false
                            self.tableView.reloadData()
                            self.tableView.scrollToBottom()
                        } else {
                            let row = viewModel.getRowCount() - 2
                            let indexPath = IndexPath(row: row, section: 0)
                            if let indexPaths = self.tableView.indexPathsForVisibleRows ,indexPaths.contains(indexPath) {
                                self.tableView.reloadData()
                                self.tableView.scrollToBottom()
                            } else {
                                self.viewNewMessage.isHidden = false
                                UIView.animate(withDuration: 0.3) {
                                    self.viewNewMessage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                }
                            }
                        }
                    }
                }
            }
//            self.tableView.reloadData()
//            self.tableView.scrollToBottom()
        }
    }
    func GetAllMessgae() {
        
        switch APP_DELEGATE?.socketIOHandler?.socket?.status{
            case .connected?:
                let param : Parameters = [
                    "sender_id": USER_DETAILS?.id ?? 0,
                    "receiver_id" : self.customerDetails?.id ?? 0,
                    "order_id" : orderId,
                    "last_message_id" : viewModel.getLastMessageId(),
                    "limit" : 20,
                    "message_type":message_type.rawValue,
                    "request_id":requestId
                ]
                APP_DELEGATE?.socketIOHandler?.getChatMessages(dic: param)
                
                KRProgressHUD.show()
                if viewModel.getRowCount() > 0 {
                    KRProgressHUD.update(message: "Fetching messages...")
                }
                break
            default:
                print("Socket Not Connected")
                break;
        }
    }
    @objc func getAllMessages(notification:Notification){
        print("FetchedMessage")
        KRProgressHUD.dismiss()
        if let userInfo = notification.userInfo{
            let dict = userInfo as NSDictionary
            if let messageArr = dict[WSDATA] as? NSArray {
                
                if let json = try? JSONSerialization.data(withJSONObject: messageArr, options: .prettyPrinted) {
                    let messages = try? JSONDecoder().decode([Message].self, from: json)
                    print(" MESSAGE IN SCREEN: ",messages)
                    if let messages = messages {
                        viewModel.UpdateLoadMore(value: messages.count == 20)
                        if viewModel.getRowCount() > 0 {
                            let firstVisibleRow = self.tableView.indexPathsForVisibleRows?.first
                            let lastRow = firstVisibleRow?.row ?? 0
                            
                            viewModel.incrementPageCount()
                            viewModel.setOldMessages(value: messages)
                            self.tableView.reloadData()
                            self.tableView.scrollToRow(at: IndexPath(row: lastRow + messages.count, section: 0), at: .top, animated: false)
                        } else {
                            viewModel.setAllMessages(value: messages)
                            self.tableView.reloadData()
                            self.tableView.scrollToBottom()
                        }
                    }
               }
                
            } else {
                if let message = dict["message"] as? String {
                    self.showBanner(bannerTitle: .none, message: message, type: .warning)
                }
            }
            
        }
    }
    func setUpView(){
        self.dataSource = ChatViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self.dataSource
        self.textView.delegate = self
        nc.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        nc.addObserver(self, selector: #selector(getAllMessages(notification:)), name: Notification.Name(notificationCenterKeys.getAllMessages.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(receiveNewMessages(notification:)), name: Notification.Name(notificationCenterKeys.receiveMessageAck.rawValue), object: nil)
        nc.addObserver(self, selector: #selector(receiveMessages(notification:)), name: Notification.Name(notificationCenterKeys.receiveMessage.rawValue), object: nil)
        self.lblMessageNotAllowed.isHidden = true 
        if let customerDetails = self.customerDetails {
            let name = customerDetails.name
            self.lblUserName.text = name
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //keyboardSize.height
            
            let keyBoardHeight = (HAS_TOP_NOTCH ? (keyboardSize.height - 34) : keyboardSize.height) + 10
            bottomViewConstarints.constant = keyBoardHeight
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        //0
        bottomViewConstarints.constant = 10
    }
}
 
extension ChatViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.btnSend.isEnabled = text.count > 0
    }
}
