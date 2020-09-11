//
//  ImageProvider.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 11.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation
import UIKit


protocol ImageProviderProtocol {
	typealias ImageProviderCompletion = (UIImage?) -> Void
	func getImage(at url: URL, completion: @escaping ImageProviderCompletion)
	func cancelRequests(for word: Word)
}


class ImageProvider: ImageProviderProtocol {
	
	var cacheService: CacheService
	var networkService: NetworkService
	
	internal init(cacheService: CacheService, networkService: NetworkService) {
		self.cacheService = cacheService
		self.networkService = networkService
	}
	
	func getImage(at url: URL, completion: @escaping ImageProviderCompletion)
	{

	}
	
	func cancelRequests(for word: Word) {
		
	}
}
