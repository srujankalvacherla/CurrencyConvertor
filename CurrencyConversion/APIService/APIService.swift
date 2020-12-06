//
//  APIService.swift
//  CurrencyConversion
//
//  Created by Srujan k on 01/12/20.
//

import Foundation
import UIKit

class APIService: NSObject{
//    static let shared = APIService()
//    override init() {}
    private static let urlSession = URLSession.shared
    private static let baseURL = "http://api.currencylayer.com/"
    private static let accessKey = "731917355685b10c94debaec7f16f57a"
    
    // MARK: - URLSession
    static private func getRequest(_ urlStr: String) -> URLRequest{
        let url = URL(string: baseURL + urlStr + "?access_key=" + accessKey)!
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        return req
    }
    static func loadRequest(fromEndPoint endpoint: String, params: [String: Any]?, completionHandler: @escaping( _ response: HTTPURLResponse?, _ data: Data?, _ error: Error?) -> Void){
        DispatchQueue.global(qos: .background).async {
            let url = endpoint
            var request = getRequest(url)
            if let json = params?.toJsonString(){
                request.httpBody = json.data(using: .utf8)
            }
            let task = urlSession.dataTask(with: request) { (data, response, error) in
                let httpResponse = response as? HTTPURLResponse
                completionHandler(httpResponse ?? nil, data, error)
            }
            task.resume()
        }
    }
}

