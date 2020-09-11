//
//  NetworkParserTests.swift
//  SkyengTests
//
//  Created by Leonid Serebryanyy on 10.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import XCTest
@testable import Skyeng

class NetworkParserTests: XCTestCase {

	func test_wordParsing_basic() {
		// arrange
		let parser = NetworkResponseParser()
		let dataAsString = """
[{
		"id": 631,
		"text": "fine",
		"meanings": [{
				"id": 168802,
				"partOfSpeechCode": "n",
				"translation": {
					"text": "штраф",
					"note": null
				},
				"previewUrl": "//d2zkmv5t5kao9.cloudfront.net/images/c09e4d7692867e6f527104de547bd97a.png?w=96&h=72",
				"imageUrl": "//d2zkmv5t5kao9.cloudfront.net/images/c09e4d7692867e6f527104de547bd97a.png?w=640&h=480",
				"transcription": "faɪn",
				"soundUrl": "//d2fmfepycn0xw0.cloudfront.net?gender=male&accent=british&text=fine"
			},
			{
				"id": 168804,
				"partOfSpeechCode": "j",
				"translation": {
					"text": "превосходный",
					"note": null
				},
				"previewUrl": "//d2zkmv5t5kao9.cloudfront.net/images/f76babc5d19962c92008d4133c228593.jpeg?w=96&h=72",
				"imageUrl": "//d2zkmv5t5kao9.cloudfront.net/images/f76babc5d19962c92008d4133c228593.jpeg?w=640&h=480",
				"transcription": "faɪn",
				"soundUrl": "//d2fmfepycn0xw0.cloudfront.net?gender=male&accent=british&text=fine"
			},
			{
				"id": 168806,
				"partOfSpeechCode": "j",
				"translation": {
					"text": "мелкий",
					"note": ""
				},
				"previewUrl": "//d2zkmv5t5kao9.cloudfront.net/images/6041ddb693e43785c7be42c71771f77e.png?w=96&h=72",
				"imageUrl": "//d2zkmv5t5kao9.cloudfront.net/images/6041ddb693e43785c7be42c71771f77e.png?w=640&h=480",
				"transcription": "faɪn",
				"soundUrl": "//d2fmfepycn0xw0.cloudfront.net?gender=male&accent=british&text=fine"
			}
]
}]
"""
		let data = dataAsString.data(using: .utf8)!
	
		// act
		let result = parser.parse(data, to:[Word.self])
		
		switch result {
		case .success(let response):
			break
		case .failure(let error):
			XCTAssertTrue(false)
		}
	
	}
	
	func test_meaningParsing_basic() {
		// arrange
		let dataAsString = """
	{
					"id": 168802,
					"partOfSpeechCode": "n",
					"translation": {
						"text": "штраф",
						"note": null
					},
					"previewUrl": "//d2zkmv5t5kao9.cloudfront.net/images/c09e4d7692867e6f527104de547bd97a.png?w=96&h=72",
					"imageUrl": "//d2zkmv5t5kao9.cloudfront.net/images/c09e4d7692867e6f527104de547bd97a.png?w=640&h=480",
					"transcription": "faɪn",
					"soundUrl": "//d2fmfepycn0xw0.cloudfront.net?gender=male&accent=british&text=fine"
				}
	"""
		let data = dataAsString.data(using: .utf8)!
		
		// act
		do {
			let result = try JSONDecoder().decode(Meaning.self, from: data)
		} catch let error {
			print(error)
			
		}
		//assert
		
		XCTAssertNoThrow(Error.self)
	}
	
	
}
