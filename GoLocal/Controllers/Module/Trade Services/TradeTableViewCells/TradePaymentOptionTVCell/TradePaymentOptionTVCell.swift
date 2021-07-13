//
//  TradePaymentOptionTVCell.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 06/05/21.
//

import UIKit

class TradePaymentOptionTVCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var btnBACS: UIButton!
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var btnApp: UIButton!
    @IBOutlet weak var viewFirstLine: UIStackView!
    @IBOutlet weak var viewSecondLine: UIStackView!
    fileprivate var completionHandler: (Bool,Bool,Bool,Bool) -> () = {card,BACS,cash,app  in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func actionOptionClicked(_ sender: UIButton) {
        //let tag = sender.tag
        sender.isSelected = !sender.isSelected
        completionHandler(btnCard.isSelected,btnBACS.isSelected,btnCash.isSelected,btnApp.isSelected)
//        switch tag {
//        case 10:
//
//            break
//        case 20:
//            break
//        case 30:
//            break
//        case 40:
//            break
//        default:
//            break
//        }
    }
    //MARK:- Functions
    func setView( completion: @escaping (Bool,Bool,Bool,Bool) -> ()){
        completionHandler = completion
    }
}
