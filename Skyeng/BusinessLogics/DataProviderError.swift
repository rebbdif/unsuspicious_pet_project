//
//  DataProviderError.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

enum DataProviderError {
	// Любой 500 код
	case serverError
	// Ответ не такой, как мы ожидаем
	case responseError
	// Ответа нет, отвалились по таймауту, отсуствует сеть
	case internetError
	
	// todo: недопустимые символы
}

extension DataProviderError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .serverError, .responseError:
			return "Something bad happened"
		case .internetError:
			return "No internet connection"
		}
	}

	var recoverySuggestion: String? {
		switch self {
		case .serverError, .responseError:
			return nil
		case .internetError:
			return "Please check your internet connection"
		}
	}
}
