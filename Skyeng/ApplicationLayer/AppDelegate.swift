//
//  AppDelegate.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		appContext = AppContext()
		return true
	}
	
	private var appContext: AppContext!
	
	static func getServicesAssembly() -> AppContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.appContext
	}
	
}



