//
//  GoLocalDriverTVCell.swift
//  GoLocal
//
//  Created by C110 on 18/02/21.
//

import Foundation
class GoLocalDriverTVCell: UITableViewCell {
    
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var btnEdit: UIButton!   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
