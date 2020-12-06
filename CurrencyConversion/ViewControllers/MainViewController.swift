//
//  MainViewController.swift
//  CurrencyConversion
//
//  Created by Srujan k on 01/12/20.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, UiDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tfOfSourceCurrency: UITextField!
    @IBOutlet weak var tfOfAmount: UITextField!
    @IBOutlet weak var tableView: UITableView!

    lazy var countrySelectionView: UIViewController = {
        let countrySelectionVC = self.storyboard!.instantiateViewController(withIdentifier: "CountrySelectionViewController") as! CountrySelectionViewController
        countrySelectionVC.uiDelegate = self
        return countrySelectionVC
    }()
    lazy var viewModel: CCViewModel = {
        return CCViewModel()
    }()
    
    // MARK: - Controller Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addToolbar()
        self.hideKeyboardOnTap()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveLiveCurrency), name: .init(rawValue: Constants.DidReceiveLiveCurrency), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - UITextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfOfSourceCurrency {
            showCountriesView()
            return false
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfOfAmount{
            searchText()
        }
    }
    // MARK: - UITableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedMemory.shared.currencyList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let countryDetails = "\(SharedMemory.shared.currencyList?[indexPath.row].countryName ?? "") - " + "\(SharedMemory.shared.currencyList?[indexPath.row].code ?? "")"
        cell?.textLabel?.text = countryDetails
        if let value = SharedMemory.shared.currencyList?[indexPath.row].value{
            cell?.detailTextLabel?.text = "\(value)"
        }else{
            cell?.detailTextLabel?.text = "NA"
        }
        
        return cell ?? UITableViewCell()
    }
    // MARK: - Other Methods
    func showCountriesView(){
        self.present(countrySelectionView, animated: true, completion: nil)
    }
    func addToolbar() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        tfOfAmount.inputAccessoryView = numberToolbar
    }
    func searchText()  {
        if let enteredAmount = tfOfAmount.text?.convertStringToDecimal(){
            SharedMemory.shared.enteredAmount = enteredAmount
            viewModel.listenForCurrencyList()
        }else{
            viewModel.unsubscribeList()
            SharedMemory.shared.currencyList?.removeAll()
            self.tableView.reloadData()
        }
    }
    // MARK: - Action Methods
    @objc func doneWithNumberPad() {
        self.view.endEditing(true)
        searchText()
    }
    // MARK: - Notification Center
    @objc func didReceiveLiveCurrency(_ notification: Notification) {
        if let userInfo = notification.userInfo, let currencyList = userInfo[Constants.currency] as? [Currency]{
            SharedMemory.shared.currencyList?.removeAll()
            SharedMemory.shared.currencyList?.append(contentsOf: currencyList)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    // MARK: - UI Delegate Method
    func didSelectedCountry(country: Country) {
        self.tfOfSourceCurrency.text = country.value
        SharedMemory.shared.currencyList?.removeAll()
        SharedMemory.shared.enteredAmount = 0
        tfOfAmount.text = ""
        tableView.reloadData()
    }
}
extension String{
    func convertStringToDecimal() -> Decimal? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: self) {
            return number.decimalValue
        }
        return nil
    }
}
