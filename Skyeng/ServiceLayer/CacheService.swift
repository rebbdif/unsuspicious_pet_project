//
//  CacheService.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

protocol CacheServiceProtocol {
	func getFromCache<T>(request: DataProviderRequest, completion: (NetworkResponse<T>?) -> (Void))
	
	func saveToCache<T>(request: DataProviderRequest, response: NetworkResponse<T>)
}

class CacheService: CacheServiceProtocol {
	
	private var cache: NSCache<AnyObject, AnyObject>
	
	init() {
		cache = NSCache()
	}
	
	func saveToCache<T>(request: DataProviderRequest, response: NetworkResponse<T>) {
		cache.setObject(response, forKey: NSString(string: request.rawValue))
	}
	
	func getFromCache<T>(request: DataProviderRequest, completion: (NetworkResponse<T>?) -> (Void)) {
		guard let response = cache.object(forKey: NSString(string: request.rawValue)) as? NetworkResponse<T> else {
			completion(nil)
			return
		}
		completion(response)
	}
}
