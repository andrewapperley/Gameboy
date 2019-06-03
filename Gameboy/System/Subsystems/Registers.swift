//
//  Registers.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-29.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

enum RegisterMap {
	enum single {
		case A
		case F
		case B
		case C
		case D
		case E
		case H
		case L
	}
	
	enum combined {
		case AF
		case BC
		case DE
		case HL
		case SP
	}
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
	
	private func mapRegister(register single: RegisterMap.single) -> UInt8 {
		switch single {
		case .A:
			return A
		case .F:
			return F
		case .B:
			return B
		case .C:
			return C
		case .D:
			return D
		case .E:
			return E
		case .H:
			return H
		case .L:
			return L
		}
	}
	
	private func mapRegister(register combined: RegisterMap.combined) -> UInt16 {
		switch combined {
		case .AF:
			return AF
		case .BC:
			return BC
		case .DE:
			return DE
		case .HL:
			return HL
		case .SP:
			return SP
		}
	}
	
	private func load(ls: inout UInt8, rs: UInt8) {
		ls = rs
	}
	
	private func load(ls: inout UInt16, rs: UInt16) {
		ls = rs
	}
	
	private func load(ls: inout UInt8, rs: UInt16) {
		ls = UInt8(rs)
	}
	
	private func load(ls: inout UInt16, rs: UInt8) {
		ls = UInt16(rs)
	}
	
	func load(register: RegisterMap.single, with value: UInt8) {
		var mappedRegister = mapRegister(register: register)
		load(ls: &mappedRegister, rs: value)
	}
	
	func load(register: RegisterMap.single, with value: RegisterMap.single) {
		var r1 = mapRegister(register: register)
		let r2 = mapRegister(register: value)
		load(ls: &r1, rs: r2)
	}
	
	func load(register: RegisterMap.single, with value: RegisterMap.combined) {
		var r1 = mapRegister(register: register)
		let r2 = mapRegister(register: value)
		load(ls: &r1, rs: r2)
	}
	
	func load(register: RegisterMap.combined, with value: UInt16) {
		var mappedRegister = mapRegister(register: register)
		load(ls: &mappedRegister, rs: value)
	}
	
	func load(register: RegisterMap.combined, with value: RegisterMap.combined) {
		var r1 = mapRegister(register: register)
		let r2 = mapRegister(register: value)
		load(ls: &r1, rs: r2)
	}
	
	func load(register: RegisterMap.combined, with value: RegisterMap.single) {
		var r1 = mapRegister(register: register)
		let r2 = mapRegister(register: value)
		load(ls: &r1, rs: r2)
	}
}
