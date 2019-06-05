//
//  CPU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

class CPU {
	private var registers: Registers = Registers()
	private var memory: MMU = MMU()
	private var clock: CPUTimer = CPUTimer()
	
	func start(cartridge: Cartridge) {
		reset()
		guard let boot = FileSystem.readBootROM() else { return }

		memory.loadBios(Array<UInt8>(boot))
		memory.write(address: MemoryMap.ROM_0.lowerBound, data: Array<UInt8>(cartridge.rom))
		run()
	}
	
	private var running = false // This needs to be determined by reading the Registers
	
	private func run() {
		running = true
		var count = 0
		while(running && count < 500) {
			// fetch OPCode
			let code = memory.read(address: registers.PC)
			// fetch and execute instruction
			fetchAndInvokeInstruction(with: code)
			// check for I/O ?
			// render
			count += 1
		}
	}
	
	private func reset() {
		registers.reset()
		memory.reset()
	}
}

extension CPU: InstructionInvoker {
	func fetchAndInvokeInstruction(with code: UInt8) {
		print("Calling OPCode:: \(String(format:"%02X", code))")
		switch code {
//			Misc
		case 0x0:
			self.NOP()
//			8-bit Loads
		case 0x06:
			self.LD_nn_n(nn: 0, n: .B)
		case 0x0E:
			self.LD_nn_n(nn: 0, n: .C)
		case 0x16:
			self.LD_nn_n(nn: 0, n: .D)
		case 0x1E:
			self.LD_nn_n(nn: 0, n: .E)
		case 0x26:
			self.LD_nn_n(nn: 0, n: .H)
		case 0x2E:
			self.LD_nn_n(nn: 0, n: .L)
		case 0x60:
			self.LD(r1: .H, r2: .B)
//			16-bit Loads
		case 0x21:
			let param = memory.readByte(address: registers.PC+1)
			self.LD_n_nn(n: .HL, nn: param)
//			Jumps
		case 0xC3:
			let param = memory.readByte(address: registers.PC+1)
			self.JP_nn(nn: param)
//		ALU
		case 0xAF:
			self.XOR_n(n: .A)
//			Restarts
		case 0xFF:
			self.RST_n(n: 0x38)
		default:
			print("OPCode not implemented yet:: \(String(format:"%02X", code))")
		}
	}
}

extension CPU: Misc {
	func NOP() {
		registers.PC += 1
	}
}

extension CPU: Load {
	func LD_nn_n(nn: UInt8, n: RegisterMap.single) {
		registers.load(register: n, with: nn)
		registers.PC += 1
	}
	
	func LD(r1: RegisterMap.single, r2: RegisterMap.single) {
		registers.load(register: r1, with: r2)
		registers.PC += 1
	}
	
	func LD(r1: RegisterMap.single, r2: RegisterMap.combined) {
		registers.load(register: r1, with: r2)
		registers.PC += 1
	}
	
	func LD(r1: RegisterMap.combined, r2: RegisterMap.single) {
		registers.load(register: r1, with: r2)
		registers.PC += 1
	}
	
	func LD_A_n(n: UInt8) {
		registers.A = n
		registers.PC += 1
	}
	
	func LD_A_n(nn: UInt16) {
		registers.A = UInt8(nn)
		registers.PC += 1
	}
	
	func LD_n_A(n: RegisterMap.single) {
		registers.load(register: n, with: .A)
		registers.PC += 1
	}
	
	func LD_n_A(n: inout UInt16) {
		n = UInt16(registers.A)
		registers.PC += 1
	}
	
	func LD_A_C() {
		registers.A = memory.read(address: 0xFF00) + registers.C
		registers.PC += 1
	}
	
	func LD_C_A() {
		memory.write(address: 0xFF00 + UInt16(registers.C), data: registers.A)
		registers.PC += 1
	}
	
	func LDD_A_HL() {
		registers.A = memory.read(address: registers.HL)
		registers.HL -= 1
		registers.PC += 1
	}
	
	func LDD_HL_A() {
		memory.write(address: registers.HL, data: registers.A)
		registers.HL -= 1
		registers.PC += 1
	}
	
	func LDI_A_HL() {
		registers.A = memory.read(address: registers.HL)
		registers.HL += 1
		registers.PC += 1
	}
	
	func LDI_HL_A() {
		memory.write(address: registers.HL, data: registers.A)
		registers.HL += 1
		registers.PC += 1
	}
	
	func LDH_n_A(n: UInt8) {
		memory.write(address: 0xFF00 + UInt16(n), data: registers.A)
		registers.PC += 1
	}
	
	func LDH_A_n(n: UInt8) {
		registers.load(register: .A, with: UInt8(0xFF00 + UInt16(n)))
		registers.PC += 1
	}
	
	func LD_n_nn(n: RegisterMap.combined, nn: UInt16) {
		registers.load(register: n, with: nn)
		registers.PC += 1
	}
	
	func LD_SP_HL() {
		registers.load(register: .SP, with: .HL)
		registers.PC += 1
	}
	
	func LDHL_SP_n(n: Int8) {
		registers.HL = (registers.SP + UInt16(n))
		// Flags affected
		registers.PC += 1
	}
	
	func LD_nn_SP(nn: UInt16) {
		registers.SP = nn
		registers.PC += 1
	}
	
	func PUSH_nn(nn: UInt16) {
		registers.SP -= 2
		memory.write(address: registers.SP, data: nn)
		registers.PC += 1
	}
	
	func POP_nn(nn: RegisterMap.combined) {
		let n = memory.readByte(address: registers.SP)
		registers.load(register: nn, with: n)
		registers.SP += 2
		registers.PC += 1
	}
}

extension CPU: ALU { //	Flags affected
	func ADD_A_n(n: RegisterMap.single) {
		registers.A += registers.mapRegister(register: n).pointee
		registers.PC += 1
	}
	
	func ADD_A_n(n: RegisterMap.combined) {
		registers.A += UInt8(registers.mapRegister(register: n).pointee)
		registers.PC += 1
	}
	
	func ADDC_A_n(n: RegisterMap.single) {
		registers.PC += 1
	}
	
	func SUB_n(n: RegisterMap.single) {
		registers.A -= registers.mapRegister(register: n).pointee
		registers.PC += 1
	}
	
	func SUB_n(n: RegisterMap.combined) {
		registers.A -= UInt8(registers.mapRegister(register: n).pointee)
		registers.PC += 1
	}
	
	func SBC_A_n(n: RegisterMap.single) {
		registers.PC += 1
	}
	
	func AND_n(n: RegisterMap.single) {
		registers.A &= registers.mapRegister(register: n).pointee
		registers.PC += 1
	}
	
	func AND_n(n: RegisterMap.combined) {
		registers.A &= UInt8(registers.mapRegister(register: n).pointee)
		registers.PC += 1
	}
	
	func OR_n(n: RegisterMap.single) {
		registers.A |= registers.mapRegister(register: n).pointee
		registers.PC += 1
	}
	
	func OR_n(n: RegisterMap.combined) {
		registers.A |= UInt8(registers.mapRegister(register: n).pointee)
		registers.PC += 1
	}
	
	func XOR_n(n: RegisterMap.single) {
		registers.A ^= registers.mapRegister(register: n).pointee
		registers.PC += 1
	}
	
	func XOR_n(n: RegisterMap.combined) {
		registers.A ^= UInt8(registers.mapRegister(register: n).pointee)
		registers.PC += 1
	}
	
	func CP_n(n: RegisterMap.single) {
		let res = registers.A - registers.mapRegister(register: n).pointee
		if res == 0 {
			
		} // Other flag conditions
		registers.PC += 1
	}
	
	func CP_n(n: RegisterMap.combined) {
		let res = registers.A - UInt8(registers.mapRegister(register: n).pointee)
		if res == 0 {
			
		} // Other flag conditions
		registers.PC += 1
	}
	
	func INC_n(n: RegisterMap.single) {
		let current = registers.mapRegister(register: n).pointee
		var new = current + 1
		if new >= UInt8.max {
			new = 0
		}
		// flags affected
		registers.load(register: n, with: UInt8(new))
		registers.PC += 1
	}
	
	func INC_n(n: RegisterMap.combined) {
		let current = registers.mapRegister(register: n).pointee
		var new = current + 1
		if new >= UInt16.max {
			new = 0
		}
		// flags affected
		registers.load(register: n, with: UInt16(new))
		registers.PC += 1
	}
	
	func DEC_n(n: RegisterMap.single) {
		let current = registers.mapRegister(register: n).pointee
		var new = current - 1
		if new <= 0 {
			new = 0
		}
		// flags affected
		registers.load(register: n, with: UInt8(new))
		registers.PC += 1
	}
	
	func DEC_n(n: RegisterMap.combined) {
		let current = registers.mapRegister(register: n).pointee
		var new = current - 1
		if new <= 0 {
			new = 0
		}
		// flags affected
		registers.load(register: n, with: UInt16(new))
		registers.PC += 1
	}
}

extension CPU: Jumps {
	func JP_nn(nn: UInt16) {
		registers.PC = nn
	}
}

extension CPU: Restarts {
	func RST_n(n: UInt8) {
		self.PUSH_nn(nn: registers.PC)
		registers.PC = UInt16(0x0000 + n)
	}
}
