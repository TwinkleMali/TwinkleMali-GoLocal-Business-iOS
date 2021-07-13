//
//  TradeSubmittedQueAnsViewModel.swift
//  GoLocal
//
//  Created by C100-104 on 02/06/21.
//

import Foundation
class TradeSubmittedQueAnsViewModel {
    private var arrQuestionAnswer : [QuestionAnswers] = []
    private var arrRequestAttachments : [RequestAttachments] = []
}
extension TradeSubmittedQueAnsViewModel {
    func getSectionCount() -> Int {
        if arrRequestAttachments.count > 0 && arrQuestionAnswer.count > 0 {
            return arrQuestionAnswer.count + 1
        } else if arrRequestAttachments.count > 0 || arrQuestionAnswer.count > 0  {
            return arrQuestionAnswer.count
        } else {
            return 0
        }
    }
    func getRowCount(for section : Int) -> Int {
        if section == 0 && arrRequestAttachments.count > 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func setQueAns(value:[QuestionAnswers]){
        self.arrQuestionAnswer.append(contentsOf: value)
    }
    func getQueAns(atPos : Int) -> QuestionAnswers{
        arrQuestionAnswer[atPos]
    }
    
    func getImagesCount() -> Int{
        return arrRequestAttachments.count
    }
    func setAttachement(value:[RequestAttachments]){
        self.arrRequestAttachments.append(contentsOf: value)
    }
    func getAttachement(atPos : Int) -> RequestAttachments{
        arrRequestAttachments[atPos]
    }
    
}
