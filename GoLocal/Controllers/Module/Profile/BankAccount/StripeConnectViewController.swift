//
//  StripeConnectViewController.swift
//  GoLocalDriver
//
//  Created by C100-174 on 12/03/21.
//

import UIKit
import WebKit

class StripeConnectViewController: UIViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    //MARK:- VARIABLES AND CONSTANTS
    var dataSource: StripeConnectDataSource?
    var viewModel =  StripeConnectViewModel()
    
    //MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = StripeConnectDataSource(webView: webView, viewModel: viewModel, viewController: self)
        setupWebView()
    }


    //MARK:- BUTTON ACTIONS
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- HELPER FUNCTIONS
    func setupWebView() {
        webView.navigationDelegate = dataSource
        loadWebView()
    }
    
    func loadWebView()  {
        self.webView.load(self.viewModel.getAuthRequest()!)
    }
    
    func closeWebView(){
        webView.isHidden = true
    }
    
}

