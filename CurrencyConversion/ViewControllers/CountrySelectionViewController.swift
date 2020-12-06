//
//  CountrySelectionViewController.swift
//  CurrencyConversion
//
//  Created by Srujan k on 02/12/20.
//

import UIKit



protocol UiDelegate: AnyObject{
    func didSelectedCountry(country: Country)
}

class CountrySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let viewModel = CCViewModel()
    private var dataSource: [Country]? = [Country]()
    weak var uiDelegate: UiDelegate?
    
    // MARK: - Controller Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getListOfCountries { [weak self] (countries) in
            SharedMemory.shared.countrylist?.append(contentsOf: countries ?? [Country]())
            self?.dataSource?.append(contentsOf: countries ?? [Country]())
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    // MARK: - UITableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource?[indexPath.row].value
        cell.detailTextLabel?.text = dataSource?[indexPath.row].code
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) { [weak self] in
            if let country = self?.dataSource?[indexPath.row] {
                SharedMemory.shared.selectedCountry = country
                self?.uiDelegate?.didSelectedCountry(country: country)
            }
        }
    }
    // MARK: - UISearchBar Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 0{
            self.dataSource = viewModel.searchCountries(searchText: searchText, countries: SharedMemory.shared.countrylist ?? [Country]())
            self.tableView.reloadData()
        }else{
            self.dataSource = SharedMemory.shared.countrylist
            self.tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
