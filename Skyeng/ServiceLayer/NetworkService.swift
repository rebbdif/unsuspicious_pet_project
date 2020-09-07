//
//  NetworkService.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation


protocol NetworkServiceProtocol {
	func getFromNetwork(model: NetworkRequest, _ completion: (Result<DataProviderResponse, RecoverableError>) -> Void )
}


class NetworkService {
	
	var urlSession: URLSessionFacadeProtocol
	
	init(urlSession: URLSessionFacadeProtocol) {
		self.urlSession = urlSession
	}
	
	func getFromNetwork(model: NetworkRequest, _ completion: (Result<DataProviderResponse, RecoverableError>) -> Void ) {
		print("getting from \(model.url)")
		// if not deduplicating
		let dataTask = urlSession.dataTask(with: model.url) { (data, resp, error) in
			if let data = data {
				
			}
			
		}
		dataTask.resume()
	}
	
//	private func response(for request: NetworkRequest, data: [String: Any]>) {
//		switch request.request {
//		case .search(query: let query, offset: let offset):
//			break
//		}
//	}
}


public protocol URLSessionFacadeProtocol {
	func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLTaskProtocol
	
	
}

//public protocol URLTaskProtocol {

//}

public protocol URLTaskProtocol {
	init()
	func resume()
	func cancel()
	func suspend()
}

extension URLSessionDataTask: URLTaskProtocol {
	
	open override func resume() {
		self.resume()
	}
	
}


class URLSessionFacade: URLSessionFacadeProtocol {
	
	static let shared = URLSessionFacade(session: URLSession.shared)
	
	private var session: URLSession
	
	internal init(session: URLSession) {
		self.session = session
	}
	
	func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLTaskProtocol {
		return session.dataTask(with: url, completionHandler: completionHandler) as URLTaskProtocol
	}
	


}
