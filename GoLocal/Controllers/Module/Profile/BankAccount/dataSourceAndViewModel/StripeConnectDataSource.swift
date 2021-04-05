//
//  StripeConnectDataSource.swift
//  GoLocalDriver
//
//  Created by C100-174 on 12/03/21.
//

import Foundation
import WebKit

class StripeConnectDataSource: NSObject {
    //MARK:- VARIABLES
    private let webView : WKWebView
    private let viewModel: StripeConnectViewModel
    private let viewController: UIViewController
    private var stripeConnectViewController : StripeConnectViewController? {
        get{
            viewController as? StripeConnectViewController
        }
    }
    //MARK: - INIT
    init(webView: WKWebView,viewModel: StripeConnectViewModel , viewController: UIViewController) {
        self.webView = webView
        self.viewModel = viewModel
        self.viewController = viewController
    }
    
}

//MARK:- WKWEBVIEW DELEGATE METHODS

extension StripeConnectDataSource : WKNavigationDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        stripeConnectViewController?.activityInd.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Did Finish loading")
        stripeConnectViewController?.activityInd.stopAnimating()
        webView.evaluateJavaScript("document.getElementById('json').innerHTML") { [self] (result, error) in
            if error == nil {
                print(result)
                
                
                if let response = result as? String {
                    let objResponse = convertStringToDictionary(text: response)
                    if objResponse != nil {
                        if (objResponse?["error"] as? String) != nil {
                            self.stripeConnectViewController?.closeWebView()
                        }
                        
                        if let strId = objResponse?["stripe_user_id"] as? String {
                            self.stripeConnectViewController?.closeWebView()
                            //Call API For Save stripeUserId
                            if #available(iOS 13.0, *) {
                                self.stripeConnectViewController?.updateConnectedAccountId(strId: strId)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
            print("Page Being loaded is \(navigationAction.request), you can do your work here")
            decisionHandler(.allow)
    }
}
