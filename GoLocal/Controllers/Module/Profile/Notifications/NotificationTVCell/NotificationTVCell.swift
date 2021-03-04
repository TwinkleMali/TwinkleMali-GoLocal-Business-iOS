//
//  NotificationTVCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 12/01/21.
//

import UIKit

class NotificationTVCell: UITableViewCell {

    @IBOutlet weak var lblNotificationTime: UILabel!
    @IBOutlet weak var lblNotificationTitle: UILabel!
    @IBOutlet weak var imgNotificationType: UIImageView!
    @IBOutlet weak var btnNavigateToScreens: UIButton!
//    @IBOutlet weak var mainView: UIView!
//     didSet(){
//            mainView.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 15, scale: false)
//    }
    
    @IBOutlet weak var viewMain: CardView!{
        didSet{
//            self.viewMain.addBottomShadow()
//            viewMain.dropShadow(color: .lightGray, opacity: 0.5, offSet: CGSize(width: 0, height: 0), radius: 15, scale: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
