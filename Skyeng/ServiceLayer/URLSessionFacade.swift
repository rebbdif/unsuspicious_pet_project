//
//  URLSessionFacade.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 08.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation


public protocol URLSessionTaskProtocol {
	func resume()
	func cancel()
	func suspend()
}

extension URLSessionTask: URLSessionTaskProtocol {}


public protocol URLSessionFacadeProtocol {
	typealias URLSessionDataTaskCompletion = (Data?, URLResponse?, Error?) -> Void
	func dataTask(url: URL, completionHandler: @escaping URLSessionDataTaskCompletion) -> URLSessionTaskProtocol
	
	typealias URLSessionDownloadTaskCompletion = (URL?, URLResponse?, Error?) -> Void
	func downloadTask(url: URL, completionHandler: @escaping URLSessionDownloadTaskCompletion) -> URLSessionTaskProtocol

}

class URLSessionFacade: URLSessionFacadeProtocol {
	
	static let shared = URLSessionFacade(session: URLSession.shared)
	
	private var session: URLSession
	
	internal init(session: URLSession) {
		self.session = session
	}
	
	func dataTask(url: URL, completionHandler: @escaping URLSessionDataTaskCompletion) -> URLSessionTaskProtocol {
		let task = session.dataTask(with: url, completionHandler: completionHandler)
		return task
	}
	
	
	
	func downloadTask(url: URL, completionHandler: @escaping URLSessionDownloadTaskCompletion) -> URLSessionTaskProtocol {
		let task = session.downloadTask(with: url, completionHandler: completionHandler)
		return task
	}
}
