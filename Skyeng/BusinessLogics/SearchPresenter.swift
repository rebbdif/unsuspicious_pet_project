//
//  SearchPresenter.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

struct SearchResultItem {
	var title: String
}

protocol ContentProvider {
	func numberOfItems() -> Int
	func itemAt(index: Int) -> SearchResultItem?
}

protocol SearchProvider {
	func search(for: String)
}

protocol SearchPresenterInput: class, ContentProvider, SearchProvider {
//	init(searchResultsProvider: ISearchResultsProvider, view: SearchPresenterOutput)
}

protocol SearchPresenterOutput: class {
	func updateSearchResults()
	func showError(_ error: SLVRecoverableError)
}


class SearchPresenter: SearchPresenterInput {
	private var searchResultsProvider: ISearchResultsProvider
	private var view: SearchPresenterOutput

	required init(searchResultsProvider: ISearchResultsProvider, view: SearchPresenterOutput) {
		self.searchResultsProvider = searchResultsProvider
		self.view = view
	}
	
	
	func search(for: String) {
		
	}
	
	func numberOfItems() -> Int {
		return 0
	}
	
	func itemAt(index: Int) -> SearchResultItem? {
		return nil
	}
	
	
}
