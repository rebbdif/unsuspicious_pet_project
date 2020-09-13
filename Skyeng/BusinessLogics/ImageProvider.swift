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
	func getImage(at url: String, completion: @escaping ImageProviderCompletion) 
	func cancelRequests(for word: Word)
}


class ImageProvider: ImageProviderProtocol {
	
	var cacheService: CacheServiceProtocol
	var networkService: NetworkServiceProtocol
	
	internal init(cacheService: CacheServiceProtocol, networkService: NetworkServiceProtocol) {
		self.cacheService = cacheService
		self.networkService = networkService
	}
	
	func getImage(at url: String, completion: @escaping ImageProviderCompletion) {
		
		let request = DataProviderRequest.media(query: url)
		
		cacheService.getFromCache(request: request) { [weak self] (result: DataProviderResponse<URL>?) in
			guard let self = self else {return}
			if let result = result,
				!result.isEmpty {
				if let url = result.value.first,
					let image = self.createImage(from: url) {
						completion(image)
						return
				}
			}
			
			networkService.getMediaFromNetwork(model: request) {[weak self] (result) in
				guard let self = self else {return}
				switch result {
				case .success(let url):
					let image = self.createImage(from: url)
					completion(image)
					if (image != nil) {
						self.cacheService.saveToCache(request: request, response: DataProviderResponse(answers: [url]) ) // todo: make it normal
					}
				case .failure(let error):
					// todo: handle
					break
				}
			}
			
		}

		
	
	}

	private func createImage(from url: URL) -> UIImage? {
		guard let data = try? Data(contentsOf: url) else { return nil}
		let image = UIImage(data: data)
		return image
	}
	
	func cancelRequests(for word: Word) {
		
	}
}
