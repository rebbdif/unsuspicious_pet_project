//
//  URLProvider.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 07.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

protocol URLProviderProtocol {
	func url(for request: DataProviderRequest) -> URL?
}

class URLProvider: URLProviderProtocol {
	var baseURL: String {
		return "https://dictionary.skyeng.ru/api/public/v1/"
	}
	
	var searchMethod: String {
		return "words/search"
	}
	
	// #todo: сделать рандомногенерящейся тест на эту штуку
	func url(for request: DataProviderRequest) -> URL? {
		switch request {
		case .search(query: let query, offset: let offset):
			let search = "search=\(query)"
			
			guard let encodedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
				print("\(#function) failed to turn to url \(search)")
				return nil
			}
			
			let offset = "page=\(offset)"
			let query = "\(baseURL)\(searchMethod)?\(encodedSearch)&\(offset)"
			
			guard let url = URL(string: query) else {
				print("\(#function) failed to turn to url \(query)")
				return nil
			}
			
			return url
			
		case .detailed(query: let query):
			return URL(string: "google.com") // todo
			
		case .media(query: let query):
			return URL(string: "https:\(query)")

		}
		
		
	}
}
