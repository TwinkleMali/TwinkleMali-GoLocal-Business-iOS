//
//  TradeOrderViewModel.swift
//  GoLocal
//
//  Created by Jagjeetsingh Labana on 05/05/21.
//

import Foundation
class TradeOrderViewModel{
    private var tradeOrders : [TraderOrders] = []
    private var pageNo: Int = 0
    private var isLoadmoreAvailable = false
    private var selectedFilter : filterOptions = .none // 0-none / 1-date / 2-Month
    private var selectedDate = ""
    private var selectedMonth = ""
    private var selectedYear = ""
    private var currentOption = 1 // 1- current /2- past
}
extension TradeOrderViewModel {
    func getOrderCount() -> Int {
        self.tradeOrders.count
    }
    func setOrderDetails(value:[TraderOrders]){
        tradeOrders.append(contentsOf: value)
    }
    func getAllOrderDetails() -> [TraderOrders] {
        return tradeOrders
    }
    func getOrderDetails(atPos : Int) -> TraderOrders? {
        if tradeOrders.count > 0 {
            return tradeOrders[atPos]
        } else {
            return nil
        }
    }
    
    func removeAllData() {
        tradeOrders.removeAll()
    }
    //filter option
    func setFilterOption(value : filterOptions) {
        self.selectedFilter = value
    }
    func getFilterOption() -> filterOptions{
        self.selectedFilter
    }
    
    //date
    func setSelectedDate(value : String) {
        self.selectedDate = value
    }
    func getSelectedDate() -> String{
        self.selectedDate
    }
    
    //month
    func setSelectedMonth(value : String) {
        self.selectedMonth = value
    }
    func getSelectedMonth() -> String{
        self.selectedMonth
    }
    
    //year
    func setSelectedYear(value : String) {
        self.selectedYear = value
    }
    func getSelectedYear() -> String{
        self.selectedYear
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
    
    //current option
    func setCurrentOption(value : Int) {
        self.currentOption = value
    }
    func getCurrentOption() -> Int{
        self.currentOption
    }
    
    //Load more
    
    func isLoadMoreEnabled() -> Bool {
        isLoadmoreAvailable
    }
    func UpdateLoadMore(value : Bool){
        isLoadmoreAvailable = value
    }
}
