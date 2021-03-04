//
//  RequestDetailsMapTVCell.swift
//  GoLocalDriver
//
//  Created by C100-142 on 13/01/21.
//

import UIKit
import GoogleMaps

class RequestDetailsMapTVCell: UITableViewCell {

    @IBOutlet weak var lblDeliveryAddressValue: UILabel!
    @IBOutlet weak var lblTimerTitle: UILabel!
    @IBOutlet weak var lblTimerValue: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var lblOrderNumberValue: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
