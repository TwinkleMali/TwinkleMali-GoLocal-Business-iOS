//
//  LogoutViewController.swift
//  GoLocalDriver
//
//  Created by C100-142 on 16/02/21.
//

import UIKit
class LogoutViewController: BaseViewController {

    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnCancel: UIButton!
    {
        didSet{
            btnCancel.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var btnLogout: UIButton!
    
    {
        didSet{
            btnLogout.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var MainView: UIView!
    {
        didSet{
            MainView.layer.cornerRadius = 35
            MainView.clipsToBounds = true
            MainView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    fileprivate var completionHandler: (AlertResult) -> () = {result  in }
    
    var activityIndicator: UIActivityIndicatorView? {
        get{
            return activityIndecator
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if(touch?.view?.tag == -786) {
            
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = UIColor.clear
            } completion: { (_) in
                self.dismiss(animated: true, completion: nil)
                self.completionHandler(.failure)
            }
            
        }
    }
    @IBAction func btnCancel(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor.clear
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
            self.completionHandler(.failure)
        }
        
    }
    
    @IBAction func btnLogout(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor.clear
        } completion: { (_) in
            self.dismiss(animated: false, completion: nil)
            self.completionHandler(.success)
        }
      
        //self.logout()
    }
    
    func setView( completion: @escaping (AlertResult) -> ()){
        completionHandler = completion
    }

}
