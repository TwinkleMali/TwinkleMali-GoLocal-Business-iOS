//
//  BusinessDetailsTVCell.swift
//  GoLocal
//
//  Created by C110 on 01/02/21.
//


import UIKit
import AACarousel

class BusinessDetailsTVCell: UITableViewCell {
   
    @IBOutlet weak var cvImages: UICollectionView!
    @IBOutlet weak var svTitle: UIStackView!
    @IBOutlet weak var svTime: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtOpenTime : UITextField!{
        didSet{
            txtOpenTime.layer.cornerRadius = 7
            txtOpenTime.layer.borderWidth = 1
            txtOpenTime.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var txtCloseTime : UITextField!{
        didSet{
            txtCloseTime.layer.cornerRadius = 7
            txtCloseTime.layer.borderWidth = 1
            txtCloseTime.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var btnSwitch : UIButton!
    @IBOutlet weak var viewimageSlider: AACarousel!
    @IBOutlet weak var imageSliderHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var imageSliderContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
