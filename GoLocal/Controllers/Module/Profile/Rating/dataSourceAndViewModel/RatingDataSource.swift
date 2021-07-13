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
        if viewModel.getRatingCount() > 0{
            tableView.isHidden = false
            ratingViewController?.lblNoMsg.isHidden = true
        }else{
            ratingViewController?.lblNoMsg.isHidden = false
            tableView.isHidden = true
        }
        return viewModel.getRatingCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.getRatings(at: section).replies?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTVCell") as? RatingTVCell {
                let obj : RatingReviews = viewModel.getRatings(at: indexPath.section)
                var strname : String = ""
                if obj.name != nil && obj.name!.length > 0 {
                    strname = obj.name.asStringOrEmpty()
                    if obj.lname != nil && obj.lname!.length > 0{
                        strname = "\(strname) \(obj.lname ?? "")"
                    }
                }else if obj.username != nil && obj.username!.length > 0{
                    strname = "\(obj.username ?? "")"
                }else {
                    let name = obj.email?.components(separatedBy: "@")
                    strname = "\(name?[0] ?? "")"
                }
                
                cell.lblUserName.text = "\(strname)"
                
                cell.lblRatingdescription.text = obj.review
                
                cell.lblRatingTime.text = ""
                if let dateTime = obj.createdAt{
                    let localDateTime = dateTime.toDate()
                    let date = localDateTime?.toString(format: "dd/MM/yyyy")
                    let time = localDateTime?.toString(format: "hh:mm a")
                    cell.lblRatingTime.text = "\(date ?? "" )\n\(time ?? "")"
//                    print(localDateTime)
                }
                
                cell.startratingView.rating = Double(obj.rating ?? 0)
                cell.btnReplayToReview.isHidden = obj.replies?.count ?? 0 > 0
                cell.btnReplayToReview.tag = indexPath.section
                cell.btnReplayToReview.addTarget(self.ratingViewController, action: #selector(self.ratingViewController?.actionReplayToRating(_:)), for: .touchUpInside)
                cell.selectionStyle = .none
                let ip = indexPath
                if (tableView.indexPathsForVisibleRows!.contains(ip)) && ratingViewController?.isScrolling ?? false && ( ip.section == viewModel.getRatingCount() - 2) && viewModel.isLoadMoreEnabled(){
                    self.ratingViewController?.getRatingReviews(isLoadMore: true)
                    self.ratingViewController?.isScrolling = false
                }
                return cell
            }
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RatingReplayTVCell") as? RatingReplayTVCell {
                let obj : RatingReviews = viewModel.getRatings(at: indexPath.section)
                var strname : String = ""
                if obj.name != nil && obj.name!.length > 0 {
                    strname = obj.name.asStringOrEmpty()
                    if obj.lname != nil && obj.lname!.length > 0{
                        strname = "\(strname) \(obj.lname ?? "")"
                    }
                }else if obj.username != nil && obj.username!.length > 0{
                    cell.lblUserName.text = "\(obj.username ?? "")"
                }else {
                    let name = obj.email?.components(separatedBy: "@")
                    cell.lblUserName.text = "\(name?[0] ?? "")"
                }
                
                cell.lblUserName.text = "\(strname)"
                cell.lblReplayText.text = obj.replies?[indexPath.row - 1].review
                
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ratingViewController?.isScrolling  = true
    }
}
