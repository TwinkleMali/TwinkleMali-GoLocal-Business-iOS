//
//  ConfirmAmountAlert.swift
//  GoLocal
//
//  Created by C110 on 01/02/21.
//

import UIKit

class ConfirmAmountAlert: UIViewController {
    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.layer.cornerRadius = 35
            mainView.clipsToBounds = true
            mainView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
   
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTitle : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func actionConfirm(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
