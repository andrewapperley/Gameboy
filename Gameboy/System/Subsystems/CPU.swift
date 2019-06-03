//
//  CPU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

class CPU {
	var registers: Registers = Registers()
	var memory: MMU = MMU()
	
	func start() {
		reset()
		guard
			let boot = readBootROM(),
			let rom = readROM(name: "game") else { return }

		memory.loadBios(Array<UInt8>(boot))
		memory.write(address: MemoryMap.ROM_0.lowerBound, data: Array<UInt8>(rom))
	}
	
	func readBootROM() -> Data? {
		return readFile(name: "dmg_boot", ext: "bin")
	}
	
	func readROM(name: String) -> Data? {
		return readFile(name: name, ext: "gb")
	}
	
	private func readFile(name: String, ext: String) -> Data? {
		guard
			let path = Bundle.main.path(forResource: name, ofType: ext),
			let data = FileManager().contents(atPath: path)
			else {
				return nil
		}
		return data
	}
	
	private func reset() {
		registers.reset()
		memory.reset()
	}
}

extension CPU: Load {
	func LD_nn_n(nn: UInt8, n: inout UInt8) {
		n = nn
	}
	
	func LD(r1: inout UInt8, r2: UInt8) {
		r1 = r2
	}
	
	func LD(r1: inout UInt8, r2: UInt16) {
		r1 = UInt8(r2)
	}
	
	func LD(r1: inout UInt16, r2: UInt8) {
		r1 = UInt16(r2)
	}
	
	func LD_A_n(n: UInt8) {
		registers.A = n
	}
	
	func LD_A_n(n: UInt16) {
		registers.A = UInt8(n)
	}
	
	func LD_n_A(n: inout UInt8) {
		n = registers.A
	}
	
	func LD_n_A(n: inout UInt16) {
		n = UInt16(registers.A)
	}
	
	func LD_A_C() {
		registers.A = memory.read(address: 0xFF00) + registers.C
	}
	
	func LD_C_A() {
		memory.write(address: 0xFF00 + UInt16(registers.C), data: registers.A)
	}
	
	func LDD_A_HL() {
		registers.A = memory.read(address: registers.HL)
		registers.HL -= 1
	}
	
	func LDD_HL_A() {
		memory.write(address: registers.HL, data: registers.A)
		registers.HL -= 1
	}
	
	func LDI_A_HL() {
		registers.A = memory.read(address: registers.HL)
		registers.HL += 1
	}
	
	func LDI_HL_A() {
		memory.write(address: registers.HL, data: registers.A)
		registers.HL += 1
	}
	
	func LDH_n_A(n: UInt8) {
		memory.write(address: 0xFF00 + UInt16(n), data: registers.A)
	}
	
	func LDH_A_n(n: UInt8) {
		registers.A = UInt8(0xFF00 + UInt16(n))
	}
	
	func LD_n_nn(n: RegisterMap, nn: UInt16) {
		switch n {
			case .BC:
				registers.BC = nn
				break
			case .DE:
				registers.DE = nn
				break
			case .HL:
				registers.HL = nn
				break
			case .SP:
				registers.SP = nn
				break
			default: break
		}
	}
	
	func LD_SP_HL() {
		
	}
	
	func LDHL_SP_n(n: Int8) {
		
	}
	
	func LD_nn_SP(nn: UInt16) {
		
	}
	
	func PUSH_nn(nn: UInt16) {
		
	}
	
	func POP_nn(nn: UInt16) {
		
	}
}

extension CPU: ALU {
	func ADD_A_n(n: UInt8) {
		
	}
	
	func ADDC_A_n(n: UInt8) {
		
	}
	
	func SUB_n(n: UInt8) {
		
	}
	
	func SBC_A_n(n: UInt8) {
		
	}
	
	func AND_n(n: UInt8) {
		
	}
	
	func OR_n(n: UInt8) {
		
	}
	
	func XOR_n(n: UInt8) {
		
	}
	
	func CP_n(n: UInt8) {
		
	}
	
	func INC_n(n: UInt8) {
		
	}
	
	func DEC_n(n: UInt8) {
		
	}
}
