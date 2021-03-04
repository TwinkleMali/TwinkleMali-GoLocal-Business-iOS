//
//  BlurVC.swift
//  Bee
//
//  Created by C100-101 on 06/06/19.
//  Copyright © 2019 C100-101. All rights reserved.
//

import UIKit

class BlurVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}
