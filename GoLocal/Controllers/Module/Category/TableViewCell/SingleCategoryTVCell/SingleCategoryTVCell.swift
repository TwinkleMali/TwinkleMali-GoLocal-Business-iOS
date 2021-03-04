//
//  SingleCategoryTVCell.swift
//  GoLocal
//
//  //  Created by C110 on 20/1/21.
//

import UIKit

class SingleCategoryTVCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!{
        didSet{
            imgProduct.layer.cornerRadius = 3
            imgProduct.clipsToBounds = true
        }
    }
    @IBOutlet weak var lblCategoryName: UILabel!{
        didSet{
            lblCategoryName.font = UIFont(name: fFONT_BOLD, size: 14)
        }
    }
    
    @IBOutlet weak var btnMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
