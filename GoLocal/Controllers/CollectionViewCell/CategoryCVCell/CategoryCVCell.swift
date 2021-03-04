//
//  CategoryCVCell.swift
//  GoLocal
//
//  Created by C100-104 on 24/12/20.
//

import UIKit

class CategoryCVCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: CardView!{
        didSet{
//            viewMain.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 15, scale: false)
        }
    }
    @IBOutlet weak var imgCategoryImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel! {
        didSet {
            lblTitle?.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 15.0))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
