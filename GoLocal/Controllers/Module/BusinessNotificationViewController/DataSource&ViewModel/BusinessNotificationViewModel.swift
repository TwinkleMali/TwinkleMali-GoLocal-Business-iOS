//
//  BusinessNotificationViewModel.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 17/06/21.
//

import Foundation
class BusinessNotificationViewModel {
    private var arrNotifciations : [BusinessNotifications] = []
    private var notificationChecker : NotificationChecker?
    private var isLoadmoreAvailable = false
    private var pageNo: Int = 0
    private var message = ""
}

extension BusinessNotificationViewModel {
       
    func getNotificationCount() -> Int {
        return arrNotifciations.count
    }
    func removeAllNotification(){
        arrNotifciations.removeAll()
    }
    
    func setNotifications(arrNoti :  [BusinessNotifications]){
        for objNoti in arrNoti{
            if !self.arrNotifciations.contains(where: { $0.id == objNoti.id }) {
                print("notiId : \(objNoti.id ?? 0)")
                self.arrNotifciations.append(objNoti)
            }
        }
    }
    
    func getNotification(at : Int) -> BusinessNotifications {
        return arrNotifciations[at]
    }
    //notification checker
    func setNotificationChecker(value: NotificationChecker?){
        notificationChecker = value
    }
    func getNotificationChecker() -> NotificationChecker? {
        notificationChecker
    }
    //message
    func setMessage(value: String){
        message = value
    }
    func getMessage() -> String {
        message
    }
    //Page Count gatter satter
    
    func getCurrentPageCount() -> Int {
        pageNo
    }
    func incrementPageCount(){
        pageNo += 1
    }
    func resetPageCount(){
        pageNo = 0
    }
    
    //Load more
    
    func isLoadMoreEnabled() -> Bool {
        isLoadmoreAvailable
    }
    func UpdateLoadMore(value : Bool){
        isLoadmoreAvailable = value
    }

}
