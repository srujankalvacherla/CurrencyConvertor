//
//  SharedManager.swift
//  CurrencyConversion
//
//  Created by Srujan k on 01/12/20.
//

import Foundation

struct SharedMemory {
    static var shared = SharedMemory()
    var countrylist: [Country]? = [Country]()
    var selectedCountry: Country?
    var enteredAmount: Decimal? = 1
    var currencyList: [Currency]? = [Currency]()
    
    private init() { }
}
