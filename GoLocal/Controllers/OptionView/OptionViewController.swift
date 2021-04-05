//
//  OptionViewController.swift
//  GoLocalDriver
//
//  Created by C100-142 on 08/01/21.
//

import UIKit
protocol OptionViewControllerDelegate {
    func openCamera(vc: OptionViewController)
    func openPhotoGallary(vc: OptionViewController)
}

class OptionViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var mainView: UIView!
    var delegateOptionViewController: OptionViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        topView.addGestureRecognizer(tap)
        mainView.layer.cornerRadius = 10
        imgCamera.image = #imageLiteral(resourceName: "icon_cemera_select")
    }
    
    @objc func dismissKeyboard() {
        hidescanView()
    }
    
    @IBAction func btnPhoto(_ sender: UIButton) {
        imgPhoto.image = #imageLiteral(resourceName: "icon_photo_select")
        imgCamera.image = #imageLiteral(resourceName: "icon_camera_unselect")
        delegateOptionViewController?.openPhotoGallary(vc: self)
        
    }
    
    @IBAction func btnCamera(_ sender: UIButton) {
        imgPhoto.image = #imageLiteral(resourceName: "icon_photo_unselect")
        imgCamera.image = #imageLiteral(resourceName: "icon_cemera_select")
        delegateOptionViewController?.openCamera(vc: self)
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
}
