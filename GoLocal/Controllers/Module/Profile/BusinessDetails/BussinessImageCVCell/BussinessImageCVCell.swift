//
//  BussinessImageCVCell.swift
//  GoLocal
//
//  Created by C110 on 01/02/21.
//

import UIKit

class BussinessImageCVCell: UICollectionViewCell {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var vwMain: UIView!{
        didSet{
            vwMain.layer.cornerRadius = 7.0
            vwMain.layer.borderWidth = 2.0
            vwMain.layer.borderColor = UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1.0).cgColor
        }
    }
    
    @IBOutlet weak var btnAddImage: UIButton!{
        didSet{           
            btnAddImage.layer.cornerRadius = 7.0
        }
    }
    @IBOutlet weak var imgBusiness: UIImageView!{
        didSet{
            imgBusiness.layer.cornerRadius = 7.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
