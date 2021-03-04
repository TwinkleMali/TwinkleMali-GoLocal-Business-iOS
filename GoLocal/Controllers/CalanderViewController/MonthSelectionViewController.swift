//
//  MonthSelectionViewController.swift
//  GoLocal
//
//  Created by C110 on 03/02/21.
//

import UIKit
protocol MonthSelectionViewDelegate {
    func selectedMonth(month : String, year: String)
}
class MonthSelectionViewController: UIViewController, VAMonthHeaderViewDelegate {
    
 
    @IBOutlet weak var yearHeaderView: VAMonthHeaderView!{
        didSet {
            let appereance = VAMonthHeaderViewAppearance(
                monthFont: UIFont(name: fFONT_BOLD, size: 17.0)!,
                monthTextColor: .black,
                previousButtonImage: #imageLiteral(resourceName: "icon_left_arrow"),
                nextButtonImage: #imageLiteral(resourceName: "icon_right_arrow")
            )
            
            yearHeaderView.delegate = self
            yearHeaderView.appearance = appereance
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func didTapNextMonth() {
        
    }
    
    func didTapPreviousMonth() {
        
    }
}

