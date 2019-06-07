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
		while(running && count < 244) {
			// fetch OPCode
			let code = memory.readHalf(address: registers.PC)
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
		case 0x00:
			self.NOP()
//			8-bit Loads
		case 0x06:
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(nn: param, n: .B)
		case 0x0E:
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(nn: param, n: .C)
		case 0x16:
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(nn: param, n: .D)
		case 0x1A:
			self.LD_n_A(n: registers.DE)
		case 0x1E:
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(nn: param, n: .E)
		case 0x22:
			self.LDI_A_HL()
		case 0x26:
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(nn: param, n: .H)
		case 0x2E:
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(nn: param, n: .L)
		case 0x47:
			self.LD(r1: .B, r2: .A)
		case 0x4F:
			self.LD(r1: .C, r2: .A)
		case 0x57:
			self.LD(r1: .D, r2: .A)
		case 0x5F:
			self.LD(r1: .E, r2: .A)
		case 0x60:
			self.LD(r1: .H, r2: .B)
		case 0x67:
			self.LD(r1: .H, r2: .A)
		case 0x6F:
			self.LD(r1: .L, r2: .A)
		case 0x7F:
			self.LD(r1: .A, r2: .A)
		case 0x02:
			self.LD_n_A(n: registers.BC)
		case 0x12:
			self.LD_n_A(n: registers.DE)
		case 0x77:
			self.LD_n_A(n: registers.HL)
		case 0xEA:
			let param = memory.readFull(address: registers.PC+1)
			self.LD_n_A(n: param)
		case 0xF0:
			let param = memory.readHalf(address: registers.PC+1)
			self.LDH_A_n(n: param)
//			16-bit Loads
		case 0x08:
			let param = memory.readFull(address: registers.PC+1)
			self.LD_nn_SP(nn: param)
		case 0x21:
			let param = memory.readFull(address: registers.PC+1)
			self.LD_n_nn(n: .HL, nn: param)
		case 0x31:
			let param = memory.readFull(address: registers.PC+1)
			self.LD_n_nn(n: .SP, nn: param)
		case 0xF9:
			self.LD_SP_HL()
//			Jumps
		case 0xC3:
			let param = memory.readFull(address: registers.PC+1)
			self.JP_nn(nn: param)
		case 0x20:
			let param = memory.readHalf(address: registers.PC+1)
			self.JR_cc_n(flag: .Z, n: param)
//			ALU
		case 0xAF:
			self.XOR_n(n: .A)
		case 0x3C:
			self.INC_n(n: .A)
		case 0x03:
			self.INC_n(n: .BC)
		case 0x04:
			self.INC_n(n: .B)
		case 0x0C:
			self.INC_n(n: .C)
		case 0x13:
			self.INC_n(n: .DE)
		case 0x14:
			self.INC_n(n: .D)
		case 0x1C:
			self.INC_n(n: .E)
		case 0x23:
			self.INC_n(n: .HL)
		case 0x24:
			self.INC_n(n: .H)
		case 0x2C:
			self.INC_n(n: .L)
		case 0x33:
			self.INC_n(n: .SP)
		case 0x34:
			self.INC_n(n: .HL)
		case 0x3D:
			self.DEC_n(n: .A)
		case 0x05:
			self.DEC_n(n: .B)
		case 0x0D:
			self.DEC_n(n: .C)
		case 0x15:
			self.DEC_n(n: .D)
		case 0x1D:
			self.DEC_n(n: .E)
		case 0x25:
			self.DEC_n(n: .H)
		case 0x2D:
			self.DEC_n(n: .L)
		case 0x35:
			self.DEC_n(n: .HL)
		case 0xFE:
//			What does # mean? CP_n()
			registers.PC += 1
//			Restarts
		case 0xFF:
			self.RST_n(n: 0x38)
		default:
			print("OPCode not implemented yet:: \(String(format:"%02X", code))")
			self.NOP()
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
	
	func LD_n_A(n: UInt16) {
		memory.write(address: n, data: registers.A)
		registers.PC += 1
	}
	
	func LD_A_C() {
		registers.A = memory.readHalf(address: 0xFF00) + registers.C
		registers.PC += 1
	}
	
	func LD_C_A() {
		memory.write(address: 0xFF00 + UInt16(registers.C), data: registers.A)
		registers.PC += 1
	}
	
	func LDD_A_HL() {
		registers.A = memory.readHalf(address: registers.HL)
		registers.HL -= 1
		registers.PC += 1
	}
	
	func LDD_HL_A() {
		memory.write(address: registers.HL, data: registers.A)
		registers.HL -= 1
		registers.PC += 1
	}
	
	func LDI_A_HL() {
		registers.A = memory.readHalf(address: registers.HL)
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
		let data = memory.readHalf(address: 0xFF00 + UInt16(n))
		registers.load(register: .A, with: data)
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
		let n = memory.readFull(address: registers.SP)
		registers.load(register: nn, with: n)
		registers.SP += 2
		registers.PC += 1
	}
}

extension CPU: ALU { //	Flags affected
	
//	8-bit ALU
	
	func ADD_A_n(n: RegisterMap.single) {
		registers.A += registers.mapRegister(register: n).pointee
		registers.PC += 1
	}
	
	func ADDC_A_n(n: RegisterMap.single) {
		registers.PC += 1
	}
	
	func SUB_n(n: RegisterMap.single) {
		registers.A -= registers.mapRegister(register: n).pointee
		registers.PC += 1
	}
	
	func SBC_A_n(n: RegisterMap.single) {
		registers.PC += 1
	}
	
	func AND_n(n: RegisterMap.single) {
		registers.A &= registers.mapRegister(register: n).pointee
		registers.PC += 1
	}
	
	func OR_n(n: RegisterMap.single) {
		registers.A |= registers.mapRegister(register: n).pointee
		registers.PC += 1
	}
	
	func XOR_n(n: RegisterMap.single) {
		registers.A ^= registers.mapRegister(register: n).pointee
		registers.PC += 1
	}
	
	func CP_n(n: RegisterMap.single) {
		let nValue = registers.mapRegister(register: n).pointee
		let res = registers.A - nValue
		
		if res == 0 {
			registers.setFlag(.Z, state: true)
		}
		registers.setFlag(.N, state: true)
//		H - Set if no borrow from bit 4. NEED TO FIGURE OUT HOW TO DETECT BORROWING
		if registers.A < nValue {
			registers.setFlag(.C, state: true)
		}

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
	
	func DEC_n(n: RegisterMap.single) {
		let current = registers.mapRegister(register: n).pointee
		
		if current != 0 {
			let new: UInt8 = UInt8(current - 1)
			// flags affected
			registers.load(register: n, with: new)
		}
		
		registers.PC += 1
	}
	
//	16-bit ALU
	
	func ADD_A_n(n: RegisterMap.combined) {
		registers.A += UInt8(registers.mapRegister(register: n).pointee)
		registers.PC += 1
	}
	
	func SUB_n(n: RegisterMap.combined) {
		registers.A -= UInt8(registers.mapRegister(register: n).pointee)
		registers.PC += 1
	}
	
	func AND_n(n: RegisterMap.combined) {
		registers.A &= UInt8(registers.mapRegister(register: n).pointee)
		registers.PC += 1
	}
	
	func OR_n(n: RegisterMap.combined) {
		registers.A |= UInt8(registers.mapRegister(register: n).pointee)
		registers.PC += 1
	}
	
	func XOR_n(n: RegisterMap.combined) {
		registers.A ^= UInt8(registers.mapRegister(register: n).pointee)
		registers.PC += 1
	}
	
	func CP_n(n: RegisterMap.combined) {
		let res = registers.A - UInt8(registers.mapRegister(register: n).pointee)
		if res == 0 {
			
		} // Other flag conditions
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
	
	func JR_cc_n(flag: Flag, n: UInt8) { // Need to explore other docs about this command
		var address = registers.PC
		if registers.getFlag(flag) {
			address += UInt16(n)
			registers.PC = address
		} else {
			registers.PC += 1
		}
	}
}

extension CPU: Restarts {
	func RST_n(n: UInt8) {
		self.PUSH_nn(nn: registers.PC)
		registers.PC = UInt16(0x0000 + n)
	}
}
