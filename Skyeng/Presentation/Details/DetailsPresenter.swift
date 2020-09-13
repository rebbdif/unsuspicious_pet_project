//
//  DetailsPresenter.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 11.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation
import UIKit

class DetailsPresenter {
	
	private let imageProvider: ImageProviderProtocol
	
	internal init(imageProvider: ImageProviderProtocol, word: Word) {
		self.imageProvider = imageProvider
		self.word = word
	}
	
	// MARK: - Output
	
	let word: Word

	func numberOfItems() -> Int {
		return word.meanings.count
	}
	
	func itemAt(index: Int) -> Meaning? {
		let meaning = word.meanings[index]
		return meaning
	}
	
	func getImage(for index: Int, completion: @escaping (UIImage?) -> Void) {
		let meaning = word.meanings[index]
		guard let url = meaning.imageUrl else { return }
		
		imageProvider.getImage(at: url) { (image) in
			completion(image)
		}
		
	}
	
	func back() {
		imageProvider.cancelRequests(for: self.word)
		backBlock?()
	}
	
	// MARK: - Input
	
	public var backBlock: (() -> Void)?

	
}
