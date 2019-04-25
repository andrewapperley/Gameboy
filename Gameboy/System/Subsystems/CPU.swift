//
//  CPU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

struct Registers {
	var A: UInt8 = 0x0
	var F: UInt8 = 0x0
	var B: UInt8 = 0x0
	var C: UInt8 = 0x0
	var D: UInt8 = 0x0
	var E: UInt8 = 0x0
	var H: UInt8 = 0x0
	var L: UInt8 = 0x0
	var SP: UInt16 = 0x0
	var PC: UInt16 = 0x0
	
	var AF: UInt16 { return UInt16((A << 8) | F) }
	var BC: UInt16 { return UInt16((B << 8) | C) }
	var DE: UInt16 { return UInt16((D << 8) | E) }
	var HL: UInt16 { return UInt16((H << 8) | L) }
}

class CPU {
	var registers: Registers = Registers()
	
	private func reset() {
		registers = Registers()
	}
}
