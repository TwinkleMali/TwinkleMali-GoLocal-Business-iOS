//
//  CategoryListViewController.swift
//  GoLocal
//
//  Created by C110 on 18/1/21.
//

import UIKit

class CategoryListViewController: BaseViewController {
    
    @IBOutlet weak var btnOffer: UIButton!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
        lblTitle.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 17.0))
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.tableFooterView = UIView()
        }
    }
    //MARK:- VARIABLES
    var dataSource: CategoryListViewDataSource?
    var viewModel = CategoryListViewModel()
//    var storeId = 0
//    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = CategoryListViewDataSource(tableView: tableView, viewModel: viewModel, viewController: self)
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
//        self.collectionView.delegate = dataSource
//        self.collectionView.dataSource = dataSource
//        getStoreProducts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.dataSource?.scrollCategories()
    }
    @IBAction func actionBack(_ sender: Any) {
        self.back(withAnimation: true)
    }
    
    @IBAction func actonPromotionalOffers(_ sender: Any) {
        showBanner(bannerTitle: .underDevelopment, message: "Promotional Offers Not available at the moment", type: .warning)
    }
    
}
