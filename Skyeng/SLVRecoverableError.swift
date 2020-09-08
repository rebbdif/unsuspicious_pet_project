//
//  SLVRecoverableError.swift
//  Skyeng
//
//  Created by Leonid Serebryanyy on 04.09.2020.
//  Copyright © 2020 Leonid Serebryanyy. All rights reserved.
//

import Foundation

struct SLVRecoverableError {
	let error: Error
	let attempter: RecoveryAttemper

	var localizedError: LocalizedError? {
		return error as? LocalizedError
	}
}

// MARK: - Foundation.RecoverableError
extension SLVRecoverableError: Foundation.RecoverableError {
	var recoveryOptions: [String] {
		return attempter.recoveryOptionsText
	}

	@discardableResult
	func attemptRecovery(optionIndex recoveryOptionIndex: Int) -> Bool {
		let recoverResult = attempter.attemptRecovery(fromError: error, optionIndex: recoveryOptionIndex)
		return recoverResult
	}

	func attemptRecovery(optionIndex: Int, resultHandler: (Bool) -> Void) {
		let recoverResult = attempter.attemptRecovery(fromError: error, optionIndex: optionIndex)
		resultHandler(recoverResult)
	}
}

// MARK: - LocalizedError
extension SLVRecoverableError: LocalizedError {
	var errorDescription: String? {
		return localizedError?.errorDescription ?? "Something bad happened"
	}

	var recoverySuggestion: String? {
		return localizedError?.recoverySuggestion
	}
}
