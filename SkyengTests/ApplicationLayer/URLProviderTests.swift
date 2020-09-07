//
//  URLProviderTests.swift
//  SkyengTests
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import XCTest
@testable import Skyeng


class URLProviderTests: XCTestCase {
	
	var urlProvider: URLProvider?
	
	override func setUp() {
		urlProvider = URLProvider()
	}
	
	func testURLForRequest_search() {
		// arrange
		let request = DataProviderRequest.search(query: "cat", offset: 1)
		
		// act
		let result = urlProvider?.url(for: request)
		
		//assert
		let expected = URL(string: "https://dictionary.skyeng.ru/api/public/v1/words/search?search=cat&page=1")

		XCTAssertEqual(result, expected)
	}
}
