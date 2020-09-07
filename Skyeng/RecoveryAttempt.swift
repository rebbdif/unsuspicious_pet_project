//
//  RecoveryAttempt.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

struct RecoveryAttemper {
	private let recoveryOptions: [RecoveryOptions]

	var recoveryOptionsText: [String] {
		return recoveryOptions.map({ $0.title })
	}

	init(recoveryOptions: [RecoveryOptions]) {
		self.recoveryOptions = recoveryOptions
	}

	func attemptRecovery(fromError error: Error, optionIndex: Int) -> Bool {
		let option = recoveryOptions[optionIndex]
		switch option {
		case .tryAgain(let action),
			 .freeSpace(let action),
			 .buyMoreSpace(let action):
			action()
			return true
		case .custom(_, let action):
			action()
			return true
		case .cancel:
			return false
		}
	}

	static func tryAgainAttempter(block: @escaping (() -> Void)) -> Self {
		return RecoveryAttemper(recoveryOptions: [.cancel, .tryAgain(action: block)])
	}

	static func cancalableAttemter(options: [RecoveryOptions]) -> Self {
		return RecoveryAttemper(recoveryOptions: [.cancel] + options)
	}
}
