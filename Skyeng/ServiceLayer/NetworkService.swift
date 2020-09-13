//
//  NetworkService.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation


protocol NetworkServiceProtocol {
	
	/// This function should be used in situatins when only the most actual request of a type should be completed.
	/// - Parameters:
	///   - model: request model
	///   - completion: completion, called when actual request is fulfilled or error happens
	func performNewestRequest(model: DataProviderRequest, _ completion: @escaping (Result<Data, DataProviderError>) -> Void)
	
	typealias GetMediaCompletion = ((Result<URL, DataProviderError>) -> Void)
	func getMediaFromNetwork(model: DataProviderRequest, _ completion: @escaping GetMediaCompletion)
}

class NetworkService: NetworkServiceProtocol {
	
	private var urlSession: URLSessionFacadeProtocol
	private var urlProvider: URLProvider
	private var networkServiceQueue = DispatchQueue(label: "com.skyeng.networkServiceQueue")
	
	init(urlSession: URLSessionFacadeProtocol, urlProvider: URLProvider) {
		self.urlSession = urlSession
		self.urlProvider = urlProvider
	}
	
	private var activeTasks = [NetworkRequest]()
		
	func performNewestRequest(model: DataProviderRequest, _ completion: @escaping (Result<Data, DataProviderError>) -> Void ) {
		guard let request = self.networkRequest(for: model) else { return }
		let dataTask = self.urlSession.dataTask(url: request.url) {(data, resp, error) in
			request.onFinished?(request)
			if let data = data {
				completion(.success(data))
			} else {
				if let error = error?.asNSURLError  {
					switch error.code {
					case NSURLErrorNotConnectedToInternet:
					break // todo //	completion(.failure(error as! DataProviderError)) // todo
					default:
						return
					}
				}
			}
		}
		request.setTask(dataTask)
		
		networkServiceQueue.async { [weak self] in
			guard let self = self else {return}
			let sameTasks = self.activeTasks.filter { $0.url == request.url }
			if !sameTasks.isEmpty { return }
			
			let otherTasksOfTheType = self.activeTasks.filter {$0.type == request.type}
			otherTasksOfTheType.forEach { $0.cancel() }
			
			print("\(#function) starting task with \(request.url)")
			
			request.onFinished = {[weak self] (request) in
				self?.networkServiceQueue.async { [weak self] in
					self?.activeTasks.removeAll(where: {$0.url == request.url })
				}
			}
			
			self.activeTasks.append(request)
			
			request.task?.resume()
		}
	}
	
	func getMediaFromNetwork(model: DataProviderRequest, _ completion: @escaping GetMediaCompletion)
	{
		guard let request = self.networkRequest(for: model) else { return }
		let downloadTask = self.urlSession.downloadTask(url: request.url) {(fileUrl, resp, error) in
			request.onFinished?(request)
			if let fileUrl = fileUrl {
				completion(.success(fileUrl))
			}
			else {
				if let error = error?.asNSURLError  {
					switch error.code {
					case NSURLErrorNotConnectedToInternet:
					break // todo //	completion(.failure(error as! DataProviderError)) // todo
					default:
						print("\(#function) failed with \(error)")
						return
					}
				}
			}
		}
		request.setTask(downloadTask)

		self.activeTasks.append(request)
		
		request.task?.resume()
	}
	
	private func networkRequest(for request: DataProviderRequest) -> NetworkRequest? {
		guard let url = urlProvider.url(for: request) else { return nil}

		switch request {
		case .search(query: _, offset: _):
			return NetworkRequest.search(url: url)
		case .detailed(query: _):
			return NetworkRequest.query(url: url)
		case .media(query: _):
			return NetworkRequest.media(url: url)
		}
	}
}


fileprivate class NetworkRequest {
	
	enum RequestType: Int {
		case search, query, genericDataTask, media
	}
	
	var type: RequestType
	var url: URL
	
	func resume() {
		task?.resume()
		onFinished?(self)
	}
	
	func cancel() {
		task?.cancel()
	}
	
	func suspend() {
		task?.suspend()
	}
	
	var onFinished: ((NetworkRequest) -> Void)?
	var onCancelled: ((NetworkRequest) -> Void)?
	var onSuspended: ((NetworkRequest) -> Void)?
	
	var task: URLSessionTaskProtocol?
	func setTask(_ task: URLSessionTaskProtocol) {
		self.task = task
	}
	
	init(type: NetworkRequest.RequestType, url: URL) {
		self.type = type
		self.url = url
	}
}

extension NetworkRequest {
	static func search(url: URL) -> NetworkRequest {
		return NetworkRequest(type: .search, url: url)
	}
	
	static func query(url: URL) -> NetworkRequest {
		return NetworkRequest(type: .query, url: url)
	}
	
	static func genericDataTask(url: URL) -> NetworkRequest {
		return NetworkRequest(type: .genericDataTask, url: url)
	}
	
	static func media(url: URL) -> NetworkRequest {
		return NetworkRequest(type: .media, url: url)
	}
}

extension Error {
	
	var asNSURLError: NSError? {
		if let error = self as NSError?, error.domain == NSURLErrorDomain {
			return error
		}
		return nil
	}
}
