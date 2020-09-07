//
//  SearchResultsProvider.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation


internal enum DataProviderRequest {
	case search(query: String, offset: Int)
}

internal struct NetworkRequest {
	var url: URL
}

internal struct DataProviderResponse { //#todo: move
	
}

internal typealias DataRequestCompletion = (Result<DataProviderResponse, DataProviderError>) -> ()


internal protocol ISearchResultsProvider {
	func handle(query: NetworkRequest, completion: DataRequestCompletion)
}

class SearchResultsProvider: ISearchResultsProvider {

	
	var cacheService: CacheService
	var networkService: NetworkService
	
	internal init(cacheService: CacheService, networkService: NetworkService) {
		self.cacheService = cacheService
		self.networkService = networkService
	}
	
	func handle(query: NetworkRequest, completion: (Result<DataProviderResponse, DataProviderError>) -> ()) {
		cacheService.getFromCache { [weak self] (result) in
			switch result {
			case .success(let fetchedValue):
				break // completion(fetchedValue)
			case .failure(_):
				break
//				let request = DataProviderRequest.search(query: <#T##String#>, offset: <#T##Int#>, url: <#T##URL#>)
//				networkService.getFromNetwork(model: <#T##DataProviderRequest#>, <#T##completion: (Result<DataProviderResponse, RecoverableError>) -> Void##(Result<DataProviderResponse, RecoverableError>) -> Void#>)
//				networkService.getFromNetwork { [weak self] result in
					
				}
			}
		}
	}
	
	
	
	
	

//re}
