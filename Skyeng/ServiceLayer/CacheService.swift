//
//  CacheService.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

protocol CacheServiceProtocol {
	func getFromCache(request: DataProviderRequest, completion: (DataProviderResponse) -> (Void))
}

class CacheService: CacheServiceProtocol {
	func getFromCache(request: DataProviderRequest, completion: (DataProviderResponse) -> (Void)) {
		let emptyResult = NetworkResponse(answers: [])
		completion(emptyResult)
	}
}
