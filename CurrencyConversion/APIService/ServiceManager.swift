//
//  ServiceManager.swift
//  CurrencyConversion
//
//  Created by Srujan k on 01/12/20.
//

import Foundation


struct ServiceManager<T: Codable> {
    var endPoint : String
    var params: [String: Any]?
    
    func load(onSuccess: @escaping(_ targetObj: T?) -> Void, onError: @escaping (_ error: NSError) -> Void)  {
        APIService.loadRequest(fromEndPoint: endPoint, params: params) { (response, data, error) in
            if let jsonData = data, response?.statusCode == 200{
                do{
                    let reponseStr = String(data: jsonData, encoding: .utf8)
                    print(reponseStr ?? "")
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(T.self, from: jsonData)
                    onSuccess(response)
                }catch let error as NSError{
                    onError(error)
                }
                
            }else{
                if let err = error{
                    onError(err as NSError)
                }else{
                    let error = NSError(domain: "com.app.CurrencyConversion", code: -1, userInfo: ["error": "Something went wrong"])
                    onError(error)
                }
            }
        }
    }
    
    
}
