//
//  DataProviderModels.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 14.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation


internal enum DataProviderRequest {
	case search(query: String, offset: Int)
	case detailed(query: String)
	case media(query: String)
	
	var rawValue: String {
		switch self {
		case .search(let query, let offset):
			return "\(query)->\(offset)"
		case .detailed(query: let query):
			return "\(query)"
		case .media(query: let query):
			return "\(query)"
		}
	}
	
	var isUnique: Bool {
		if case .search = self {
			return true
		}
		return false
	}
}


class DataProviderResponse<T>  {
	
	var value: [T]
	
	internal init(answers: [T]) {
		self.value = answers
	}
		
	var isEmpty: Bool {
		return value.isEmpty
	}
}
