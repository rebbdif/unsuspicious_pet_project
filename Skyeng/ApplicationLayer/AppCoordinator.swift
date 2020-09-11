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
	
	var currentPresenter: AnyObject?
	
	// MARK: - Lifecycle
	
	public init(window: UIWindow, context: AppContext) {
		self.window = window
		self.context = context
	}
	
	public func start() {
		startSearchFlow()
	}
	
	public func startSearchFlow() {
		let mainStoryboard = UIStoryboard(name: "Search", bundle: nil)
		
		let chooseProjectsVC = mainStoryboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
		
		let presenter = SearchPresenter(searchResultsProvider: context.searchResultsProvider, view: chooseProjectsVC)
		
//		let presenter = PresenterMock()
		currentPresenter = presenter
		
		chooseProjectsVC.presenter = presenter
		window.rootViewController = chooseProjectsVC
		window.makeKeyAndVisible()
	}
	
	public func coordinatorDidFinish(_ coordinator: Coordinator) {
		
	}
			
}
