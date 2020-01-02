//
//  CPU+Debugging.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-09.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation
import os

protocol Debugging {
	func opCodeFetchPrint(code: UInt8)
	func opCodeNotImplementedPrint(code: UInt8)
	func opCodePrint(code: UInt8, func: String)
	func debugPrinting(message: String, code: UInt8)
}

extension CPU: Debugging {
	func opCodeFetchPrint(code: UInt8) {
		debugPrinting(message: "Fetching OPCode::", code: code)
	}
	
	func opCodeNotImplementedPrint(code: UInt8) {
		debugPrinting(message: "OPCode not implemented yet::", code: code)
	}
	
	func opCodePrint(code: UInt8, func: String) {
		debugPrinting(message: "Executing Instruction:: \(`func`) for ", code: code)
	}
	
	func debugPrinting(message: String, code: UInt8) {
		Logger.log("\(message) \(String(format:"0x%02X", code))")
	}
}

struct Logger {
	static func log(_ message: String) {
		#if DEBUG
		print(message)
//		Has a memory leak?
//		os_log("%{public}@", log: OSLog(subsystem: "Gameboy", category: "debugging"), type: .default, message)
		#endif
	}
}
