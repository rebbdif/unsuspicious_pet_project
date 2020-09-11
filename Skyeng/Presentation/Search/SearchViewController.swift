//
//  SearchViewController.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, SearchPresenterOutput, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	
	// MARK: - public
	weak var presenter: SearchPresenterInput?
	
	// MARK: - lifecycle
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		configureTable()
		configureSearch()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = true
		searchBar.becomeFirstResponder()
	}
	
	// MARK: - Results View
	
	private func configureTable() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
		tableView.keyboardDismissMode = .onDrag
	}
	
	private let cellReuseId = "TranslationCell"
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.numberOfItems() ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId) else {
			return UITableViewCell()
		}
		
		guard let item = presenter?.itemAt(index: indexPath.row) else {
			return cell
		}
		
		cell.textLabel?.text = item.text
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter?.selectedItem(at: indexPath.row)
	}
	
	// MARK: - SearchPresenterOutput
	
	func updateSearchResults() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else {return}
			self.tableView.reloadData()
		}
	}
	
	func showError(_ error: SLVRecoverableError) {
		
	}
	
	// MARK: - Search
	
	private func configureSearch() {
		searchBar.delegate = self
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		presenter?.search(for: searchText)
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		
	}
   
}
