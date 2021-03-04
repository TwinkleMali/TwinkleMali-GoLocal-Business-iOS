//
//  BottomSheetVC.swift
//  GoLocalDriver
//
//  Created by C110 on 29/01/21.
//

import UIKit

protocol BottomSheetDelegate
{
    func didSelectOption(selValue:Int)
}

class BottomSheetVC: UIViewController {
    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.layer.cornerRadius = 35
            mainView.clipsToBounds = true
            mainView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var imgWeekIcon: UIImageView!
    @IBOutlet weak var btnWeek: UIButton!
    @IBOutlet weak var imgDayIcon: UIImageView!
    @IBOutlet weak var btnDay: UIButton!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func actionSelection(_ sender: UIButton) {
        if(sender == btnDay) {
//            selectedAccountType = VehicleType.Car.rawValue
            imgDayIcon.image = #imageLiteral(resourceName: "icon_radio_select")
            imgWeekIcon.image = #imageLiteral(resourceName: "icon_radio_unselect")
            
        } else {
//            selectedAccountType = VehicleType.Car.rawValue
            imgDayIcon.image = #imageLiteral(resourceName: "icon_radio_unselect")
            imgWeekIcon.image = #imageLiteral(resourceName: "icon_radio_select")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
