//
//  TradeYesNoTVCell.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 12/04/21.
//

import UIKit

class TradeYesNoTVCell: UITableViewCell {

    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    var isForMultiOption = true
    fileprivate var completionHandler : (String) -> () = {result in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if isForMultiOption {
            if sender == btnFirst {
                btnFirst.isSelected = true
                btnSecond.isSelected = false
                completionHandler("First")
            } else {
                btnFirst.isSelected = false
                btnSecond.isSelected = true
                completionHandler("Second")
            }
        } else {
            completionHandler(sender.titleLabel?.text ?? "")
        }
        
    }
    func setHandler(completion : @escaping (String) -> ()){
        self.completionHandler = completion
    }
}
