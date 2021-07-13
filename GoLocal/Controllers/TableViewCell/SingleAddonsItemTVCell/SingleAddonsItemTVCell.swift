//
//  SingleAddonsItemTVCell.swift
//  GoLocal
//
//  Created by C100-104on 11/01/21.
//

import UIKit

class SingleAddonsItemTVCell: UITableViewCell {

    @IBOutlet weak var viewAddOnItem: UIView!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var lblAddOnName: UILabel!{
        didSet{
            lblAddOnName.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 12.0))
        }
    }
    @IBOutlet weak var lblAddOnPrice: UILabel!{
        didSet{
            lblAddOnName.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 11.0))
        }
    }
    @IBOutlet weak var imgAddOnTick: UIImageView!
    @IBOutlet weak var viewAddOnCategory: UIView!
    @IBOutlet weak var lblCategoryName: UILabel!{
        didSet{
            lblAddOnName.font = UIFont(name: fFONT_BOLD, size: calculateFontForWidth(size: 13.0))
        }
    }
    @IBOutlet weak var viewTopSaprator: UIView!
    @IBOutlet weak var lblCategoryType: UILabel!{
        didSet{
            lblAddOnName.font = UIFont(name: fFONT_REGULAR, size: calculateFontForWidth(size: 12.0))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
