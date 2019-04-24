//
//  CPU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

private protocol Register {
	func high() -> Int8
	func low() -> Int8
}

struct Registers {
	var AF: Int16
	var BC: Int16
	var DE: Int16
	var HL: Int16
	var SP: Int16
	var PC: Int16
}

extension Int16: Register {
	func high() -> Int8 {
		return self << 8
	}
	
	func low() -> Int8 {
		return 0
	}
}

struct CPU {
	var registers: Registers
}
