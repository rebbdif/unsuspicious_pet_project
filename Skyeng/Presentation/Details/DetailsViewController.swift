//
//  DetailsViewController.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 11.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	public weak var presenter: DetailsPresenter?
	
	@IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.hidesBackButton = true
		let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
		self.navigationItem.leftBarButtonItem = newBackButton
		configureTable()
    }
	
	@objc
	func back() {
		presenter?.back()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.isHidden = false
		self.title = presenter?.word.text		
	}
	
	// MARK: - Results View
	
	private func configureTable() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(DetailsCell.self, forCellReuseIdentifier: cellReuseId)
		tableView.rowHeight = UITableView.automaticDimension
	}
	
	private let cellReuseId = "DetailsCell"
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.numberOfItems() ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as? DetailsCell else {
			return UITableViewCell()
		}
		
		guard let item = presenter?.itemAt(index: indexPath.row) else {
			return cell
		}
		
		cell.setTitle(item.translation.text)
		cell.setMediaViewState(.loading)
		presenter?.getImage(for: indexPath.row, completion: { (image) in
			DispatchQueue.main.async {
				guard let image = image else {
					cell.setMediaViewState(.empty)
					return
				}
				cell.setMediaViewState(.image(image))
			}
			
		})
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}
	
	

}
