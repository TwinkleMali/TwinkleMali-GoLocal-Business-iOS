//
//  DriverSeleListViewModel.swift
//  GoLocal
//
//  //  Created by C110 on 31/12/20.
//

import Foundation
class DriverSeleListViewModel {
    private var objDrivers : BusinessDrivers!
    private var driverList : [Drivers] = []
    private var filteredDriverList : [Drivers] = []
    private var searchEnabled = false
    private var objDriver : Drivers!
    private var searchedText = ""
    private var objDriverOrder : OrderDetails!
}
//Getter Setter
extension DriverSeleListViewModel{
    func getDriverRowCount() -> Int{
        if searchedText != ""{
            return searchEnabled ? filteredDriverList.count : driverList.count
        }
        return driverList.count
    }
    
    func getDriver(atPos : Int) -> Drivers{
        if searchedText != ""{
            return searchEnabled ? filteredDriverList[atPos] : driverList[atPos]
        }
        return driverList[atPos]
    }
    
    func setDrivers(drivers:[Drivers]){
        driverList.append(contentsOf: drivers)
    }
    
    func getAllDriver() -> BusinessDrivers{
            return objDrivers
    }
    
    func setAllDrivers(objDrivers: BusinessDrivers){
        self.objDrivers = objDrivers
    }
    
    func getDriver() -> Drivers{
        return objDriver
    }
    
    func setDriver(objDriver: Drivers) {
        self.objDriver = objDriver
    }
    
    func getDriverOrder() -> OrderDetails{
        return objDriverOrder
    }
    
    func setDriverOrder(objDriverOrder: OrderDetails) {
        self.objDriverOrder = objDriverOrder
    }
    func updateSearch( _ value : Bool){
        searchEnabled = value
    }
    func isSearchEnabled() -> Bool{
        searchEnabled
    }
    func setSearchedText(text: String) {
        searchedText = text
        FilterData(text: text)
    }
    func FilterData(text: String){
        let finaltext = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let result = driverList.filter({($0.name ?? "").trimmingCharacters(in:          .whitespacesAndNewlines).lowercased().contains(finaltext) ||
                                        ($0.lname ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(finaltext) ||
                                        ($0.username ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(finaltext)})
        self.filteredDriverList.removeAll()
        self.filteredDriverList.append(contentsOf: result)
    }
}
