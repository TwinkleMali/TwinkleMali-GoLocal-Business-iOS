//
//  SingleDriverTVCell.swift
//  GoLocal
//
//  //  Created by C110 on 20/1/21.
//

import UIKit

class SingleDriverTVCell: UITableViewCell {

   
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverNumber: UILabel!
    @IBOutlet weak var lblOwnerTime: UILabel!
    @IBOutlet weak var lblDriverTime: UILabel!    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var vwDriverStatus : UIView!{
        didSet{
            vwDriverStatus.clipsToBounds = true
            vwDriverStatus.layer.cornerRadius = vwDriverStatus.frame.height/2
        }
    }
    @IBOutlet var viewWidth : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
