//
//  AppContext.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation
 

class AppContext {
	
	lazy var searchResultsProvider: ISearchResultsProvider = SearchResultsProvider(
		cacheService: CacheService(),
		networkService: NetworkService(urlSession: URLSessionFacade.shared, urlProvider: URLProvider())
	)
	
	lazy var imageProvider: ImageProviderProtocol = ImageProvider(
		cacheService: CacheService(),
		networkService: NetworkService(urlSession: URLSessionFacade.shared, urlProvider: URLProvider())
	)
	
	init() {
		
	}
	
}
