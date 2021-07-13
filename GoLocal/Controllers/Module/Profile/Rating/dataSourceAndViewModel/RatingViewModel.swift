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
    private var pageNo: Int = 0
    private var isLoadmoreAvailable = false
    private var replyForIndex = -1
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

    func getRatings(at : Int) -> RatingReviews {
        return arrRatings[at]
    }
    
    func addReplyToReview(index : Int,replies : [ReviewReplies],completion : @escaping () -> ()){
        var obj = arrRatings[index]
        self.arrRatings.remove(at: index)
        obj.replies = replies
        self.arrRatings.insert(obj, at: index)
        completion()
    }
    
    func removeReview(reviewId : Int){
        if let index = self.arrRatings.firstIndex(where: {$0.id == reviewId}) {
            self.arrRatings.remove(at: index)
        }
    }
    func removeAllReview(){
        self.arrRatings.removeAll()
    }
    
    func updateReplyIndex(index : Int){
        replyForIndex = index
    }
    
    func getReplyIndex() -> Int {
        replyForIndex
    }
    
    //Page Count gatter satter
    
    func getCurrentPageCount() -> Int {
        pageNo
    }
    func incrementPageCount(){
        pageNo += 1
    }
    func resetPageCount(){
        pageNo = 0
    }

    //Load more
    func isLoadMoreEnabled() -> Bool {
        isLoadmoreAvailable
    }
    func UpdateLoadMore(value : Bool){
        isLoadmoreAvailable = value
    }
}

