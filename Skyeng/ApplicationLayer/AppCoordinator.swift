//
//  AppCoordinator.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
	
}

class AppCoordinator: NSObject {
		
	// MARK: - Properties
	
	public var window: UIWindow
	let context: AppContext
	
	var presenters = [AnyObject]() // todo: make analogue of UINavigationController but as stack of presenters. so it holds presenters of controllers, that are holded now. make Presenter protocol
	
	var rootController: UINavigationController?
	
	// MARK: - Lifecycle
	
	public init(window: UIWindow, context: AppContext) {
		self.window = window
		self.context = context
		
		rootController = UINavigationController()
		window.rootViewController = rootController
		window.makeKeyAndVisible()
	}
	
	public func start() {
		startSearchFlow()
	}
	
	public func startSearchFlow() {
		let searchStoryboard = UIStoryboard(name: "Search", bundle: nil)
		
		let searchVC = searchStoryboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
		
		let presenter = SearchPresenter(searchResultsProvider: context.searchResultsProvider, view: searchVC)
		presenter.showDetailsBlock = {[weak self] word in
			guard let self = self else {return}
			self.startDetailsFlow(for: word)
		}
		
		presenters.append(presenter)
		searchVC.presenter = presenter
		
		rootController?.pushViewController(searchVC, animated: true)
	}
	
	public func startDetailsFlow(for word: Word) {
		let searchStoryboard = UIStoryboard(name: "Details", bundle: nil)
		
		let detailsVC = searchStoryboard.instantiateViewController(identifier: "DetailsViewController") as! DetailsViewController
		
		let presenter = DetailsPresenter(imageProvider: context.imageProvider, word: word)
		presenter.backBlock = { [weak self] in
			guard let self = self else {return}
			self.rootController?.popViewController(animated: true)
			self.presenters.removeLast()
		}
		presenters.append(presenter)

		detailsVC.presenter = presenter
		
		rootController?.pushViewController(detailsVC, animated: true)
	}
	
	public func coordinatorDidFinish(_ coordinator: Coordinator) {
		
	}
			
}
