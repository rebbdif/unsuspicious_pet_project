//
//  SearchPresenter.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation


protocol ContentProvider {
	func numberOfItems() -> Int
	func itemAt(index: Int) -> Word?
}

protocol SearchProvider {
	func search(for: String)
}

protocol SearchPresenterInput: class, ContentProvider, SearchProvider {
	func selectedItem(at index: Int)
}

protocol SearchPresenterOutput: class {
	func updateSearchResults()
	func showError(_ error: SLVRecoverableError)
}


class SearchPresenter: SearchPresenterInput {
	
	// MARK: - Dependencies
	private var searchResultsProvider: ISearchResultsProvider
	private var view: SearchPresenterOutput

	required init(searchResultsProvider: ISearchResultsProvider, view: SearchPresenterOutput) {
		self.searchResultsProvider = searchResultsProvider
		self.view = view
	}
	
	// MARK: - Private
	var searchResults = [Word]()
	
	// MARK: - Public
	
	var showDetailsBlock: ((Word) -> Void)?
	
	func search(for string: String) {
		let query = DataProviderRequest.search(query: string, offset: 0)
		searchResultsProvider.handle(query: query) { [weak self] (result: Result<NetworkResponse<Word>, DataProviderError>)  in
			guard let self = self else {return}
			switch result {
			case .success(let searchResults):
				self.searchResults = searchResults.value
				self.view.updateSearchResults()
			case .failure(let error):
				break // todo
			}
		}
	}
	
	func numberOfItems() -> Int {
		return searchResults.count
	}
	
	func itemAt(index: Int) -> Word? {
		return searchResults[index]
	}
	
	func selectedItem(at index: Int) {
		let word = searchResults[index]
		showDetailsBlock?(word)
	}
	
	
}
