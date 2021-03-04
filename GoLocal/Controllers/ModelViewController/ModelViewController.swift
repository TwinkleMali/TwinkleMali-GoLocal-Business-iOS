//
//  ModelViewController.swift
//  GoLocal
//
//  Created by C100-104 on 28/12/20.
//

import UIKit

class ModelViewController: UIViewController {

    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var maincontainerView: UIView!{
        didSet{
            maincontainerView.layer.cornerRadius = 35
            maincontainerView.clipsToBounds = true
            maincontainerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 17.0))
        }
    }
    @IBOutlet weak var lblMessage: UILabel!{
        didSet{
            lblMessage.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 16.0))
        }
    }
    @IBOutlet weak var btnPrimary: UIButton!{
        didSet{
            btnPrimary.titleLabel?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 18.0))
        }
    }
    @IBOutlet weak var btnSecondary: UIButton!{
        didSet{
            btnSecondary.titleLabel?.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 18.0))
        }
    }
    
    fileprivate var completionHandler: (AlertResult) -> () = {result  in }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func actionPrimary(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.completionHandler(.success)
    }
    
    @IBAction func actionSecondary(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.completionHandler(.failure)
    }
    
    //MARK:- Functions
    func setView( completion: @escaping (AlertResult) -> ()){
        completionHandler = completion
    }
}
