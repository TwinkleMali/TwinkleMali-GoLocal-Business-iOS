//
//  ProfileDataSource.swift
//  GoLocalDriver
//
//  Created by C100-142 on 15/01/21.
//

import Foundation
import UIKit

class ProfileDataSource: NSObject {
    //MARK:- VARIABLES
    private let tableView : UITableView
    private let viewModel: ProfileViewModel
    private let viewController: UIViewController
    private var profileViewController : ProfileViewController? {
        get{
            viewController as? ProfileViewController
        }
    }
    //MARK: - INIT
    init(tableView: UITableView,viewModel: ProfileViewModel , viewController: UIViewController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("ProfileTVCell")
        
    }
}
extension ProfileDataSource: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getItemCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCell") as? ProfileTVCell{
            cell.lblItemTitle.text = self.viewModel.getItemName(at: indexPath.row)
            cell.imgItemImage.image = UIImage(named: self.viewModel.getItemImages(at: indexPath.row))
            cell.btnNavigateToScreens.tag = indexPath.row
            cell.btnNavigateToScreens.addTarget(self.profileViewController, action: #selector(self.profileViewController?.actionNavigateToScreens(_:)), for: .touchUpInside)
            if self.viewModel.getItemName(at: indexPath.row) == "Link Bank Account" {
                if USER_DETAILS?.connectedUserId?.count ?? 0 > 0 {
                    cell.isHidden = true
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.viewModel.getItemName(at: indexPath.row) == "Link Bank Account" {
            if USER_DETAILS?.connectedUserId?.count ?? 0 > 0 {
                return 0
            } else {
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
}
