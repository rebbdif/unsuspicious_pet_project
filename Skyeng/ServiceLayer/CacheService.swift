//
//  CacheService.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

protocol CacheServiceProtocol {
	func getFromCache<T>(request: DataProviderRequest, completion: (DataProviderResponse<T>?) -> (Void))
	func saveToCache<T>(request: DataProviderRequest, response: DataProviderResponse<T>)

}

class CacheService: CacheServiceProtocol {
	
	private var cache: NSCache<AnyObject, AnyObject>
	
	init() {
		cache = NSCache()
	}
	
	func saveToCache<T>(request: DataProviderRequest, response: DataProviderResponse<T>) {
		cache.setObject(response, forKey: NSString(string: request.rawValue))
	}
	
	func getFromCache<T>(request: DataProviderRequest, completion: (DataProviderResponse<T>?) -> (Void)) {
		guard let response = cache.object(forKey: NSString(string: request.rawValue)) as? DataProviderResponse<T> else {
			completion(nil)
			return
		}
		completion(response)
	}
}
