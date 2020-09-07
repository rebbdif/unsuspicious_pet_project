//
//  CacheService.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

protocol CacheServiceProtocol {
	func getFromCache(completion: (Result<DataProviderResponse, Error>) -> Void)
}

class CacheService {
	
	func getFromCache(completion: (Result<DataProviderResponse, Error>) -> Void) {
		
	}
}
