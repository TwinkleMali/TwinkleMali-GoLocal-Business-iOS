//
//  ProfileViewController.swift
//  GoLocal
//
//  Created by C100-104on 27/12/20.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var vwNav: UIView!
    @IBOutlet weak var tableView: UITableView!
    var dataSource: ProfileDataSource?
    var viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ProfileDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.tableFooterView = UIView()
        
    }
    
    @objc func actionNavigateToScreens(_ sender: UIButton) {
        switch sender.tag {
        case PROFILE.PersonalInfo.rawValue:
            let vc = EditProfileViewController(nibName: "EditProfileViewController", bundle: .main)
            vc.viewModel.setFirstname(value: USER_DETAILS?.name.asStringOrEmpty() ?? "")
            vc.viewModel.setLastname(value: USER_DETAILS?.lname.asStringOrEmpty() ?? "")
            vc.viewModel.setEmail(value: USER_DETAILS?.email.asStringOrEmpty() ?? "")
            vc.viewModel.setPhonenum(value: USER_DETAILS?.phone.asStringOrEmpty() ?? "")
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case PROFILE.BussinessDetails.rawValue:
            let vc = BusinessDetailsViewController(nibName: "BusinessDetailsViewController", bundle: .main)
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case PROFILE.Notifications.rawValue:
            let vc = NotificationsViewController(nibName: "NotificationsViewController", bundle: .main)
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case PROFILE.ChangePassword.rawValue:
            let vc = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: .main)
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case PROFILE.ManageBankAccount.rawValue:
            let vc = ManageBankAccountViewController(nibName: "ManageBankAccountViewController", bundle: .main)
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case PROFILE.RatingandReview.rawValue:
            let vc = RatingViewController(nibName: "RatingViewController", bundle: .main)
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case PROFILE.Logout.rawValue:
            switch APP_DELEGATE?.socketIOHandler?.socket?.status{
                case .connected?:
                    if (APP_DELEGATE!.socketIOHandler!.isJoinSocket){
                        APP_DELEGATE!.socketIOHandler?.leaveBusinessRoom()
                    }
                    break
                default:
                   print("Socket Not Connected")
            }
            USER_DEFAULTS.removeObject(forKey: defaultsKey.RejectReasons.rawValue)
            USER_DEFAULTS.removeObject(forKey: defaultsKey.userDetails.rawValue)
            let loginVc = LoginViewController(nibName: "LoginViewController", bundle: nil)
            let navVC = UINavigationController(rootViewController: loginVc)
            navVC.navigationBar.isHidden = true
            APP_DELEGATE?.socketIOHandler?.disconnectSocket()
            APP_DELEGATE?.window?.rootViewController = navVC
            break
            
        default:
            print("")
        }
    }
}
