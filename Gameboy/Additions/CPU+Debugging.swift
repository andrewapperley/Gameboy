//
//  CPU+Debugging.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-09.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation
private var instructionHistory: [String] = []
protocol Debugging {
	func opCodeFetchPrint(code: UInt8)
	func opCodeNotImplementedPrint(code: UInt8, innerCode: UInt8?)
	func opCodePrint(code: UInt8, func: String, innerCode: UInt8?)
	func debugPrinting(message: String, code: UInt8, innerCode: UInt8?)
}

extension CPU: Debugging {
	func opCodeFetchPrint(code: UInt8) {
		debugPrinting(message: "Fetching OPCode::", code: code)
	}
	
	func opCodeNotImplementedPrint(code: UInt8, innerCode: UInt8? = nil) {
		debugPrinting(message: "OPCode not implemented yet::", code: code, innerCode: innerCode)
	}
	
	func opCodePrint(code: UInt8, func: String, innerCode: UInt8? = nil) {
		debugPrinting(message: "Executing Instruction:: \(`func`) for ", code: code, innerCode: innerCode)
	}
	
	func debugPrinting(message: String, code: UInt8, innerCode: UInt8? = nil) {
		#if DEBUG
			var printing = "\(message) \(String(format:"0x%02X", code))"
			if let inner = innerCode {
				printing += " inner \(String(format:"0x%02X", inner))"
			}
			instructionHistory.append(printing)
			print(printing)
		#endif
	}
}
