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
	
	func test_getFromNetwork_sameRequests() {
		// arrange
		let firstRequest = DataProviderRequest.search(query: "hi", offset: 0)
		let secondRequest = DataProviderRequest.search(query: "hi", offset: 0)

		let firstCallExpectation = XCTestExpectation(description: "first call should stay")
		
		let secondCallExpectation = XCTestExpectation(description: "second call should not happen")
		secondCallExpectation.isInverted = true

		// act
		networkService?.getFromNetwork(model: firstRequest, { result in
			firstCallExpectation.fulfill()
		})
		networkService?.getFromNetwork(model: secondRequest, { result in
			secondCallExpectation.fulfill()
		})
		
		//assert
		wait(for: [firstCallExpectation, secondCallExpectation], timeout: 3)
	}
	
	func test_getFromNetwork_differentRequestsOfSameType() {
		// arrange
		let firstRequest = DataProviderRequest.search(query: "hi", offset: 0)
		let secondRequest = DataProviderRequest.search(query: "hilarious", offset: 0)
				
		let firstCallExpectation = XCTestExpectation(description: "old call should be cancelled")
		firstCallExpectation.isInverted = true
		
		let secondCallExpectation = XCTestExpectation(description: "newer call should happen")

		// act
		networkService?.getFromNetwork(model: firstRequest, { result in
			firstCallExpectation.fulfill()
		})
		networkService?.getFromNetwork(model: secondRequest, { result in
			secondCallExpectation.fulfill()
		})
		
		//assert
		wait(for: [firstCallExpectation, secondCallExpectation], timeout: 3)
	}
	
	func test_getFromNetwork_differentRequestsOfDifferentTypes() {
		// arrange
		let firstRequest = DataProviderRequest.search(query: "hi", offset: 0)
		let secondRequest = DataProviderRequest.detailed(query: "hi")
		
		let firstCallExpectation = XCTestExpectation(description: "old call should happen")
		let secondCallExpectation = XCTestExpectation(description: "newer call should happen")

		// act
		networkService?.getFromNetwork(model: firstRequest, { result in
			firstCallExpectation.fulfill()
		})
		networkService?.getFromNetwork(model: secondRequest, { result in
			secondCallExpectation.fulfill()
		})
		
		//assert
		wait(for: [firstCallExpectation, secondCallExpectation], timeout: 3)
	}
	
	func test_getFromNetwork_sameRequestHasFinishedLongAgo() {
		// arrange
		let firstRequest = DataProviderRequest.search(query: "hi", offset: 0)
		let secondRequest = DataProviderRequest.search(query: "hi", offset: 0)
		
		let firstCallExpectation = XCTestExpectation(description: "old call should happen")
		let secondCallExpectation = XCTestExpectation(description: "newer call should happen")

		// act
		networkService?.getFromNetwork(model: firstRequest, { result in
			firstCallExpectation.fulfill()
			self.networkService?.getFromNetwork(model: secondRequest, { result in
				secondCallExpectation.fulfill()
			})
		})

		
		//assert
		wait(for: [firstCallExpectation, secondCallExpectation], timeout: 3)
	}
	
}

class URLSessionMock: URLSessionFacadeProtocol {
	func dataTask(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
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
		timer?.cancel()
	}

	
	init(_ closure: @escaping () -> Void) {
		self.closure = closure
	}
		
	var delayTime: Double = 0.2
	private var timer: DispatchSourceTimer?
	
	let closure: () -> Void
}
