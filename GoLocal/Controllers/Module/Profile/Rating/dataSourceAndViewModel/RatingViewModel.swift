//
//  RatingViewModel.swift
//  GoLocalDriver
//
//  Created by C100-142 on 21/01/21.
//

import Foundation
import UIKit

class RatingViewModel {
    private var arrRatings : [RatingReviews] = []
    private var isReplayGiven = false
    
}
extension RatingViewModel{
    
    func setReplayGiven(value : Bool,at: Int) {
        self.isReplayGiven = value
    }
    
    func getReplayGiven(at: Int) -> Bool {
        return isReplayGiven
    }
    
    func getRatingCount() -> Int {
        return arrRatings.count
    }

    func setRatings(arrRating :  [RatingReviews]){
        for objRating in arrRating{
            if !self.arrRatings.contains(where: { $0.id == objRating.id }) {
                print("notiId : \(objRating.id ?? 0)")
                self.arrRatings.append(objRating)
            }
        }
    }

    func getNotification(at : Int) -> RatingReviews {
        return arrRatings[at]
    }
}

