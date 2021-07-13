//
//  UIButton+Extension.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 04/05/21.
//

import Foundation
import UIKit


@IBDesignable
class RoundButton : UIButton {

    @IBInspectable var cornerRadius: CGFloat = 5
    @IBInspectable var borderColor: UIColor = .lightGray
    @IBInspectable var borderWidth: CGFloat = 0.8
    
    open override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }

}
