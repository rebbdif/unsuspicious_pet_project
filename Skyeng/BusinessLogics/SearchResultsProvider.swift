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
	case detailed(query: String)
}



internal protocol DataProviderResponse {
	var isEmpty: Bool {get}
}

typealias SearchAnswer = String
struct NetworkResponse<T>: DataProviderResponse {
	internal init(answers: [T]) {
		self.answers = answers
	}
	
	var answers: [T]
	
	var isEmpty: Bool {
		return answers.count == 0
	}
}

internal typealias DataRequestCompletion = (Result<DataProviderResponse, DataProviderError>) -> Void


internal protocol ISearchResultsProvider {
	func handle(query: DataProviderRequest, completion: @escaping DataRequestCompletion)
}

class SearchResultsProvider: ISearchResultsProvider {

	var cacheService: CacheService
	var networkService: NetworkService
	var networkResponseParser: NetworkResponseParser
	
	internal init(cacheService: CacheService, networkService: NetworkService) {
		self.cacheService = cacheService
		self.networkService = networkService
		self.networkResponseParser = NetworkResponseParser()
	}
	
	func handle(query: DataProviderRequest, completion: @escaping DataRequestCompletion) {
		
		cacheService.getFromCache(request: query) { [weak self] result in
			guard let self = self else {return}
			if !result.isEmpty {
				completion(.success(result))
				return
			}
			
			self.networkService.getFromNetwork(model: query) { [weak self] (result) in
				guard let self = self else {return}
				switch result {
				case .success(let value):
					let parsingResult = self.networkResponseParser.parse(value)
//						completion(.success(value))
				case .failure(_):
					// todo: construct recoverable error from error
					break
				}
				
			}
			
		}
	}
}

struct NetworkResponseParser {
	func parse(_ data: Data) -> Result<DataProviderResponse, DataProviderError> {
		
		do {
			let words = try JSONDecoder().decode([Word].self, from: data)
//			if let words = words {
				return .success(NetworkResponse(answers: words))
//			}
		}
		catch let DecodingError.typeMismatch(type, context)  {
		   print("Type '\(type)' mismatch:", context.debugDescription)
		   print("codingPath:", context.codingPath)
		} catch let otherError {
			print(otherError)
		}
		
		
		return .failure(DataProviderError.responseError)
	}
}
