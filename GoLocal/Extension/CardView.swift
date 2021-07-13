//
//  CardView.swift
//  GoLocal
//
//  Created by C100-104 on 25/12/20.
//

import Foundation
import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 2

    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBInspectable var shadowRadius: Float = 3
    
    @IBInspectable var borderColor: UIColor = .lightGray
    @IBInspectable var borderWidth: CGFloat = 0
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = CGFloat(shadowRadius)
        
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }

}
