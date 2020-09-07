//
//  URLProvider.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

class URLProvider {
	var baseURL: String {
		return "https://dictionary.skyeng.ru/api/public/v1/"
	}
	
	var searchMethod: String {
		return "words/search"
	}
	
	// #todo: сделать рандомногенерящейся тест на эту штуку
	func url(for request: DataProviderRequest) -> URL {
		switch request {
		case .search(query: let query, offset: let offset):
			let search = "search=\(query)"
			let offset = "page=\(offset)"
			let query = "\(baseURL)\(searchMethod)?\(search)&\(offset)"
			
			guard let url = URL(string: query) else {
				preconditionFailure("failed to create url from \(query)")
			}
			return url
		}
		
		
	}
}
