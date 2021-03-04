//
//  RatingDataSource.swift
//  GoLocalDriver
//
//  Created by C100-142 on 21/01/21.
//

import Foundation
import UIKit

class RatingDataSource: NSObject {
    
    private var tableView : UITableView
    private var viewModel : RatingViewModel
    private var viewController : UIViewController
    private var ratingViewController : RatingViewController?{
        get{
            viewController as? RatingViewController
        }
    }
    
    init(tableView: UITableView,viewModel: RatingViewModel, viewController: UIViewController){
        self.tableView = tableView
        self.viewModel = viewModel
        self.viewController = viewController
        tableView.register("RatingTVCell")
        tableView.register("RatingReplayTVCell")
    }
}
extension RatingDataSource: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getRatingCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.getReplayGiven(at: section){
            return 2
        }else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 && viewModel.getReplayGiven(at: indexPath.row){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RatingReplayTVCell") as? RatingReplayTVCell {
                cell.selectionStyle = .none
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTVCell") as? RatingTVCell {
                cell.btnReplayToReview.tag = indexPath.row
                cell.btnReplayToReview.addTarget(self.ratingViewController, action: #selector(self.ratingViewController?.actionReplayToRating(_:)), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
    }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
}
