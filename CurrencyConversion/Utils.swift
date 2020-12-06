//
//  Utils.swift
//  CurrencyConversion
//
//  Created by Srujan k on 04/12/20.
//

import Foundation
import UIKit

struct Utils {
    
    static let activityIndicatorTag: Int = 999999
    
    public static func getTopVC() -> UIViewController{
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        guard var topVC = rootVC else{ return UIViewController() }
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }
        return topVC
    }
    
    static func showPopUpAlert(title: String?, message: String?)  {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            getTopVC().present(alert, animated: true, completion: nil)
        }
    }
    public static func startActivityIndicator(
        style: UIActivityIndicatorView.Style = .gray,
        location: CGPoint? = nil) {
        DispatchQueue.main.async{
            let loc = location ?? getTopVC().view.center
            let activityIndicator = UIActivityIndicatorView(style: style)
            activityIndicator.tag = activityIndicatorTag
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            getTopVC().view.addSubview(activityIndicator)
        }
    }
    static func stopActivityIndicator() {
        DispatchQueue.main.async{
            if let activityIndicator = Utils.getTopVC().view.subviews.filter(
                { $0.tag == Utils.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
// MARK: - Extensions
extension Dictionary{
    func toJsonString() -> String? {
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions())
            return String(data: jsonData, encoding: .utf8)
        }catch{
            return nil
        }
    }
}
extension Data{
    func toDataJson() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
        } catch {
            return nil
        }
    }
}
extension UIViewController {
    func hideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension Decimal {
    mutating func round(_ scale: Int, _ roundingMode: NSDecimalNumber.RoundingMode) {
        var localCopy = self
        NSDecimalRound(&self, &localCopy, scale, roundingMode)
    }

    func rounded(_ scale: Int, _ roundingMode: NSDecimalNumber.RoundingMode) -> Decimal {
        var result = Decimal()
        var localCopy = self
        NSDecimalRound(&result, &localCopy, scale, roundingMode)
        return result
    }
}
