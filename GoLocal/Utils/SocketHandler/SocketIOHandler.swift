//
//  SocketIOHandler.swift
//  GoferDeliveryCustomer
//
//  Created by C100-104 on 03/03/20.
//  Copyright © 2020 C100-104. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON
import AudioToolbox
//
@objc protocol SocketIOHandlerDelegate {
    func connectionStatus(status:SocketIOStatus)
//    @objc optional func newMessage(array:[CDMessages])
//    @objc optional func InitialMessage(array:[CDMessages])
//    @objc optional func loadMoreMessage(array:[CDMessages])
    @objc optional func reloadMessages()
}

class SocketIOManager: NSObject{
    static let shared = SocketIOManager()
    
    var socket: SocketIOClient!

    // defaultNamespaceSocket and swiftSocket both share a single connection to the server
    let manager = SocketManager(socketURL: URL(string: SOCKET_SERVER_PATH)!, config: [.log(true), .compress])

    override init() {
        super.init()
        socket = manager.defaultSocket
    }
    func connectSocket() {
        //let token = UserDefaults.standard.getAccessToken()
        self.manager.config = SocketIOClientConfiguration(
            arrayLiteral: .connectParams(["user_id": USER_DETAILS?.id ?? 0]), .secure(true)
            )
            socket.connect()
    }
    func receiveMsg() {
        socket.on("new message here") { (dataArray, ack) in
            print(dataArray.count)
        }
    }
}
class SocketIOHandler: NSObject {

    var delegate:SocketIOHandlerDelegate?
    var manager: SocketManager?
    var socket: SocketIOClient?
    var isHandlerAdded:Bool = false
    var isJoinSocket:Bool = false
    override init() {
        super.init()
        connectWithSocket()
    }
    //MARK:- ConnectWithSocket
    func connectWithSocket() {
        if manager == nil && socket == nil {
            manager = SocketManager(socketURL: URL(string: SOCKET_SERVER_PATH)!, config: [.log(true), .compress])
            socket = manager?.defaultSocket
            connectSocketWithStatus()
        }else if socket?.status == .connected {
            self.callFunctionsAfterConnection()
        }
    }
    func connectSocketWithStatus(){
        socket?.on(clientEvent: .connect) {data, ack in
            print("SOCKET CONNECTED")
        }
        socket?.on(clientEvent: .statusChange) {data, ack in
            let val = data.first as! SocketIOStatus
            self.delegate?.connectionStatus(status: val)
            switch val {
            case .connected:
                print("SOCKET CONNECTED 1")
                self.callFunctionsAfterConnection()
                break
            case.connecting:
                print("CONNECTING TO SOCKET")
                break
                
            case.disconnected:
                print("DISCONNECTED FROM SOCKET")
            default:
                break
            }
        }
        socket?.connect()
        print(socket?.status)
    }
    func callFunctionsAfterConnection()  {
        if(USER_DETAILS != nil /* && !isJoinSocket*/){
            let dict:NSMutableDictionary = NSMutableDictionary()
            dict.setValue(USER_DETAILS?.id ?? 0, forKey: "user_id")
            dict.setValue(USER_DETAILS?.shopId ?? 0, forKey: "shop_id")
            joinSocketWithData(data: dict)
            
        }
    }
    func background(){
        disconnectSocket()
        isJoinSocket = false
        isHandlerAdded = false
        APP_DELEGATE!.socketHandlersAdded = false
   }
   func foreground(){
       callFunctionsAfterConnection()
   }
   func disconnectSocket(){
        APP_DELEGATE!.socketHandlersAdded = false
        socket?.removeAllHandlers()
        socket?.disconnect()
       //manager?.removeSocket(socket!)
   }
   //MARK:- Join Socket With User
   func joinSocketWithData(data:NSDictionary) {
       /*
        In order to join the socket
        */
            if(USER_DETAILS != nil /*&& !isJoinSocket*/) {
            print("USER JOIN SOCKET")
            socket?.emit(API_SOCKET_JOIN, data)
            isJoinSocket = true
            APP_DELEGATE!.socketHandlersAdded = true
            addHandlers()
            if !USER_DEFAULTS.contains(key: defaultsKey.RejectReasons.rawValue){
                switch APP_DELEGATE?.socketIOHandler?.socket?.status{
                    case .connected?:
                        if (APP_DELEGATE!.socketIOHandler!.isJoinSocket){
                            APP_DELEGATE!.socketIOHandler?.GetRejectReason()
                        }
                        break
            
                        default:
                            print("GetRejectReason : Socket Not Connected")
                }
            }
        }
   }
   //MARK:- DISCONNECT SOCKET MANUALLY
    func disconenctSocketManually() {
        let dic = ["user_id" : USER_DETAILS?.id ?? 0]
        socket?.emitWithAck(API_SOCKET_DISCONNECT, dic).timingOut(after: 0, callback: { (result) in
            if (result[0] as! [String : Any])["status"] as! Bool  {
                print("Disconnected")
            }
        })
    }
    //MARK:- JOIN ORDER ROOM
    func joinBusinessRoom() {
        let dic = ["user_id" : USER_DETAILS?.id ?? 0,
                   "shop_id" :  USER_DETAILS?.shopId ?? 0]
        socket?.emitWithAck(API_SOCKET_JOIN_BUSINESS_ROOM, dic).timingOut(after: 0, callback: { (result) in
        })
    }
    //MARK:- LEAVE ORDER ROOM
    func leaveBusinessRoom() {
        let dic = ["user_id" : USER_DETAILS?.id ?? 0,
                   "shop_id" : USER_DETAILS?.shopId ?? 0]
        socket?.emitWithAck(API_SOCKET_LEAVE_BUSINESS_ROOM, dic).timingOut(after: 0, callback: { (result) in
            //ORDER ROOM LEFT
        })
    }
    
    //MARK:- Accept Order Request
    func AcceptOrderRequest(dictionary : [String : Any]) {        
        socket?.emitWithAck(API_SHOP_ACCEPT_ORDER, dictionary).timingOut(after: 0, callback: { (result) in
//            if (result[0] as! [String : Any])["status"] as! Bool  {
            if let index = APP_DELEGATE?.arrOrderRequestMain.firstIndex(where: {$0.orderDetails?.id == dictionary["order_id"] as? Int}) {
                APP_DELEGATE?.arrOrderRequestMain.remove(at: index)
            }
                postNotification(withName: notificationCenterKeys.shopAcceptOrder.rawValue, userInfo: result[0] as! [String : Any])
//            }
            print(result)
        })
    }
    
    //MARK:- Reject Order Request
    func RejectOrderRequest(dictionary : [String : Any]) {
        socket?.emitWithAck(API_SHOP_REJECT_ORDER, dictionary).timingOut(after: 0, callback: { (result) in
            if (result[0] as! [String : Any])["status"] as! Bool  {
                if let index = APP_DELEGATE?.arrOrderRequestMain.firstIndex(where: {$0.orderDetails?.id == dictionary["order_id"] as? Int}) {
                    APP_DELEGATE?.arrOrderRequestMain.remove(at: index)
                }
                if dictionary["is_auto_rejection"] as! Bool {
                    let alert = UIAlertController(title:"Opps!", message: "Order Request Timeout", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel,handler: { (UIAlertAction) in
                            APP_DELEGATE?.setupRootTabBarViewController(tabIndex: 0)
                    }))
                        APP_DELEGATE?.window?.rootViewController?.present(alert, animated: true)
                }else {
                    postNotification(withName: notificationCenterKeys.shopRejectOrder.rawValue, userInfo: result[0] as! [String : Any])
                }
            } else {
            }            
            print(result)
        })
    }
    
    //MARK:- change take away Order status
    func changeTakeawayOrderStatus(dictionary : [String : Any]) {
        socket?.emitWithAck(API_CHANGE_TAKEAWAY_ORDER_STATUS, dictionary).timingOut(after: 0, callback: { (result) in
            postNotification(withName: notificationCenterKeys.changeTakeawayOrderStatus.rawValue, userInfo: result[0] as! [String : Any])
            print("API_CHANGE_TAKEAWAY_ORDER_STATUS : \(result)")
        })
    }
    
    //MARK:- getSingleOrderDetails
    func getSingleOrderDetails(orderId : String) {
        let dic = ["order_id" : orderId]
        socket?.emitWithAck(API_GET_SINGLE_ORDER_DETAILS, dic).timingOut(after: 0, callback: { (result) in
            postNotification(withName: notificationCenterKeys.getSingleOrderDetails.rawValue, userInfo: result[0] as! [String : Any])
            print("API_GET_SINGLE_ORDER_DETAILS : \(result)")
        })
    }
    
    //MARK:- Get reject Reason
    func GetRejectReason() {
        socket?.emitWithAck(API_GET_REJECT_REASONS, with: []).timingOut(after: 0, callback: { (result) in
            if (result[0] as! [String : Any])["status"] as! Bool  {
                if let dic = result[0] as? [String : Any] {
                    if let data = dic[WSDATA] as? NSDictionary {
                        if let arrReason = data["reject_reasons"] as? NSArray {
                            USER_DEFAULTS.setValue(arrReason, forKey: defaultsKey.RejectReasons.rawValue)
                        }
                    }
                }
            } else {
                //ShowToast(message: (result[0] as! [String : Any])["message"] as! String)
            }
            print(result)
        })
        /*socket?.emitWithAck(API_GET_REJECT_REASONS).timingOut(after: 0, callback: { (result) in
            if (result[0] as! [String : Any])["status"] as! Bool  {
                
                USER_DEFAULTS.setValue((result[0] as! [String : Any])["reject_reasons"], forKey: defaultsKey.RejectReasons.rawValue)

            } else {
                //ShowToast(message: (result[0] as! [String : Any])["message"] as! String)
            }
            print(result)
        })*/
    }
    
    //MARK:- Get Driver Running Order Detail
    func GetDriverRunningOrderDetail() {
        let dic = ["driver_id" : 0]
        socket?.emitWithAck(API_GET_DRIVER_RUNNNING_ORDER_DETAIL, dic).timingOut(after: 0, callback: { (result) in
            if (result[0] as! [String : Any])["status"] as! Bool  {

            } else {
               
            }
            print(result)
        })
    }
        
    //MARK:- EVENTS
    func addHandlers() {
        //EVENT FOR RECEIVE ORDER REQUEST
        socket?.on(API_SHOP_ORDER_REQUEST, callback: { (data, ack) in
            print("Order Received : \(data)")
            if let dic = data[0] as? [String : Any] {
                let d = dic
                let objOrderRequest = OrderRequests(object: d)
                if APP_DELEGATE?.arrOrderRequestMain.contains(where: { $0.orderDetails?.id == objOrderRequest.orderDetails?.id }) == false{
                    APP_DELEGATE?.arrOrderRequestMain.append(objOrderRequest)
                }
                postNotification(withName: notificationCenterKeys.shopOrderRequest.rawValue, userInfo: d)
            }
        })

        //EVENT FOR ORDER ACCEPTED BY OTHER
        socket?.on(API_SHOP_ORDER_ACCEPTED_BY_OTHER, callback: { (data, ack) in
            print("EVENT FOR ORDER ACCEPTED BY OTHER")
            if let dic = data[0] as? [String : Any] {
                let d = dic
                if let index = APP_DELEGATE?.arrOrderRequestMain.firstIndex(where: {$0.orderDetails?.id == d["order_id"] as? Int}) {
                    APP_DELEGATE?.arrOrderRequestMain.remove(at: index)
                }
                let alert = UIAlertController(title:"Opps!", message: "Order Request Accepted by Other", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel,handler: { (UIAlertAction) in
                        APP_DELEGATE?.setupRootTabBarViewController(tabIndex: 0)
                }))
                APP_DELEGATE?.window?.rootViewController?.present(alert, animated: true)
            }
        })

        //EVENT FOR ORDER REJECTED BY OTHER
        socket?.on(API_SHOP_ORDER_REJECTED_BY_OTHER, callback: { (data, ack) in
            print("EVENT FOR ORDER REJECTED BY OTHER")
            if let dic = data[0] as? [String : Any] {
                let d = dic
                if let index = APP_DELEGATE?.arrOrderRequestMain.firstIndex(where: {$0.orderDetails?.id == d["order_id"] as? Int}) {
                    APP_DELEGATE?.arrOrderRequestMain.remove(at: index)
                }
                let alert = UIAlertController(title:"Opps!", message: "Order Request Rejected by Other", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel,handler: { (UIAlertAction) in
                        APP_DELEGATE?.setupRootTabBarViewController(tabIndex: 0)
                }))
                APP_DELEGATE?.window?.rootViewController?.present(alert, animated: true)
            }
        })

        //EVENT FOR CHANGE TAKEAWAY ORDER STATUS
        socket?.on(API_ORDER_STATUS_CHANGE_ACK, callback: { (data, ack) in
            print("EVENT FOR API_ORDER_STATUS_CHANGE_ACK")
        })
        
        //        //EVENT FOR DRIVER AVAIALBLITY CHANGE ACK
        //        socket?.on(API_DRIVER_AVAILABILITY_CHANGE_ACK, callback: { (data, ack) in
        //            print("Driver Availability Changed")
        //            if let dic = data[0] as? [String : Any] {
        //                let d = dic
        //                 postNotification(withName: notificationCenterKeys.driver_availibility_change_ack.rawValue, userInfo: d)
        //            }
        //        })

        //        //EVENT FOR DRIVER AVAIALBLITY CHANGE ACK
        //        socket?.on(API_DRIVER_AVAILABILITY_CHANGE_ACK, callback: { (data, ack) in
        //            print("Driver Availability Changed")
        //            if let dic = data[0] as? [String : Any] {
        //                let d = dic
        //                 postNotification(withName: notificationCenterKeys.driver_availibility_change_ack.rawValue, userInfo: d)
        //            }
        //        })
    }
}
