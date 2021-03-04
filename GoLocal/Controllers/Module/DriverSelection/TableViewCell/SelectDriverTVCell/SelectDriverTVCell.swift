//
//  SelectDriverTVCell.swift
//  GoLocal
//
//  //  Created by C110 on 20/1/21.
//

import UIKit
import GoogleMaps

class SelectDriverTVCell: UITableViewCell {
    @IBOutlet var vwDisable : UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverNumber: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblDriverTime: UILabel!
    @IBOutlet weak var txtDeliveryTime: UITextField!    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var vwInput: UIView!
    @IBOutlet weak var vwDriverStatus : UIView!{
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
