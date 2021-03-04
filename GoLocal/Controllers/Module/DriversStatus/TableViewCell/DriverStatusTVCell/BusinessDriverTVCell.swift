//
//  BusinessDriverTVCell.swift
//  GoLocal
//
//  //  Created by C110 on 20/1/21.
//

import UIKit
import GoogleMaps

class BusinessDriverTVCell: UITableViewCell {
    @IBOutlet var vwDisable : UIView!
    @IBOutlet  var mapView: GMSMapView!
    @IBOutlet  var lblTitle: UILabel!
    @IBOutlet  var lblDriverName: UILabel!
    @IBOutlet  var lblDriverNumber: UILabel!
    @IBOutlet  var lblDeliveryTime: UILabel!
    @IBOutlet  var lblDriverTime: UILabel!
    @IBOutlet var txtDeliveryTime: UITextField!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet  var vwInput: UIView!
    @IBOutlet  var vwDriverStatus : UIView!{
        didSet{
            vwDriverStatus.clipsToBounds = true
            vwDriverStatus.layer.cornerRadius = vwDriverStatus.frame.height/2
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
