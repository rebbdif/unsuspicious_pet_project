//
//  AppDelegate.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import UIKit
import CoreData

class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var coordinator: AppCoordinator?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		appContext = AppContext()
//		application.requestSceneSessionActivation(nil, userActivity: nil, options: nil) { (error) in
//
//		}
		
		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window
		
		coordinator = AppCoordinator(window: window, context: AppDelegate.getServicesAssembly())
		
		coordinator?.start()
		
		return true
	}
		
//	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//		connectingSceneSession.scene?.delegate = UISceneDelegate..
//		return UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
//	}
	
	
	private var appContext: AppContext!
	
	static func getServicesAssembly() -> AppContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.appContext
	}
	
}



