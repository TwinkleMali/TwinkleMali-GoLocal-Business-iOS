//
//  OrderListTVCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 15/01/21.
//

import UIKit

class OrderListTVCell: UITableViewCell {
    
    @IBOutlet weak var mainView: CardView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
