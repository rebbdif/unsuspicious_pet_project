//
//  SearchResultModel.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 10.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation


struct Word {
	let id: Int
	let text: String
	let meanings: [Meaning]
}

extension Word: Decodable {
	
}

struct Meaning  {
	struct Translation {
		let word: String
		let note: String
	}
	let id: Int
	let partOfSpeechCode: String
	let soundURL: String?
	let transcription: String
}

extension Meaning: Decodable {
	
}
