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
    private var objDriver : Drivers!
}
//Getter Setter
extension DriverSeleListViewModel{
    func getDriverRowCount() -> Int{
        return driverList.count 
    }
    
    func getDriver(atPos : Int) -> Drivers{
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
}
