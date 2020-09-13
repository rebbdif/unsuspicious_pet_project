//
//  NetworkServiceTests.swift
//  SkyengTests
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import XCTest
@testable import Skyeng


class NetworkServiceTests: XCTestCase {

	var networkService: NetworkService?
	
	override func setUp() {
		let sessionMock = URLSessionMock()
		networkService = NetworkService(urlSession: sessionMock, urlProvider: URLProvider())
	}
	
	func test_performNewestRequest_sameRequests() {
		// arrange
		let firstRequest = DataProviderRequest.search(query: "hi", offset: 0)
		let secondRequest = DataProviderRequest.search(query: "hi", offset: 0)

		let firstCallExpectation = XCTestExpectation(description: "first call should stay")
		
		let secondCallExpectation = XCTestExpectation(description: "second call should not happen")
		secondCallExpectation.isInverted = true

		// act
		networkService?.performNewestRequest(model: firstRequest, { result in
			firstCallExpectation.fulfill()
		})
		networkService?.performNewestRequest(model: secondRequest, { result in
			secondCallExpectation.fulfill()
		})
		
		//assert
		wait(for: [firstCallExpectation, secondCallExpectation], timeout: 3)
	}
	
	func test_performNewestRequest_differentRequestsOfSameType() {
		// arrange
		let firstRequest = DataProviderRequest.search(query: "hi", offset: 0)
		let secondRequest = DataProviderRequest.search(query: "hilarious", offset: 0)
				
		let firstCallExpectation = XCTestExpectation(description: "old call should be cancelled")
		firstCallExpectation.isInverted = true
		
		let secondCallExpectation = XCTestExpectation(description: "newer call should happen")

		// act
		networkService?.performNewestRequest(model: firstRequest, { result in
			firstCallExpectation.fulfill()
		})
		networkService?.performNewestRequest(model: secondRequest, { result in
			secondCallExpectation.fulfill()
		})
		
		//assert
		wait(for: [firstCallExpectation, secondCallExpectation], timeout: 3)
	}
	
	func test_performNewestRequest_differentRequestsOfDifferentTypes() {
		// arrange
		let firstRequest = DataProviderRequest.search(query: "hi", offset: 0)
		let secondRequest = DataProviderRequest.detailed(query: "hi")
		
		let firstCallExpectation = XCTestExpectation(description: "old call should happen")
		let secondCallExpectation = XCTestExpectation(description: "newer call should happen")

		// act
		networkService?.performNewestRequest(model: firstRequest, { result in
			firstCallExpectation.fulfill()
		})
		networkService?.performNewestRequest(model: secondRequest, { result in
			secondCallExpectation.fulfill()
		})
		
		//assert
		wait(for: [firstCallExpectation, secondCallExpectation], timeout: 3)
	}
	
	func test_performNewestRequest_sameRequestHasFinishedLongAgo() {
		// arrange
		let firstRequest = DataProviderRequest.search(query: "hi", offset: 0)
		let secondRequest = DataProviderRequest.search(query: "hi", offset: 0)
		
		let firstCallExpectation = XCTestExpectation(description: "old call should happen")
		let secondCallExpectation = XCTestExpectation(description: "newer call should happen")

		// act
		networkService?.performNewestRequest(model: firstRequest, { result in
			firstCallExpectation.fulfill()
			self.networkService?.performNewestRequest(model: secondRequest, { result in
				secondCallExpectation.fulfill()
			})
		})

		
		//assert
		wait(for: [firstCallExpectation, secondCallExpectation], timeout: 3)
	}
	
}

class URLSessionMock: URLSessionFacadeProtocol {
	func downloadTask(url: URL, completionHandler: @escaping URLSessionDownloadTaskCompletion) -> URLSessionTaskProtocol {
		let mock = URLTaskMock {
			completionHandler(URL(string: "yandex.ru"), nil, nil)
		}
		return mock
	}
	
	func dataTask(url: URL, completionHandler: @escaping URLSessionDataTaskCompletion) -> URLSessionTaskProtocol {
		let mock = URLTaskMock {
			completionHandler(Data(), nil, nil)
		}
		return mock
	}
	
}


class URLTaskMock: URLSessionTaskProtocol {	
	func resume() {
		timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
		timer?.setEventHandler { [weak self] in
			print("firing closure")
			self?.closure()
		}
		timer?.schedule(deadline: .now() + delayTime)
		timer?.resume()
	}
	func cancel() {
		print("cancelling")
		timer?.cancel()
	}
	func suspend() {
		print("suspending")
		timer?.cancel()
	}

	
	init(_ closure: @escaping () -> Void) {
		self.closure = closure
	}
		
	var delayTime: Double = 0.2
	private var timer: DispatchSourceTimer?
	
	let closure: () -> Void
}
