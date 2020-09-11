//
//  CacheService.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

protocol CacheServiceProtocol {
	func getFromCache<T>(request: DataProviderRequest, completion: (NetworkResponse<T>) -> (Void))
}

class CacheService: CacheServiceProtocol {
	func getFromCache<T>(request: DataProviderRequest, completion: (NetworkResponse<T>) -> (Void)) {
		let emptyResult = NetworkResponse<T>(answers: [T]())
		completion(emptyResult)
	}
}
