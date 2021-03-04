//
//  ManageBankAccountDataSource.swift
//  GoLocalDriver
//
//  Created by C100-142 on 21/01/21.
//

import Foundation
import UIKit

class ManageBankAccountDataSource: NSObject {
    
    private var tableView : UITableView
    private var viewModel : ManageBankAccountViewModel
    private var viewController : UIViewController
    private var manageBankAccountViewController : ManageBankAccountViewController?{
        get{
            viewController as? ManageBankAccountViewController
        }
    }
    
    init(tableView: UITableView,viewModel: ManageBankAccountViewModel, viewController: UIViewController){
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("ManageBankAccountTVCell")
        tableView.register("CommonAddTVCell")
    }
}
extension ManageBankAccountDataSource: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 5
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ManageBankAccountTVCell") as? ManageBankAccountTVCell {
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommonAddTVCell") as? CommonAddTVCell {
                cell.btnAddAccount.addTarget(self.manageBankAccountViewController, action: #selector(self.manageBankAccountViewController?.actionNavigateToAddAccount(_:)), for: .touchUpInside)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
