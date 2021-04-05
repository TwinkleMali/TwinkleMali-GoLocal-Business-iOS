//
//  ConfirmationDialogVC.swift
//  GoLocalDriver
//
//  Created by C100-142 on 22/01/21.
//

import UIKit


protocol ConfirmationDialogVCDelegate {
    func actionNo()
    func actionOk()
}
class ConfirmationDialogVC: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
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
    @IBOutlet var btnNo: UIButton!
    @IBOutlet var btnOk: UIButton!
    @IBOutlet weak var btnIcon: UIButton!
    {
        didSet{
            btnIcon.layer.cornerRadius = btnIcon.frame.height / 2
        }
    }
    var delegateConfirmationDialogVC : ConfirmationDialogVCDelegate?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblSubTitle.text = "This order delivery location is near to order #\(orderUniqId). Would you like to merge these two orders ?"
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.viewBackground.alpha = 1.0
        }
    }
    var vc = UIViewController()
    var blurview = UIView()
    var orderUniqId = ""
    
    func showView(viewDisplay: UIView)
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
    
    func hideView()
    {
        blurview.removeFromSuperview()
    }
    
    @IBAction func btnYes(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.viewBackground.alpha = 1.0
        } completion: { (_) in
            self.dismiss(animated: true, completion: nil)
            self.delegateConfirmationDialogVC?.actionOk()
        }
        
        //hideView()
        
    }
    
    @IBAction func btnNo(_ sender: UIButton) {
        //hideView()
        
        UIView.animate(withDuration: 0.2) {
            self.viewBackground.alpha = 1.0
        } completion: { (_) in
            self.dismiss(animated: true, completion: nil)
            self.delegateConfirmationDialogVC?.actionNo()
        }
    }
    
}
