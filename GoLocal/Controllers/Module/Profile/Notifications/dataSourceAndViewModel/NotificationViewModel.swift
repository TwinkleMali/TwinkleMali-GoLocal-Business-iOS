//
//  NotificationViewModel.swift
//  GoLocalDriver
//
//  Created by C100-142 on 12/01/21.
//

import Foundation
import UIKit

class NotificationViewModel {
    private var arrNotifciations : [Notifications] = []
}

extension NotificationViewModel {
       
    func getNotificationCount() -> Int {
        return arrNotifciations.count
    }
    
    func setNotifications(arrNoti :  [Notifications]){
        for objNoti in arrNoti{
            if !self.arrNotifciations.contains(where: { $0.id == objNoti.id }) {
                print("notiId : \(objNoti.id ?? 0)")
                self.arrNotifciations.append(objNoti)
            }
        }
    }
    
    func getNotification(at : Int) -> Notifications {
        return arrNotifciations[at]
    }
}
