//
//  GiveRatingViewController.swift
//  GoLocalDriver
//
//  Created by C100-142 on 22/01/21.
//

import UIKit
import Cosmos

protocol GiveRatingViewControllerDelegate {
    func actioncancel()
    func actionSendReview(strReply : String)
}
class GiveRatingViewController: UIViewController {

    @IBOutlet weak var ratingTextView: UITextView!{
        didSet{
//            if #available(iOS 13.0, *) {
//
//            } else {
//                // Fallback on earlier versions
//            }
            ratingTextView.layer.borderColor = UIColor.lightGray.cgColor
            ratingTextView.layer.borderWidth = 1.0
            ratingTextView.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var mainView: UIView!
    {
        didSet{
            mainView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var bottomView: UIView!{
        didSet{
            bottomView.layer.cornerRadius = 10
            bottomView.clipsToBounds = true
            bottomView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        }
    }
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSendReview: UIButton!
    var delegateGiveratingViewController: GiveRatingViewControllerDelegate?
    var rating : Double!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.rating = rating
//        ratingTextView.text = "Thanks for your valuable time to rate us"
    }
    var vc = UIViewController()
    var blurview = UIView()
    
    func showScanView(viewDisplay: UIView)
    {
        vc = UIViewController(nibName: "BlurVC", bundle: nil)
        blurview = vc.view
        blurview.frame = viewDisplay.frame
        self.view.frame = CGRect(x: 0, y: 0, width: viewDisplay.frame.width, height: UIScreen.main.bounds.size.height)
        NSLog("%@", NSCoder.string(for: self.view.frame))
        self.view.center = viewDisplay.center
        
        blurview.addSubview(self.view!)
        viewDisplay.addSubview(blurview)
        
    }
    func hidescanView()
    {
        blurview.removeFromSuperview()
    }
    @IBAction func btnSendReview(_ sender: UIButton) {
        hidescanView()
        delegateGiveratingViewController?.actionSendReview(strReply: ratingTextView.text)       
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        hidescanView()
    }
    
}
