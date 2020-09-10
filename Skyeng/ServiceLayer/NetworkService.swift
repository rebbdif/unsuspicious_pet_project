//
//  NetworkService.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation


protocol NetworkServiceProtocol {
	func getFromNetwork(model: DataProviderRequest, _ completion: @escaping (Result<Data, DataProviderError>) -> Void )
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
		
	func getFromNetwork(model: DataProviderRequest, _ completion: @escaping (Result<Data, DataProviderError>) -> Void ) {
		let request = self.networkRequest(for: model)
		networkServiceQueue.async { [weak self] in
			guard let self = self else {return}
			let sameTasks = self.activeTasks.filter { $0.url == request.url }
			if !sameTasks.isEmpty { return }
			
			let otherTasksOfTheType = self.activeTasks.filter {$0.type == request.type}
			otherTasksOfTheType.forEach { $0.cancel() }
			
			print("\(#function) starting task with \(request.url)")
			
			let dataTask = self.urlSession.dataTask(url: request.url) {(data, resp, error) in
				request.onFinished?(request)
				if let data = data {
					completion(.success(data))
				} else {
					completion(.failure(error as! DataProviderError)) // todo
				}
			}
			request.onFinished = {[weak self] (request) in
				self?.networkServiceQueue.async { [weak self] in
					self?.activeTasks.removeAll(where: {$0.url == request.url })
				}
			}
			request.setTask(dataTask)
			
			self.activeTasks.append(request)
			dataTask.resume()
		}
	}
	
	private func networkRequest(for request: DataProviderRequest) -> NetworkRequest {
		let url = urlProvider.url(for: request)

		switch request {
		case .search(query: _, offset: _):
			return NetworkRequest.search(url: url)
		case .detailed(query: _):
			return NetworkRequest.query(url: url)
		}
	}
}


fileprivate class NetworkRequest {
	
	enum RequestType: Int {
		case search, query, genericDataTask
	}
	
	public var type: RequestType
	public var url: URL
	
	public func resume() {
		task?.resume()
		onFinished?(self)
	}
	
	public func cancel() {
		task?.cancel()
		onFinished?(self)
	}
	
	public func suspend() {
		task?.suspend()
		onFinished?(self)
	}
	
	public var onFinished: ((NetworkRequest) -> Void)?
	public var onCancelled: ((NetworkRequest) -> Void)?
	public var onSuspended: ((NetworkRequest) -> Void)?
	
	private var task: URLSessionTaskProtocol?
	public func setTask(_ task: URLSessionTaskProtocol) {
		self.task = task
	}
	
	init(type: NetworkRequest.RequestType, url: URL) {
		self.type = type
		self.url = url
	}
	
	static func search(url: URL) -> NetworkRequest {
		return NetworkRequest(type: .search, url: url)
	}
	
	static func query(url: URL) -> NetworkRequest {
		return NetworkRequest(type: .query, url: url)
	}
	
	static func genericDataTask(url: URL) -> NetworkRequest {
		return NetworkRequest(type: .genericDataTask, url: url)
	}
}
