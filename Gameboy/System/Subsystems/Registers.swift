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

enum Flag: Int {
	case Z = 7 // Zero Flag
	case N = 6 // Subtract Flag
	case H = 5 // Half Carry Flag
	case C = 4 // Carry Flag
}

class Registers {
	static let Zero: UInt8 = 0x80
    static let Negative: UInt8 = 0x40
    static let HalfCarry: UInt8 = 0x20
    static let Carry: UInt8 = 0x10
	
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
	
	func getFlag(_ flag: Flag) -> Int {
		return self.F.bit(at: flag.rawValue)
	}
	
	func getFlagState(_ flag: Flag) -> Bool {
		return self.F.isSet(flag.rawValue)
	}

	func setFlag(_ flag: Flag, state: Bool) {
		self.F.setBit(at: flag.rawValue, to: state ? 1 : 0)
	}
	
	func clearFlags() {
		setFlag(.Z, state: false)
		setFlag(.N, state: false)
		setFlag(.H, state: false)
		setFlag(.C, state: false)
	}
	
	var AF: UInt16 {
		get {
			return UInt16(A) << 8 | UInt16(F)
		}
		set {
			A = UInt8(newValue >> 8)
			F = UInt8(newValue & 0xFF)
		}
	}
	var BC: UInt16 {
		get {
			return UInt16(B) << 8 | UInt16(C)
		}
		set {
			B = UInt8(newValue >> 8)
			C = UInt8(newValue & 0xFF)
		}
	}
	var DE: UInt16 {
		get {
			return UInt16(D) << 8 | UInt16(E)
		}
		set {
			D = UInt8(newValue >> 8)
			E = UInt8(newValue & 0xFF)
		}
	}
	var HL: UInt16 {
		get {
			return UInt16(H) << 8 | UInt16(L)
		}
		set {
			H = UInt8(newValue >> 8)
			L = UInt8(newValue & 0xFF)
		}
	}
	
	func setInitial() {
		AF = 0x01B0
		BC = 0x0013
		DE = 0x00D8
		HL = 0x014D
		SP = 0xFFFE
		PC = 0x100
	}
	
	func reset() {
		A = 0x0
		F = 0x0
		B = 0x0
		C = 0x0
		D = 0x0
		E = 0x0
		H = 0x0
		L = 0x0
		SP = 0x0
		PC = 0x0
		setInitial()
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
			return UnsafeMutablePointer<UInt16>(&DE)
		case .HL:
			return UnsafeMutablePointer<UInt16>(&HL)
		case .SP:
			return UnsafeMutablePointer<UInt16>(&SP)
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
		switch register {
		case .A:
			A = value
		case .B:
			B = value
		case .C:
			C = value
		case .D:
			D = value
		case .E:
			E = value
		case .F:
			F = value
		case .H:
			H = value
		case .L:
			L = value
		}
	}
	
	func load(register: RegisterMap.single, with value: RegisterMap.single) {
		load(register: register, with: mapRegister(register: value).pointee)
	}
	
	func load(register: RegisterMap.single, with value: RegisterMap.combined) {
		load(register: register, with: UInt8(mapRegister(register: value).pointee))
	}
	
	func load(register: RegisterMap.combined, with value: UInt16) {
		switch register {
			case .AF:
				AF = value
			case .BC:
				BC = value
			case .DE:
				DE = value
			case .HL:
				HL = value
			case .SP:
				SP = value
		}
	}
	
	func load(register: RegisterMap.combined, with value: RegisterMap.combined) {
		load(register: register, with: mapRegister(register: value).pointee)
	}
	
	func load(register: RegisterMap.combined, with value: RegisterMap.single) {
		load(register: register, with: UInt16(mapRegister(register: value).pointee))
	}
	
	func toState() -> StateRegisters {
		return StateRegisters(A: A, F: F, B: B, C: C, D: D, E: E, H: H, L: L, SP: SP, PC: PC, flags: StateFlags(Z: getFlag(.Z), N: getFlag(.N), H: getFlag(.H), C: getFlag(.C)))
	}
}
