//
//  CalenderMonthCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 01/03/21.
//

import UIKit

class CalenderMonthCell: UICollectionViewCell {

    @IBOutlet weak var lblMonth: UILabel!{
        didSet{
            lblMonth.font = UIFont(name: fFONT_MEDIUM, size: calculateFontForWidth(size: 16.0))
            lblMonth.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var backView: CardView!
    @IBOutlet weak var monthView: UIView!
    {
        didSet{
            monthView.layer.cornerRadius = 8
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
}
