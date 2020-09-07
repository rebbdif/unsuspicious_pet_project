//
//  main.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation
import UIKit


// If we have a TestingAppDelegate (i.e. we're running unit tests), use that to avoid executing initialisation code in AppDelegate
let testingAppDelegate: AnyClass? = NSClassFromString("TestingAppDelegate")
let appDelegateClass: AnyClass = testingAppDelegate ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))

//let isRunningTests = NSClassFromString("XCTestCase") != nil
//let appDelegateClass = isRunningTests ? NSStringFromClass(TestingAppDelegate.self) : NSStringFromClass(AppDelegate.self)
//
//let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
//
//UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClass)
