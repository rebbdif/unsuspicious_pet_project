//
//  SearchResultsProvider.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation


internal typealias DataRequestCompletion<T> = (Result<DataProviderResponse<T>, DataProviderError>) -> Void


internal protocol ISearchResultsProvider {
	func handle<T: Decodable>(query: DataProviderRequest, completion: @escaping DataRequestCompletion<T>)
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
	
	
	func handle<T: Decodable>(query: DataProviderRequest, completion: @escaping DataRequestCompletion<T>) {

		cacheService.getFromCache(request: query) { [weak self] (result: DataProviderResponse<T>?) in
			guard let self = self else {return}
			if let result = result,
				!result.isEmpty {
				completion(.success(result))
				return
			}
			
			self.networkService.performNewestRequest(model: query) { [weak self] (result) in
				guard let self = self else {return}
				switch result {
				case .success(let value):
					let parsingResult = self.networkResponseParser.parse(value, to: [T.self])
					completion(parsingResult)
					if case .success(let toCache) = parsingResult {
						self.cacheService.saveToCache(request: query, response: toCache)
					}
					
				case .failure(let error):
					completion(.failure(error))
				}
				
			}
			
		}
	}
}

struct NetworkResponseParser {
	func parse<T:Decodable>(_ data: Data, to: [T.Type]) -> Result<DataProviderResponse<T>, DataProviderError> {
		
		do {
			let items = try JSONDecoder().decode([T].self, from: data)
			return .success(DataProviderResponse(answers: items))
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
