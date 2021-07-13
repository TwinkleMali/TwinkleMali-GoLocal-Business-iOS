//
//  ChatViewModel.swift
//  GoLocal
//
//  Created by C100-17 on 02/03/21.
//

import Foundation
class ChatViewModel {
    private var pageNo: Int = 0
    private var messages : [Message] = []
    private var isLoadmoreAvailable = false
}
extension ChatViewModel {
    func getRowCount() -> Int{
        messages.count
    }
    
    func setAllMessages(value:[Message]){
        self.removeAllData()
        messages.append(contentsOf: value)
        messages.reverse()
    }
    func setOldMessages(value:[Message]){
        let data = value.reversed()
        messages.insert(contentsOf: data, at: 0)
        //messages.append(contentsOf: value)
    }
    func isMessageAvailable(value:Message) -> Bool {
        messages.filter({($0.id ?? 0) == (value.id ?? 0)}).count > 0
    }
    func setNewMessages(value:[Message]){
        messages.append(contentsOf: value)
    }
    func getMessage(atPos:Int) -> Message {
        messages[atPos]
    }
    func removeAllData() {
        messages.removeAll()
    }
    func getLastMessageId() -> Int {
        if messages.count > 0 {
            if let message = messages.first {
                return message.id ?? 0
            }
        } else {
            return 0
        }
        return 0
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
