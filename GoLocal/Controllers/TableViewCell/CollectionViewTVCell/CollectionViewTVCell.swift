//
//  CollectionViewTVCell.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 29/04/21.
//

import UIKit

class CollectionViewTVCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.register("SingleImageCVCell")
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
