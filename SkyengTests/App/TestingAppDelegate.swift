//
//  TestAppDelegate.swift
//  SkyengTests
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation
import UIKit

@objc(TestingAppDelegate)
class TestingAppDelegate: UIResponder, UIApplicationDelegate {
	
    var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		let testingVC = UIViewController()
		testingVC.view.backgroundColor = .systemRed
		let label = UILabel()
		label.text = "Running Unit Tests"
		label.sizeToFit()
		testingVC.view.addSubview(label)
		
		label.center = testingVC.view.center
		
		window?.rootViewController = testingVC
		window?.makeKeyAndVisible()
		return true
	}
	
}
