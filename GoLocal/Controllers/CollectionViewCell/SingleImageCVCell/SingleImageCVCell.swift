//
//  SingleImageCVCell.swift
//  GoLocal
//
//  Created by C100-104 on 23/03/21.
//

import UIKit

class SingleImageCVCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.layer.cornerRadius = 5
            imageView.layer.borderWidth = 0.8
            imageView.layer.borderColor = UIColor.gray.cgColor
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var imgCancel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
