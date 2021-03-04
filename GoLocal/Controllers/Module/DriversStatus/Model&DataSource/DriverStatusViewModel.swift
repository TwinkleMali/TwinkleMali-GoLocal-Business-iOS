//
//  DriverStatusViewModel.swift
//  GoLocal
//
//  //  Created by C110 on 31/12/20.
//

import Foundation
class DriverStatusViewModel {
    private var objDrivers : BusinessDrivers!
}
//Getter Setter
extension DriverStatusViewModel{
    
    func getDriver() -> BusinessDrivers{
            return objDrivers
    }
    
    func setDrivers(objDrivers: BusinessDrivers){
        self.objDrivers = objDrivers
    }
}
