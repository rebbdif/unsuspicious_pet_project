//
//  NetworkServiceTests.swift
//  SkyengTests
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import XCTest
@testable import Skyeng


//class URLSessionMock: URLSessionProtocol{
//	func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//		return URLSessionDataTask()
//	}
//}


class NetworkServiceTests: XCTestCase {

	var networkService: NetworkService?
	
	override func setUp() {
		let sessionMock = URLSessionFacade.shared // todo: fix
		networkService = NetworkService(urlSession: sessionMock)
	}
	
	func test_getFromNetwork_success() {
		// arrange
		let url = URL(string: "https://dictionary.skyeng.ru/api/public/v1/words/search?search=cat&page=1")!
		let networkRequest = NetworkRequest(url: url)
	
		// act
		networkService?.getFromNetwork(model: networkRequest, { [weak self] result in
			
		})
		
		sleep(5)
	
		//assert
	
	
	}
	
}
