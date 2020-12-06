//
//  CCViewModel.swift
//  CurrencyConversion
//
//  Created by Srujan k on 01/12/20.
//

import Foundation
import UIKit


class CCViewModel {
    
    init() {}
    deinit {}
    
    var timer: Timer?
    
    func getListOfCountries(handler: @escaping(_ list: [Country]?) -> Void) {
        Utils.startActivityIndicator()
        let listService = ServiceManager<List>(endPoint: Constants.APIEndPoints.list, params: nil)
        listService.load { (list) in
            Utils.stopActivityIndicator()
            if list?.success == false{
                Utils.showPopUpAlert(title: "\(list?.error?.code ?? 0) " + " \(list?.error?.type ?? "")", message: "\(list?.error?.info ?? "")")
                handler(nil)
            }
            self.bindCountylistToObj(countryList: list?.currencies) { (countryList) in
                handler(countryList)
            }
        } onError: { (error) in
            Utils.stopActivityIndicator()
            Utils.showPopUpAlert(title: "Alert", message: error.localizedDescription)
        }
        
    }
    
    func bindCountylistToObj(countryList: [String: String]?, handler: @escaping(_ countryList: [Country]?) -> Void) {
        if let list = countryList{
            var countryList: [Country]? = [Country]()
            list.forEach { (key, value) in
                countryList?.append(Country(code: key, value: value))
            }
            handler(countryList)
        }else{
            handler(nil)
        }
    }
    func bindLiveCurrencies(currencyList: [String: Decimal]?, handler: @escaping(_ currencyList: [Currency]?) -> Void) {
        
        if let list = currencyList{
            var currencyList: [Currency]? = [Currency]()
            list.forEach { (key, value) in
                if let enteredAmount = SharedMemory.shared.enteredAmount, let sourceAmount = getSourceAmount(currencyList: list){
                    let currentCurrency = value
                    let convertedValue = enteredAmount * (currentCurrency/sourceAmount)
                    var keyStr = key
                    keyStr.removeFirst(3)
                    currencyList?.append(Currency(countryName: getCountryNameWith(code: keyStr) ?? "", code: keyStr, value: convertedValue.rounded(4, .up)))
                }
            }
            handler(currencyList)
        }else{
            return handler(nil)
        }
    }
    func getSourceAmount(currencyList: [String: Decimal]) -> Decimal? {
        if let selectedCountryCode = SharedMemory.shared.selectedCountry?.code{
            if let country = currencyList.first(where: {($0.key.lowercased() == "usd"+selectedCountryCode.lowercased())}){
//               return NSNumber(floatLiteral: country.value).decimalValue
                return country.value
            }
            return nil
        }
        return nil
    }
    func getCountryNameWith(code: String) -> String? {
        if let countryList = SharedMemory.shared.countrylist{
            return countryList.first(where: {($0.code?.lowercased() == code.lowercased())})?.value
        }
        return ""
    }
    func searchCountries(searchText: String, countries:  [Country]) ->  [Country] {
        return countries.filter({(($0.code ?? "").lowercased().contains(searchText.lowercased())) || ($0.value ?? "").lowercased().contains(searchText.lowercased())})
    }
    func listenForCurrencyList(){
        if timer != nil{ timer?.invalidate(); timer = nil }
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(getLiveCurrencyData), userInfo: nil, repeats: true)
        getLiveCurrencyData()
    }
    func unsubscribeList()  {
        if timer != nil{
            timer?.invalidate();
            timer = nil
        }
    }
    @objc func getLiveCurrencyData()  {
        getLiveCurrency { (currencyList) in
            if let currencyList = currencyList{
                NotificationCenter.default.post(name: NSNotification.Name(Constants.DidReceiveLiveCurrency), object: nil, userInfo: [Constants.currency: currencyList])
            }
        }
    }
    func getLiveCurrency(handler: @escaping(_ list: [Currency]?) -> Void)  {
        Utils.startActivityIndicator()
        let listService = ServiceManager<List>(endPoint: Constants.APIEndPoints.live, params: nil)
        listService.load { (list) in
            Utils.stopActivityIndicator()
            if list?.success == false{
                Utils.showPopUpAlert(title: "\(list?.error?.code ?? 0) " + " \(list?.error?.type ?? "")", message: "\(list?.error?.info ?? "")")
                handler(nil)
            }
            self.bindLiveCurrencies(currencyList: list?.quotes) { (currencyList) in
                handler(currencyList)
            }
        } onError: { (error) in
            Utils.stopActivityIndicator()
            Utils.showPopUpAlert(title: "Alert", message: error.localizedDescription)
        }
    }

}
