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
	var PC: UInt16 = 0x0
	
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
		PC = 0x0
	}
}

protocol RegisterLoading {
	func mapRegister(register single: RegisterMap.single) -> UnsafeMutablePointer<UInt8>
	func mapRegister(register combined: RegisterMap.combined) -> UnsafeMutablePointer<UInt16>
	
	func load(ls: UnsafeMutablePointer<UInt8>, rs: UInt8)
	func load(ls: UnsafeMutablePointer<UInt16>, rs: UInt16)
	func load(ls: UnsafeMutablePointer<UInt8>, rs: UInt16)
	func load(ls: UnsafeMutablePointer<UInt16>, rs: UInt8)
	
	func load(register: RegisterMap.single, with value: UInt8)
	func load(register: RegisterMap.single, with value: RegisterMap.single)
	func load(register: RegisterMap.single, with value: RegisterMap.combined)
	func load(register: RegisterMap.combined, with value: UInt16)
	func load(register: RegisterMap.combined, with value: RegisterMap.combined)
	func load(register: RegisterMap.combined, with value: RegisterMap.single)
}

extension Registers: RegisterLoading {
	
	func mapRegister(register single: RegisterMap.single) -> UnsafeMutablePointer<UInt8> {
		switch single {
		case .A:
			return UnsafeMutablePointer<UInt8>(&A)
		case .F:
			return UnsafeMutablePointer<UInt8>(&F)
		case .B:
			return UnsafeMutablePointer<UInt8>(&B)
		case .C:
			return UnsafeMutablePointer<UInt8>(&C)
		case .D:
			return UnsafeMutablePointer<UInt8>(&D)
		case .E:
			return UnsafeMutablePointer<UInt8>(&E)
		case .H:
			return UnsafeMutablePointer<UInt8>(&H)
		case .L:
			return UnsafeMutablePointer<UInt8>(&L)
		}
	}
	
	func mapRegister(register combined: RegisterMap.combined) -> UnsafeMutablePointer<UInt16> {
		switch combined {
		case .AF:
			return UnsafeMutablePointer<UInt16>(&AF)
		case .BC:
			return UnsafeMutablePointer<UInt16>(&BC)
		case .DE:
			return UnsafeMutablePointer<UInt16>(&AF)
		case .HL:
			return UnsafeMutablePointer<UInt16>(&AF)
		case .SP:
			return UnsafeMutablePointer<UInt16>(&AF)
		}
	}
	
	internal func load(ls: UnsafeMutablePointer<UInt8>, rs: UInt8) {
		ls.pointee = rs
	}
	
	internal func load(ls: UnsafeMutablePointer<UInt16>, rs: UInt16) {
		ls.pointee = rs
	}
	
	internal func load(ls: UnsafeMutablePointer<UInt8>, rs: UInt16) {
		ls.pointee = UInt8(rs)
	}
	
	internal func load(ls: UnsafeMutablePointer<UInt16>, rs: UInt8) {
		ls.pointee = UInt16(rs)
	}
	
	func load(register: RegisterMap.single, with value: UInt8) {
		load(ls: mapRegister(register: register), rs: value)
	}
	
	func load(register: RegisterMap.single, with value: RegisterMap.single) {
		load(ls: mapRegister(register: register), rs: mapRegister(register: value).pointee)
	}
	
	func load(register: RegisterMap.single, with value: RegisterMap.combined) {
		load(ls: mapRegister(register: register), rs: mapRegister(register: value).pointee)
	}
	
	func load(register: RegisterMap.combined, with value: UInt16) {
		load(ls: mapRegister(register: register), rs: value)
	}
	
	func load(register: RegisterMap.combined, with value: RegisterMap.combined) {
		load(ls: mapRegister(register: register), rs: mapRegister(register: value).pointee)
	}
	
	func load(register: RegisterMap.combined, with value: RegisterMap.single) {
		load(ls: mapRegister(register: register), rs: mapRegister(register: value).pointee)
	}
}
