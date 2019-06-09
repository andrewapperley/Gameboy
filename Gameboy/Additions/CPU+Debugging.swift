//
//  CPU+Debugging.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-09.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

protocol Debugging {
	func opCodePrint(code: UInt8, func: String, innerCode: UInt8?)
}

extension CPU: Debugging {
	func opCodePrint(code: UInt8, func: String, innerCode: UInt8? = nil) {
		#if DEBUG
			var printing = "Executing Instruction:: \(`func`) for \(String(format:"0x%02X", code))"
			if let inner = innerCode {
				printing += " inner \(String(format:"0x%02X", inner))"
			}
			print(printing)
		#endif
	}
}
