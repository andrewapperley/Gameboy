//
//  CPU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

protocol CPUDelegate {
	func onCompletedFrame()
}

class CPU {
	private static let instructionTable: Instructions.InstructionLookupTable = Instructions.generateInstructionLookupTable()
	private static let innerInstructionTable: Instructions.InnerInstructionLookupTable = Instructions.generateInnerInstructionLookupTable()
	private(set) var registers: Registers = Registers()
	private(set) var memory: MMU
	let clock: CPUTimer
	private(set) var running = false
	var cpuDelegate: CPUDelegate?
	
	init(memory: MMU) {
		self.memory = memory
		clock = CPUTimer(memory)
	}
	
	func pause() -> CPUState {
		running = false
		return CPUState(registers: registers.toState(), memory: memory.toState())
	}
	
	func resume() {
		running = true
	}
	
	func stop() {
		running = false
	}
	
	func start() {
//		Maybe I need to do more initialization here?
		self.running = true
	}
	
	fileprivate func updatePC(_ pc: UInt16) {
		registers.PC += pc
	}
	
	func tick() {
		guard running else { return }
		// fetch OPCode
		let code = memory.readHalf(address: registers.PC)
		// fetch and execute instruction
		fetchAndInvokeInstruction(with: code)
		// check for I/O ?
		// call debugger with latest frame information
		self.cpuDelegate?.onCompletedFrame()
	}
	
	func reset() {
		registers.reset()
	}
}

// MARK: Instruction Invoker
extension CPU: InstructionInvoker {
	func fetchAndInvokeInstruction(with code: UInt8) {
		print("Current PC is:: 0x\(String(registers.PC, radix: 16, uppercase: true))")
		
		let context = self.context(from: code)
		self.opCodeFetchPrint(code: context.code)
		
		guard let data = context.table[context.code] else {
			self.opCodeNotImplementedPrint(code: context.code)
			return
		}
		let instruction = data.2
		instruction(self, context.code)
		if data.pc > 0 {
			self.updatePC(data.pc)
		}
		if data.cycles > 0 {
			self.clock.updateClock(data.cycles)
		}
	}
	
	private func context(from code: UInt8) -> (code: UInt8, table: Instructions.InnerInstructionLookupTable) {
		if code == 0xCB {
			return (code: self.memory.readHalf(address: self.registers.PC+1), table: CPU.innerInstructionTable)
		} else {
			return (code: code, table: CPU.instructionTable)
		}
	}
}
// MARK: Misc
extension CPU: Misc {
	func NOP() {
	}
	
	func STOP() {
//		Halt CPU & LCD display until button pressed.
	}
	
	func CPL() {
		registers.clearFlags(notAffacted: [.Z, .C])
		registers.setFlag(.N, state: true)
		registers.setFlag(.H, state: true)
		registers.A ^= UInt8(UINT8_MAX)
	}
	
	func DI() {
//		This instruction disables interrupts but not immediately. Interrupts are disabled after instruction after DI is executed.
	}
}
// MARK: Load
extension CPU: Load {
//	8-bit Loads
	func LD_nn_n(n: UInt8, nn: RegisterMap.single) {
		registers.load(register: nn, with: n)
	}
	
	func LD(r1: RegisterMap.single, r2: RegisterMap.single) {
		registers.load(register: r1, with: r2)
	}
	
	func LDHL(r1: RegisterMap.single) {
		registers.load(register: r1, with: memory.readHalf(address: registers.HL))
	}
	
	func LDHL(r2: UInt8) {
		memory.write(address: registers.HL, data: r2)
	}
	
	func LDHL(n: UInt8) {
		memory.write(address: registers.HL, data: n)
	}
	
	func LD_A_n(n: RegisterMap.single) {
		registers.load(register: .A, with: n)
	}
	
	func LD_A_r(r: UInt8) {
		registers.load(register: .A, with: r)
	}
	
	func LD_A_n(n: UInt8) {
		registers.load(register: .A, with: n)
	}
	
	func LD_A_n(nn: UInt8) {
		registers.load(register: .A, with: nn)
	}
	
	func LD_n_A(n: RegisterMap.single) {
		registers.load(register: n, with: .A)
	}
	
	func LD_n_A(n: UInt16) {
		memory.write(address: n, data: registers.A)
	}
	
	func LD_C_A() {
		registers.A = memory.readHalf(address: 0xFF00 | UInt16(registers.C))
	}
	
	func LD_A_C() {
		memory.write(address: (0xFF00 | UInt16(registers.C)), data: registers.A)
	}
	
	func LDD_A_HL() {
		registers.A = memory.readHalf(address: registers.HL)
		registers.HL = registers.HL - 1
	}
	
	func LDD_HL_A() {
		memory.write(address: registers.HL, data: registers.A)
		registers.HL = registers.HL - 1
	}
	
	func LDI_A_HL() {
		registers.A = memory.readHalf(address: registers.HL)
		registers.HL = registers.HL + 1
	}
	
	func LDI_HL_A() {
		memory.write(address: registers.HL, data: registers.A)
		registers.HL = registers.HL + 1
	}
	
	func LDH_n_A(n: UInt8) {
		memory.write(address: 0xFF00 | UInt16(n), data: registers.A)
	}
	
	func LDH_A_n(n: UInt8) {
		let data = memory.readHalf(address: 0xFF00 | UInt16(n))
		registers.load(register: .A, with: data)
	}
//	16-bit Loads
	func LD_n_nn(n: RegisterMap.combined, nn: UInt16) {
		registers.load(register: n, with: nn)
	}
	
	func LD_SP_HL() {
		registers.load(register: .SP, with: .HL)
	}
	
	func LD_nn_SP(nn: UInt16) {
		registers.SP = nn
	}
	
	func PUSH_nn(nn: UInt16) {
		memory.write(address: registers.SP-2, data: nn)
		registers.SP -= 2
	}
	
	func POP_nn(nn: RegisterMap.combined) {
		let n = memory.readFull(address: registers.SP)
		registers.load(register: nn, with: n)
		registers.SP += 2
	}
}
// MARK: ALU
extension CPU: ALU {
//	8-bit ALU
	func ADD_A_n(n: UInt8) {
		registers.setFlag(.Z, state: registers.A &+ n == 0)
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: registers.A & 0x0F + n & 0x0F > 0x0F)
		registers.setFlag(.C, state: registers.A > registers.A &+ n)

		registers.A &+= n
	}
	
	func ADC_A_n(n: UInt8) {
		let c = UInt8(registers.getFlag(.C))
		registers.F = Registers.Negative
		
		registers.setFlag(.H, state: registers.A & 0x0F + n & 0x0F > 0x0F)
		registers.setFlag(.C, state: registers.A < registers.A &- n )
		registers.A &+= n
		
		registers.setFlag(.H, state: registers.A & 0x0F + c & 0x0F > 0x0F)
		registers.setFlag(.C, state: registers.A > registers.A &+ c)
		registers.setFlag(.Z, state: registers.A &+ c == 0)
		registers.A &+= c
	}
	
	func ADC_A_r(n: RegisterMap.single) {
		let n = registers.mapRegister(register: n).pointee
		let c = UInt8(registers.getFlag(.C))
		registers.F = Registers.Negative
		
		registers.setFlag(.H, state: registers.A & 0x0F + n & 0x0F > 0x0F)
		registers.setFlag(.C, state: registers.A < registers.A &- n)
		registers.A &+= n
		
		registers.setFlag(.H, state: registers.A & 0x0F + c & 0x0F > 0x0F )
		registers.setFlag(.C, state: registers.A > registers.A &+ c )
		registers.setFlag(.Z, state: registers.A &+ c == 0)
		registers.A &+= c
	}
	
	func ADC_A_HL() {
		let n = memory.readHalf(address: registers.HL)
		let c = UInt8(registers.getFlag(.C))
		registers.F = Registers.Negative
		
		registers.setFlag(.H, state: registers.A & 0x0F + n & 0x0F > 0x0F)
		registers.setFlag(.C, state: registers.A < registers.A &- n)
		registers.A &+= n
		
		registers.setFlag(.H, state: registers.A & 0x0F + c & 0x0F > 0x0F )
		registers.setFlag(.C, state: registers.A > registers.A &+ c)
		registers.setFlag(.Z, state: registers.A &+ c == 0)
		registers.A &+= c
	}
	
	func SUB_n(n: UInt8) {
		registers.F = Registers.Negative
		registers.setFlag(.H, state: registers.A & 0x0F < n & 0x0F )
		registers.setFlag(.C, state: registers.A < registers.A &- n)
		registers.setFlag(.Z, state: registers.A &- n == 0)
		
		registers.A &-= n
	}
	
	func SUB_n(n: RegisterMap.single) {
		let n = registers.mapRegister(register: n).pointee
		registers.F = Registers.Negative
		registers.setFlag(.H, state: registers.A & 0x0F < n & 0x0F )
		registers.setFlag(.C, state: registers.A < registers.A &- n)
		registers.setFlag(.Z, state: registers.A &- n == 0)
		
		registers.A &-= n
	}
	
	func SUB_HL() {
		let n = memory.readHalf(address: registers.HL)
		registers.F = Registers.Negative
		registers.setFlag(.H, state: registers.A & 0x0F < n & 0x0F )
		registers.setFlag(.C, state: registers.A < registers.A &- n)
		registers.setFlag(.Z, state: registers.A &- n == 0)
		
		registers.A &-= n
	}
	
	func SBC_A_n(n: UInt8) {
		let c = UInt8(registers.getFlag(.C))
		registers.F = Registers.Negative
		
		registers.setFlag(.H, state: registers.A & 0x0F < n & 0x0F)
		registers.setFlag(.C, state: registers.A < registers.A &- n)
		registers.A &-= n
		
		registers.setFlag(.H, state: registers.A & 0x0F < n & 0x0F)
		registers.setFlag(.C, state: registers.A < registers.A &- n)
		registers.setFlag(.Z, state: registers.A &- c == 0 )
		registers.A &-= c
	}
	
	func AND_n(n: UInt8) {
		registers.A &= n
//		Z - Set if result is zero.
		registers.setFlag(.Z, state: registers.A == 0)
//		N - Reset.
		registers.setFlag(.N, state: false)
//		H - Set.
		registers.setFlag(.H, state: true)
//		C - Reset.
		registers.setFlag(.C, state: false)
	}
	
	func OR_n(n: UInt8) {
		registers.A |= n
		//		Z - Set if result is zero.
		registers.setFlag(.Z, state: registers.A == 0)
		//		N - Reset.
		registers.setFlag(.N, state: false)
		//		H - Reset.
		registers.setFlag(.H, state: false)
		//		C - Reset.
		registers.setFlag(.C, state: false)
	}
	
	func XOR_n(n: UInt8) {
		registers.A ^= n
		//		Z - Set if result is zero.
		registers.setFlag(.Z, state: registers.A == 0)
		//		N - Reset.
		registers.setFlag(.N, state: false)
		//		H - Reset.
		registers.setFlag(.H, state: false)
		//		C - Reset.
		registers.setFlag(.C, state: false)
	}
	
	func CP_HL(n: UInt8) {
		let res: Int = Int(registers.A) - Int(n)
		
		registers.setFlag(.Z, state: res == 0)
		registers.setFlag(.N, state: true)
		registers.setFlag(.H, state: (registers.A & 0x0F) < (n & 0x0F))
		registers.setFlag(.C, state: registers.A < n)
	}
	
	func CP_n(n: UInt8) {
		let res = registers.A &- n
		
		registers.clearFlags()
		registers.setFlag(.Z, state: res == 0)
		registers.setFlag(.N, state: true)
		registers.setFlag(.H, state: (registers.A & 0x0F) < (n & 0x0F))
		registers.setFlag(.C, state: registers.A < res)
	}
	
	func INC_n(n: RegisterMap.single) {
		let current = registers.mapRegister(register: n).pointee
		let new: UInt8 = current &+ 1
		registers.clearFlags(notAffacted: [.C])
		registers.setFlag(.Z, state: new == 0)
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: new & 0x0F == 0x0F)
		registers.load(register: n, with: new)
	}
	
	func INC_HL() {
		let current = memory.readHalf(address: registers.HL)
		let new: UInt8 = current &+ 1
		registers.clearFlags(notAffacted: [.C])
		registers.setFlag(.Z, state: new == 0)
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: new & 0x0F == 0x0F)
		memory.write(address: registers.HL, data: new)
	}
	
	func DEC_n(n: RegisterMap.single) {
		let current = registers.mapRegister(register: n).pointee
		let new: UInt8 = current &- 1
		
		registers.clearFlags(notAffacted: [.C])
		
 		registers.setFlag(.N, state: true)
		if current == 0x01 { registers.setFlag(.Z, state: true) }
		if current & 0x0F == 0 { registers.setFlag(.H, state: true) }
		
		registers.load(register: n, with: new)
	}
	
	func DEC_HL() {
		let current = memory.readHalf(address: registers.HL)
		let new: UInt8 = current &- 1
		
		registers.clearFlags(notAffacted: [.C])
		registers.setFlag(.N, state: true)
		if current == 0x01 { registers.setFlag(.Z, state: true) }
		if current & 0x0F == 0 { registers.setFlag(.H, state: true) }
		
		memory.write(address: registers.HL, data: new)
	}
	
//	16-bit ALU
	
	func INC_n(n: RegisterMap.combined) {
		let current = registers.mapRegister(register: n).pointee
		var new = current + 1
		if new >= UInt16.max {
			new = 0
		}
		registers.load(register: n, with: UInt16(new))
	}
	
	func DEC_n(n: RegisterMap.combined) {
		let current = registers.mapRegister(register: n).pointee
		var new = current - 1
		if new <= 0 {
			new = 0
		}
	
		registers.load(register: n, with: UInt16(new))
	}
	
	func LDHL_SP_n(n: UInt8) {
		let val = Int(Int8(bitPattern: n))
		registers.HL =  UInt16(truncatingIfNeeded: Int(registers.SP) + val)
		registers.setFlag(.Z, state: false)
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: true)
		registers.setFlag(.C, state: true)
	}
	
	func ADD_HL_n(n: UInt16) {
		let HL = self.registers.HL
		
		registers.clearFlags(notAffacted: [.Z])
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: HL & 0x0FFF + n & 0x0FFF > 0x0FFF)
		registers.setFlag(.C, state: HL > HL &+ n)
		self.registers.HL = self.registers.HL &+ n
	}
}
// MARK: Bit
extension CPU: Bit {
	func SET_b_r(b: Int, r: RegisterMap.single) {
		registers.mapRegister(register: r).pointee.setBit(at: b, to: 1)
	}
	
	func SET_b_HL(b: Int) {
		var value: UInt8 = memory.readHalf(address: registers.HL)
		value.setBit(at: b, to: 1)
		memory.write(address: registers.HL, data: value)
	}
	
	func BIT_b_r(b: Int, r: UInt8) {
		let bit = r.bit(at: b)
		registers.clearFlags(notAffacted: [.C])
		registers.setFlag(.Z, state: bit == 0)
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: true)
	}
	
	func RES_b_r(b: Int, r: RegisterMap.single) {
		registers.mapRegister(register: r).pointee.setBit(at: b, to: 0)
	}
	
	func RES_b_HL(b: Int) {
		var value: UInt8 = memory.readHalf(address: registers.HL)
		value.setBit(at: b, to: 0)
		memory.write(address: registers.HL, data: value)
	}
}
// MARK: Rotates
extension CPU: Rotates {
	func RRCA() {
		let carry = (registers.A & Registers.Carry) << 7
		registers.A = (registers.A >> 1) + carry

		registers.setFlag(.H, state: false)
		registers.setFlag(.N, state: false)
		registers.setFlag(.Z, state: registers.A == 0)
		registers.setFlag(.C, state: carry > 0)
	}
	
	func RLCA() {
		// Save old carry from register A
		let oldCarry = registers.A.bit(at: 7)
		
		// Shift A to the left
		registers.A = registers.A.rotateLeft() + UInt8(oldCarry)
		
		// Set if result is zero.
		registers.setFlag(.Z, state: registers.A == 0)
		
		// Set if carry was set in old register A value
		registers.setFlag(.C, state: oldCarry > 0)
		
		// Reset other flags
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: false)
	}
	
	func RL_n(n: RegisterMap.single) {
		var register = registers.mapRegister(register: n).pointee
		// Save old carry from register
		let oldCarry = register.bit(at: 7)

		// Shift register to the left through Carry Flag
		register = register.rotateLeft()
		if registers.getFlag(.C) > 0 {
			register += Registers.Carry
		}
		
		// Set if result is zero.
		registers.setFlag(.Z, state: register == 0)
		
		// Set if carry was set in old register value
		registers.setFlag(.C, state: oldCarry > 0)
		
		// Reset other flags
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: false)
	}
	
	func RR_n(n: RegisterMap.single) {
		var register = registers.mapRegister(register: n).pointee
		// Save old carry from register
		let oldCarry = register.bit(at: 0)

		// Shift register to the left through Carry Flag
		register = register.rotateRight()
		if registers.getFlag(.C) > 0 {
			register += Registers.Zero
		}
		
		// Set if result is zero.
		registers.setFlag(.Z, state: register == 0)
		
		// Set if carry was set in old register A value
		registers.setFlag(.C, state: oldCarry > 0)
		
		// Reset other flags
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: false)
	}
	
	func RL_HL() {
		var register = memory.readHalf(address: registers.HL)
		// Save old carry from register
		let oldCarry = register.bit(at: 7)

		// Shift register to the left through Carry Flag
		register = register.rotateLeft()
		if registers.getFlag(.C) > 0 {
			register += Registers.Carry
		}
		memory.write(address: registers.HL, data: register)
		
		// Set if result is zero.
		registers.setFlag(.Z, state: register == 0)
		
		// Set if carry was set in old register value
		registers.setFlag(.C, state: oldCarry > 0)
		
		// Reset other flags
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: false)
	}
	
	func RR_HL() {
		var register = memory.readHalf(address: registers.HL)
		// Save old carry from register
		let oldCarry = register.bit(at: 0)

		// Shift register to the left through Carry Flag
		register = register.rotateRight()
		if registers.getFlag(.C) > 0 {
			register += Registers.Zero
		}
		memory.write(address: registers.HL, data: register)
		
		// Set if result is zero.
		registers.setFlag(.Z, state: register == 0)
		
		// Set if carry was set in old register A value
		registers.setFlag(.C, state: oldCarry > 0)
		
		// Reset other flags
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: false)
	}
}
// MARK: Jumps
extension CPU: Jumps {
	func JP_nn(nn: UInt16) {
		registers.PC = nn
	}
	
	func JP_HL() {
		registers.PC = registers.HL
	}
	
	func JR_n(n: UInt8) {
		// signed immediate
		let val = Int(Int8(bitPattern: n))
		registers.PC = UInt16(truncatingIfNeeded: Int(registers.PC) + val)
	}
	
	func JR_cc_n(flag: Flag, n: UInt8, state: Bool) {
		if registers.getFlagState(flag) == state {
			let val = Int(Int8(bitPattern: n))
			registers.PC = UInt16(truncatingIfNeeded: Int(registers.PC) + val)
			registers.PC += 2
		} else {
			registers.PC += 2
		}
	}
	
	func JR_cc_nn(flag: Flag, nn: UInt16, state: Bool) {
		if registers.getFlagState(flag) == state {
			registers.PC = registers.PC + nn
			registers.PC += 2
		} else {
			registers.PC += 2
		}
	}
}
// MARK: Calls
extension CPU: Calls {
	func CALL_nn(nn: UInt16) {
		memory.write(address: registers.SP-2, data: registers.PC+3)
		registers.SP -= 2
		registers.PC = nn
	}
	
	func CALL_cc_nn(flag: Flag, nn: UInt16, state: Bool) {
		if registers.getFlagState(flag) == state {
			self.CALL_nn(nn: nn)
		} else {
			registers.PC += 3
		}
	}
}
// MARK: Restarts
extension CPU: Restarts {
	func RST_n(n: UInt8) {
		self.PUSH_nn(nn: registers.PC)
		registers.PC = UInt16(0x0000 | n)
	}
}
// MARK: Returns
extension CPU: Returns {
	func RET() {
		registers.PC = memory.readFull(address: registers.SP)
		registers.SP += 2
	}
	
	func RET_cc(flag: Flag, state: Bool) {
		if registers.getFlagState(flag) == state {
			self.RET()
		} else {
			registers.PC += 2
		}
	}
	
	func RETI() {
		self.RET()
//		Enable interrupts
	}
}
