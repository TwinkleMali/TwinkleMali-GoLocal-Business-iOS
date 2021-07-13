//
//  CommonSwitchTVCell.swift
//  GoLocal
//
//  Created by C100-104 on 31/12/20.
//

import UIKit

class CommonSwitchTVCell: UITableViewCell {

    @IBOutlet weak var viewSwitch: UIView!{
        didSet{
            let height = viewSwitch.bounds.height
            viewSwitch.layer.cornerRadius = 22
            
        }
    }
    @IBOutlet weak var btnSwitchToCollection: UIButton!{
        didSet{
            let height = btnSwitchToCollection.bounds.height
            btnSwitchToCollection.tag = -20
            btnSwitchToCollection.layer.cornerRadius = height / 2
            btnSwitchToCollection.titleLabel?.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 16.0))
        }
    }
    @IBOutlet weak var btnSwitchToDelivery: UIButton!{
        didSet{
            btnSwitchToDelivery.tag = -10
            let height = btnSwitchToDelivery.bounds.height
            btnSwitchToDelivery.layer.cornerRadius = height / 2
            btnSwitchToDelivery.titleLabel?.font = UIFont(name: fFONT_SEMIBOLD, size: calculateFontForWidth(size: 16.0))
        }
    }
    
    
    //MARK:- VARIABLES
    fileprivate var completionHandler: (String) -> () = {result  in }
    var imgDelivery : UIImage{
        get{
            return #imageLiteral(resourceName: "icon_scooter_w").withRenderingMode(.alwaysTemplate)
        }
    }
    var imgCollection : UIImage{
        get{
            return #imageLiteral(resourceName: "icon_order_g").withRenderingMode(.alwaysTemplate)
        }
    }
    var currentSelection = 1 // 1 - Delivery , 2 - Collection
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionSwitchToDelivery(_ sender: UIButton) {
        if currentSelection != 1
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.btnSwitchToCollection.backgroundColor = .clear
//                self.btnSwitchToCollection.setImage(self.imgCollection, for: .normal)
//                self.btnSwitchToCollection.setImage(self.imgCollection, for: .highlighted)
                self.btnSwitchToCollection.tintColor = GreenColor
                self.btnSwitchToCollection.setTitleColor(GreenColor, for: .normal)
                self.btnSwitchToCollection.setTitleColor(GreenColor, for: .highlighted)
                sender.backgroundColor = GreenColor
//                sender.setImage(self.imgDelivery, for: .normal)
//                sender.setImage(self.imgDelivery, for: .highlighted)
                sender.tintColor = .white
                sender.setTitleColor(.white, for: .normal)
                sender.setTitleColor(.white, for: .highlighted)
                self.currentSelection = 1
                self.completionHandler("Bid")
            })
            
            
        }
    }
    
    @IBAction func actionSwitchToCollection(_ sender: UIButton) {
        if currentSelection != 2
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.btnSwitchToDelivery.backgroundColor = .clear
//                self.btnSwitchToDelivery.setImage(self.imgDelivery, for: .normal)
//                self.btnSwitchToDelivery.setImage(self.imgDelivery, for: .highlighted)
                self.btnSwitchToDelivery.tintColor = GreenColor
                self.btnSwitchToDelivery.setTitleColor(GreenColor, for: .normal)
                self.btnSwitchToDelivery.setTitleColor(GreenColor, for: .highlighted)
                sender.backgroundColor = GreenColor
//                sender.setImage(self.imgCollection, for: .normal)
//                sender.setImage(self.imgCollection, for: .highlighted)
                sender.tintColor = .white
                sender.setTitleColor(.white, for: .normal)
                sender.setTitleColor(.white, for: .highlighted)
                self.currentSelection = 2
                self.completionHandler("Callout")
            })
            
        }
    }
    
    func setView( completion: @escaping (String) -> ()){
        completionHandler = completion
    }
}
