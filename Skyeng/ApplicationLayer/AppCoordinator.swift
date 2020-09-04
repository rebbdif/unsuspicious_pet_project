//
//  AppCoordinator.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation
import UIKit



class AppCoordinator: NSObject {
		
	// MARK: - Properties
	
	public var window: UIWindow
	let context: AppContext
	
	// MARK: - Lifecycle
	
	public init(window: UIWindow, context: AppContext) {
		self.window = window
		self.context = context
	}
	
	public func start() {
		// startChooseProjectFlow()
	}
//	
//	public func startChooseProjectFlow() {
//		let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//		let chooseProjectNavigationVC = mainStoryboard.instantiateInitialViewController() as! UINavigationController
//		let chooseProjectsVC = mainStoryboard.instantiateViewController(identifier: "MyProjectsViewController") as! MyProjectsViewController
//		
//		chooseProjectsVC.coordinator = self
//		// и тут можно сервисы всякие передавать в контроллер
//		
//		chooseProjectNavigationVC.viewControllers = [chooseProjectsVC]
//		
//		window.rootViewController = chooseProjectNavigationVC
//		window.makeKeyAndVisible()
//	}
//	
//	public func startProduction() {
//		let productionStoryboard = UIStoryboard(name: "Production", bundle: nil)
//		let videoVC = productionStoryboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController // identifier = это storyboard id у контроллера
//		videoVC.coordinator = self
//		window.rootViewController = videoVC
//		window.makeKeyAndVisible()
//	}
		
	public func startPostproduction(with project: Any) { //todo: put project class instead of any
		
	}
	
//	public func cancelProduction() {
//		self.startChooseProjectFlow()
//	}
//	
	deinit {
		print("DEINIT")
	}
			
}
