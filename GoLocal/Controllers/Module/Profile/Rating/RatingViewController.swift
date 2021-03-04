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
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        dataSource = RatingDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.navView.addBottomShadow()
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
        giveRatingView = GiveRatingViewController(nibName: "GiveRatingViewController", bundle: nil)
        giveRatingView?.index = sender.tag
        giveRatingView?.delegateGiveratingViewController = self
        giveRatingView?.showScanView(viewDisplay: self.view)
       
    }
}
extension RatingViewController: GiveRatingViewControllerDelegate{
    func actioncancel(vc: GiveRatingViewController) {
        vc.hidescanView()
    }
    
    func actionSendReview(vc: GiveRatingViewController) {
        vc.hidescanView()
        viewModel.setReplayGiven(value: true, at: vc.index)
        tableView.reloadData()
    }
}
