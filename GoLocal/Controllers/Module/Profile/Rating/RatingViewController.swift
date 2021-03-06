//
//  RatingViewController.swift
//  GoLocalDriver
//
//  Created by C100-142 on 21/01/21.
//

import UIKit

class RatingViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoMsg : UILabel!
    var dataSource: RatingDataSource?
    var viewModel = RatingViewModel()
    var giveRatingView: GiveRatingViewController?
    var isLoader : Bool = false
    //Load more
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var offset = 0
    var isLoadMore:Bool = false
    var selRating : RatingReviews!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        dataSource = RatingDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        isLoader = true
        getRatingReviews(offset: offset)
    }
    
    func loadMoreRequest() {
        offset = offset + 1
        isLoader = false
        getRatingReviews(offset: offset)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func actionReplayToRating(_ sender: UIButton) {
        selRating = viewModel.getRatings(at: sender.tag)
        giveRatingView = GiveRatingViewController(nibName: "GiveRatingViewController", bundle: nil)
        giveRatingView?.rating = Double(selRating.rating ?? 0)
        giveRatingView?.delegateGiveratingViewController = self
        giveRatingView?.showScanView(viewDisplay: self.view)
    }
}

extension RatingViewController: GiveRatingViewControllerDelegate{
    func actioncancel() {
    }
    
    func actionSendReview(strReply: String) {
        replyToRatingReview(strReply: strReply, reviewId: selRating.id ?? 0)
    }
}
