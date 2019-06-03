//
//  Registers.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-29.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

enum RegisterMap {
	case A
	case F
	case B
	case C
	case D
	case E
	case H
	case L
	
	case AF
	case BC
	case DE
	case HL
	case SP
}

class Registers {
	var A: UInt8 = 0x0
	var F: UInt8 = 0x0
	var B: UInt8 = 0x0
	var C: UInt8 = 0x0
	var D: UInt8 = 0x0
	var E: UInt8 = 0x0
	var H: UInt8 = 0x0
	var L: UInt8 = 0x0
	var SP: UInt16 = 0xFFFE
	var PC: UInt16 = 0x0100
	
	var AF: UInt16 {
		get {
			return UInt16((A << 8) | F)
		}
		set {
			
		}
	}
	var BC: UInt16 {
		get {
			return UInt16((B << 8) | C)
		}
		set {
			
		}
	}
	var DE: UInt16 {
		get {
			return UInt16((D << 8) | E)
		}
		set {
			
		}
	}
	var HL: UInt16 {
		get {
			return UInt16((H << 8) | L)
		}
		set {
			
		}
	}
	
	func reset() {
		A = 0x0
		B = 0x0
		C = 0x0
		D = 0x0
		E = 0x0
		H = 0x0
		L = 0x0
		SP = 0xFFFE
		PC = 0x0100
	}
}
