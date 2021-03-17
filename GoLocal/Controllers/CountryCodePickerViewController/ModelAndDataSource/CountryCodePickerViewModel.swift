//
//  CountryCodePickerViewModel.swift
//  GoLocal
//
//  Created by C100-104 on 04/01/21.
//

import Foundation
class CountryCodePickerViewModel{
    //VARIABLES
    var arrCountries = [Country]()
    var arrSearch = [Country]()
    var currentCountry = [Country]()
    var isSearch : Bool = false
    var selectedCountry : Country? = COUNTRY_LIST.count > 0 ? (COUNTRY_LIST.filter({($0.name ?? "") == "United Kingdom"})[0]) : nil
}
extension CountryCodePickerViewModel {
    func setDefultSelectedCountry() -> Country {
        COUNTRY_LIST.filter({($0.name ?? "") == "United Kingdom"})[0]
    }
    func turnSearch(_ on : Bool){
        isSearch = on
    }
    func isSearchOn() -> Bool{
        isSearch
    }
    func getRowCount() -> Int{
        if isSearchOn() {
            return arrSearch.count
        }
        return COUNTRY_LIST.count
    }
    func getCountry(atPos : Int ) -> Country {
        if isSearchOn(){
            return arrSearch[atPos]
        }
        return COUNTRY_LIST[atPos]
    }
    func isSelected(value : String,atPosition : Int ) -> Bool {
        if isSearchOn() {
            return arrSearch[atPosition].sortname ?? "" == value
        } else {
            return COUNTRY_LIST[atPosition].sortname ?? "" == value
        }
    }
    func setSelectedCountry(value : Country){
        selectedCountry = value
    }
    func getSelectedCountry() -> Country? {
        selectedCountry
    }
    func getIndexOfSelectedItem(name : String) ->Int{
        return  COUNTRY_LIST.firstIndex{($0.name ?? "") == name} ?? 0
    }
    func searchData(fromValue : String ){
        arrSearch = COUNTRY_LIST.filter{($0.name ?? "").lowercased().contains(fromValue.lowercased()) || ($0.sortname ?? "").lowercased().contains(fromValue.lowercased()) || "\($0.phonecode ?? 0)".lowercased().contains(fromValue.lowercased())}
    }
}
