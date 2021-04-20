//
//  ProfileViewModel.swift
//  GoLocalDriver
//
//  Created by C100-142 on 15/01/21.
//

import Foundation
import UIKit

class ProfileViewModel {
    
    private let arrProfileItems = ["Personal Information","Business Details","Notifications","Change Password","Link Bank Account","Rating And Reviews","Log out"]
    private let arrProfileItemsImage = ["profile_icon_g","business_details_icon","notification_icon","change_password_icon","manage_bank_account_icon","rating_review_icon","logout_icon"]
}
extension ProfileViewModel{
    func getItemCount() -> Int {
        return arrProfileItems.count
    }
    
    func getItemName(at: Int) -> String {
        return arrProfileItems[at]
    }
    func getItemImages(at: Int) -> String {
        return arrProfileItemsImage[at]
    }
}
