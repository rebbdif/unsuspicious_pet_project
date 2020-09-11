//
//  DetailsPresenter.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 11.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

class DetailsPresenter {
	
	public let word: Word
	
	internal init(word: Word) {
		self.word = word
	}
	
	func numberOfItems() -> Int {
		return word.meanings.count
	}
	
	func itemAt(index: Int) -> Meaning? {
		let meaning = word.meanings[index]
		return meaning
	}
	
	func back() {
		backBlock?()
	}
	
	public var backBlock: (() -> Void)?
	
	deinit {
		print("deinit")
	}
	
}
