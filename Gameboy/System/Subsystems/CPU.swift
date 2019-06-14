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
	private let registers: Registers = Registers()
	private let memory: MMU
	private let clock: CPUTimer = CPUTimer()
	var cpuDelegate: CPUDelegate?
	
	init(memory: MMU) {
		self.memory = memory
	}
	
	func pause() -> CPUState {
		running = false
		return CPUState(registers: registers.toState(), memory: memory.toState())
	}
	
	func resume() {
		running = true
	}
	
	func start(cartridge: Cartridge) {
		guard let boot = FileSystem.readBootROM() else { return }

		memory.loadBios(Array<UInt8>(boot))
		memory.loadRom(Array<UInt8>(cartridge.rom))
		self.running = true
	}
	
	private var running = false // This needs to be determined by reading the Registers
	
	
	func tick() {
		guard running else { return }
		// fetch OPCode
		let code = memory.readHalf(address: registers.PC)
		print("Current PC is:: 0x\(String(registers.PC, radix: 16, uppercase: true))")
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
		self.opCodeFetchPrint(code: code)
		
		switch code {
//			Misc
		case 0x00:
			self.opCodePrint(code: code, func: "NOP")
			self.NOP()
		case 0x10:
			self.opCodePrint(code: code, func: "STOP")
			self.STOP()
		case 0x2F:
			self.opCodePrint(code: code, func: "CPL")
			self.CPL()
//			8-bit Loads
		case 0x06:
			self.opCodePrint(code: code, func: "LD_B_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(n: param, nn: .B)
		case 0x0E:
			self.opCodePrint(code: code, func: "LD_C_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(n: param, nn: .C)
		case 0x16:
			self.opCodePrint(code: code, func: "LD_D_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(n: param, nn: .D)
		case 0x1E:
			self.opCodePrint(code: code, func: "LD_E_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(n: param, nn: .E)
		case 0x26:
			self.opCodePrint(code: code, func: "LD_H_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(n: param, nn: .H)
		case 0x2E:
			self.opCodePrint(code: code, func: "LD_L_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_nn_n(n: param, nn: .L)
		case 0x47:
			self.opCodePrint(code: code, func: "LD_B_A")
			self.LD(r1: .B, r2: .A)
		case 0x4F:
			self.opCodePrint(code: code, func: "LD_C_A")
			self.LD(r1: .C, r2: .A)
		case 0x57:
			self.opCodePrint(code: code, func: "LD_D_A")
			self.LD(r1: .D, r2: .A)
		case 0x5F:
			self.opCodePrint(code: code, func: "LD_E_A")
			self.LD(r1: .E, r2: .A)
		case 0x60:
			self.opCodePrint(code: code, func: "LD_H_B")
			self.LD(r1: .H, r2: .B)
		case 0x67:
			self.opCodePrint(code: code, func: "LD_H_A")
			self.LD(r1: .H, r2: .A)
		case 0x6F:
			self.opCodePrint(code: code, func: "LD_L_A")
			self.LD(r1: .L, r2: .A)
		case 0x02:
			self.opCodePrint(code: code, func: "LD_BC_A")
			self.LD_n_A(n: registers.BC)
		case 0x12:
			self.opCodePrint(code: code, func: "LD_DE_A")
			self.LD_n_A(n: registers.DE)
		case 0x77:
			self.opCodePrint(code: code, func: "LD_HL_A")
			self.LD_n_A(n: registers.HL)
		case 0xEA:
			self.opCodePrint(code: code, func: "LD_#_A")
			let param = memory.readFull(address: registers.PC+1)
			self.LD_n_A(nn: param)
		case 0x32:
			self.opCodePrint(code: code, func: "LDD_HL_A")
			self.LDD_HL_A()
		case 0xE0:
			self.opCodePrint(code: code, func: "LDH_n_A")
			let param = memory.readHalf(address: registers.PC+1)
			self.LDH_n_A(n: param)
		case 0xE2:
			self.opCodePrint(code: code, func: "LD_A_C")
			self.LD_A_C()
		case 0xF0:
			self.opCodePrint(code: code, func: "LDH_A_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.LDH_A_n(n: param)
		case 0x7F:
			self.opCodePrint(code: code, func: "LD_A_A")
			self.LD(r1: .A, r2: .A)
		case 0x78:
			self.opCodePrint(code: code, func: "LD_A_B")
			self.LD(r1: .A, r2: .B)
		case 0x79:
			self.opCodePrint(code: code, func: "LD_A_C")
			self.LD(r1: .A, r2: .C)
		case 0x7A:
			self.opCodePrint(code: code, func: "LD_A_D")
			self.LD(r1: .A, r2: .D)
		case 0x7B:
			self.opCodePrint(code: code, func: "LD_A_E")
			self.LD(r1: .A, r2: .E)
		case 0x7C:
			self.opCodePrint(code: code, func: "LD_A_H")
			self.LD(r1: .A, r2: .H)
		case 0x7D:
			self.opCodePrint(code: code, func: "LD_A_L")
			self.LD(r1: .A, r2: .L)
		case 0x0A:
			self.opCodePrint(code: code, func: "LD_A_(BC)")
			let param = memory.readHalf(address: registers.BC)
			self.LD_A_r(r: param)
		case 0x1A:
			self.opCodePrint(code: code, func: "LD_A_(DE)")
			let param = memory.readHalf(address: registers.DE)
			self.LD_A_r(r: param)
		case 0x7E:
			self.opCodePrint(code: code, func: "LD_A_(HL)")
			let param = memory.readHalf(address: registers.HL)
			self.LD_A_r(r: param)
		case 0xFA:
			self.opCodePrint(code: code, func: "LD_A_(nn)")
			let address = memory.readFull(address: registers.PC+1)
			let param = memory.readHalf(address: address)
			self.LD_A_n(nn: param)
		case 0x3E:
			self.opCodePrint(code: code, func: "LD_A_#")
			let param = memory.readHalf(address: registers.PC+1)
			self.LD_A_n(n: param)
		case 0x22:
			self.opCodePrint(code: code, func: "LDI_HL_A")
			self.LDI_HL_A()
//			16-bit Loads
		case 0x08:
			self.opCodePrint(code: code, func: "LD_nn_SP")
			let param = memory.readFull(address: registers.PC+1)
			self.LD_nn_SP(nn: param)
		case 0x01:
			self.opCodePrint(code: code, func: "LD_n_nn")
			let param = memory.readFull(address: registers.PC+1)
			self.LD_n_nn(n: .BC, nn: param)
		case 0x11:
			self.opCodePrint(code: code, func: "LD_n_nn")
			let param = memory.readFull(address: registers.PC+1)
			self.LD_n_nn(n: .DE, nn: param)
		case 0x21:
			self.opCodePrint(code: code, func: "LD_n_nn")
			let param = memory.readFull(address: registers.PC+1)
			self.LD_n_nn(n: .HL, nn: param)
		case 0x31:
			self.opCodePrint(code: code, func: "LD_n_nn")
			let param = memory.readFull(address: registers.PC+1)
			self.LD_n_nn(n: .SP, nn: param)
		case 0xF9:
			self.opCodePrint(code: code, func: "LD_SP_HL")
			self.LD_SP_HL()
//			Jumps
		case 0xC3:
			self.opCodePrint(code: code, func: "JP_nn")
			let param = memory.readFull(address: registers.PC+1)
			self.JP_nn(nn: param)
		case 0x18:
			self.opCodePrint(code: code, func: "JP_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.JR_n(n: param)
		case 0x20:
			self.opCodePrint(code: code, func: "JR_cc_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.JR_cc_n(flag: .Z, n: param, state: false)
		case 0x28:
			self.opCodePrint(code: code, func: "JR_cc_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.JR_cc_n(flag: .Z, n: param, state: true)
		case 0x30:
			self.opCodePrint(code: code, func: "JR_cc_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.JR_cc_n(flag: .C, n: param, state: false)
		case 0x38:
			self.opCodePrint(code: code, func: "JR_cc_n")
			let param = memory.readHalf(address: registers.PC+1)
			self.JR_cc_n(flag: .C, n: param, state: true)
//			ALU
		case 0x9F:
			self.opCodePrint(code: code, func: "SBC_A_A")
			self.SBC_A_n(n: registers.A)
		case 0x98:
			self.opCodePrint(code: code, func: "SBC_A_B")
			self.SBC_A_n(n: registers.B)
		case 0x99:
			self.opCodePrint(code: code, func: "SBC_A_C")
			self.SBC_A_n(n: registers.C)
		case 0x9A:
			self.opCodePrint(code: code, func: "SBC_A_D")
			self.SBC_A_n(n: registers.D)
		case 0x9B:
			self.opCodePrint(code: code, func: "SBC_A_E")
			self.SBC_A_n(n: registers.E)
		case 0x9C:
			self.opCodePrint(code: code, func: "SBC_A_H")
			self.SBC_A_n(n: registers.H)
		case 0x9D:
			self.opCodePrint(code: code, func: "SBC_A_L")
			self.SBC_A_n(n: registers.L)
		case 0x9E:
			self.opCodePrint(code: code, func: "SBC_A_HL")
			let param = memory.readHalf(address: registers.HL)
			self.SBC_A_n(n: param)
		case 0xAF:
			self.opCodePrint(code: code, func: "XOR_A")
			self.XOR_n(n: registers.A)
		case 0xBF:
			self.opCodePrint(code: code, func: "CP_A")
			self.CP_nn(nn: registers.A)
		case 0xB8:
			self.opCodePrint(code: code, func: "CP_B")
			self.CP_nn(nn: registers.B)
		case 0xB9:
			self.opCodePrint(code: code, func: "CP_C")
			self.CP_nn(nn: registers.C)
		case 0xBA:
			self.opCodePrint(code: code, func: "CP_D")
			self.CP_nn(nn: registers.D)
		case 0xBB:
			self.opCodePrint(code: code, func: "CP_E")
			self.CP_nn(nn: registers.E)
		case 0xBC:
			self.opCodePrint(code: code, func: "CP_H")
			self.CP_nn(nn: registers.H)
		case 0xBD:
			self.opCodePrint(code: code, func: "CP_L")
			self.CP_nn(nn: registers.L)
		case 0xBE:
			self.opCodePrint(code: code, func: "CP_HL")
			let param = memory.readHalf(address: registers.HL)
			self.CP_HL(n: param)
		case 0xFE:
			self.opCodePrint(code: code, func: "CP_#")
			let param = memory.readHalf(address: registers.PC+1)
			self.CP_n(n: param)
		case 0x3C:
			self.opCodePrint(code: code, func: "INC_A")
			self.INC_n(n: .A)
		case 0x03:
			self.opCodePrint(code: code, func: "INC_BC")
			self.INC_n(n: .BC)
		case 0x04:
			self.opCodePrint(code: code, func: "INC_B")
			self.INC_n(n: .B)
		case 0x0C:
			self.opCodePrint(code: code, func: "INC_C")
			self.INC_n(n: .C)
		case 0x13:
			self.opCodePrint(code: code, func: "INC_DE")
			self.INC_n(n: .DE)
		case 0x14:
			self.opCodePrint(code: code, func: "INC_D")
			self.INC_n(n: .D)
		case 0x1C:
			self.opCodePrint(code: code, func: "INC_E")
			self.INC_n(n: .E)
		case 0x23:
			self.opCodePrint(code: code, func: "INC_HL")
			self.INC_n(n: .HL)
		case 0x24:
			self.opCodePrint(code: code, func: "INC_H")
			self.INC_n(n: .H)
		case 0x2C:
			self.opCodePrint(code: code, func: "INC_L")
			self.INC_n(n: .L)
		case 0x33:
			self.opCodePrint(code: code, func: "INC_SP")
			self.INC_n(n: .SP)
		case 0x34:
			self.opCodePrint(code: code, func: "INC_HL")
			self.INC_n(n: .HL)
		case 0x3D:
			self.opCodePrint(code: code, func: "DEC_A")
			self.DEC_n(n: .A)
		case 0x05:
			self.opCodePrint(code: code, func: "DEC_B")
			self.DEC_n(n: .B)
		case 0x0D:
			self.opCodePrint(code: code, func: "DEC_C")
			self.DEC_n(n: .C)
		case 0x15:
			self.opCodePrint(code: code, func: "DEC_D")
			self.DEC_n(n: .D)
		case 0x1D:
			self.opCodePrint(code: code, func: "DEC_E")
			self.DEC_n(n: .E)
		case 0x25:
			self.opCodePrint(code: code, func: "DEC_H")
			self.DEC_n(n: .H)
		case 0x2D:
			self.opCodePrint(code: code, func: "DEC_L")
			self.DEC_n(n: .L)
		case 0x35:
			self.opCodePrint(code: code, func: "DEC_HL")
			self.DEC_n(n: .HL)
		case 0x09:
			self.opCodePrint(code: code, func: "ADD_HL_BC")
			self.ADD_HL_n(n: registers.BC)
		case 0x19:
			self.opCodePrint(code: code, func: "ADD_HL_DE")
			self.ADD_HL_n(n: registers.DE)
		case 0x29:
			self.opCodePrint(code: code, func: "ADD_HL_HL")
			self.ADD_HL_n(n: registers.HL)
		case 0x39:
			self.opCodePrint(code: code, func: "ADD_HL_SP")
			self.ADD_HL_n(n: registers.SP)
		case 0xF5:
			self.opCodePrint(code: code, func: "PUSH_AF")
			self.PUSH_nn(nn: registers.AF)
		case 0xC5:
			self.opCodePrint(code: code, func: "PUSH_BC")
			self.PUSH_nn(nn: registers.BC)
		case 0xD5:
			self.opCodePrint(code: code, func: "PUSH_DE")
			self.PUSH_nn(nn: registers.DE)
		case 0xE5:
			self.opCodePrint(code: code, func: "PUSH_HL")
			self.PUSH_nn(nn: registers.HL)
		case 0xC1:
			self.opCodePrint(code: code, func: "POP_BC")
			self.POP_nn(nn: .BC)
		case 0xCB:
			let innerCode = memory.readHalf(address: registers.PC+1)
			switch(innerCode) {
			case 0x11:
				self.opCodePrint(code: code, func: "RL_C", innerCode: innerCode)
				self.RL_n(n: .C)
			case 0x17:
				self.opCodePrint(code: code, func: "RL_A", innerCode: innerCode)
				self.RL_n(n: .A)
//				Bits
			case 0x40:
				self.opCodePrint(code: code, func: "BIT_0_B", innerCode: innerCode)
				self.BIT_b_r(b: 0, r: registers.B)
			case 0x41:
				self.opCodePrint(code: code, func: "BIT_0_C", innerCode: innerCode)
				self.BIT_b_r(b: 0, r: registers.C)
			case 0x42:
				self.opCodePrint(code: code, func: "BIT_0_D", innerCode: innerCode)
				self.BIT_b_r(b: 0, r: registers.D)
			case 0x43:
				self.opCodePrint(code: code, func: "BIT_0_E", innerCode: innerCode)
				self.BIT_b_r(b: 0, r: registers.E)
			case 0x44:
				self.opCodePrint(code: code, func: "BIT_0_H", innerCode: innerCode)
				self.BIT_b_r(b: 0, r: registers.H)
			case 0x45:
				self.opCodePrint(code: code, func: "BIT_0_L", innerCode: innerCode)
				self.BIT_b_r(b: 0, r: registers.L)
			case 0x46:
				self.opCodePrint(code: code, func: "BIT_0_HL", innerCode: innerCode)
				let param = memory.readHalf(address: registers.HL)
				self.BIT_b_r(b: 0, r: param)
			case 0x47:
				self.opCodePrint(code: code, func: "BIT_0_A", innerCode: innerCode)
				self.BIT_b_r(b: 0, r: registers.A)
				
			case 0x48:
				self.opCodePrint(code: code, func: "BIT_1_B", innerCode: innerCode)
				self.BIT_b_r(b: 1, r: registers.B)
			case 0x49:
				self.opCodePrint(code: code, func: "BIT_1_C", innerCode: innerCode)
				self.BIT_b_r(b: 1, r: registers.C)
			case 0x4A:
				self.opCodePrint(code: code, func: "BIT_1_D", innerCode: innerCode)
				self.BIT_b_r(b: 1, r: registers.D)
			case 0x4B:
				self.opCodePrint(code: code, func: "BIT_1_E", innerCode: innerCode)
				self.BIT_b_r(b: 1, r: registers.E)
			case 0x4C:
				self.opCodePrint(code: code, func: "BIT_1_H", innerCode: innerCode)
				self.BIT_b_r(b: 1, r: registers.H)
			case 0x4D:
				self.opCodePrint(code: code, func: "BIT_1_L", innerCode: innerCode)
				self.BIT_b_r(b: 1, r: registers.L)
			case 0x4E:
				self.opCodePrint(code: code, func: "BIT_1_HL", innerCode: innerCode)
				let param = memory.readHalf(address: registers.HL)
				self.BIT_b_r(b: 1, r: param)
			case 0x4F:
				self.opCodePrint(code: code, func: "BIT_1_A", innerCode: innerCode)
				self.BIT_b_r(b: 1, r: registers.A)
				
			case 0x50:
				self.opCodePrint(code: code, func: "BIT_2_B", innerCode: innerCode)
				self.BIT_b_r(b: 2, r: registers.B)
			case 0x51:
				self.opCodePrint(code: code, func: "BIT_2_C", innerCode: innerCode)
				self.BIT_b_r(b: 2, r: registers.C)
			case 0x52:
				self.opCodePrint(code: code, func: "BIT_2_D", innerCode: innerCode)
				self.BIT_b_r(b: 2, r: registers.D)
			case 0x53:
				self.opCodePrint(code: code, func: "BIT_2_E", innerCode: innerCode)
				self.BIT_b_r(b: 2, r: registers.E)
			case 0x54:
				self.opCodePrint(code: code, func: "BIT_2_H", innerCode: innerCode)
				self.BIT_b_r(b: 2, r: registers.H)
			case 0x55:
				self.opCodePrint(code: code, func: "BIT_2_L", innerCode: innerCode)
				self.BIT_b_r(b: 2, r: registers.L)
			case 0x56:
				self.opCodePrint(code: code, func: "BIT_2_HL", innerCode: innerCode)
				let param = memory.readHalf(address: registers.HL)
				self.BIT_b_r(b: 2, r: param)
			case 0x57:
				self.opCodePrint(code: code, func: "BIT_2_A", innerCode: innerCode)
				self.BIT_b_r(b: 2, r: registers.A)
				
			case 0x58:
				self.opCodePrint(code: code, func: "BIT_3_B", innerCode: innerCode)
				self.BIT_b_r(b: 3, r: registers.B)
			case 0x59:
				self.opCodePrint(code: code, func: "BIT_3_C", innerCode: innerCode)
				self.BIT_b_r(b: 3, r: registers.C)
			case 0x5A:
				self.opCodePrint(code: code, func: "BIT_3_D", innerCode: innerCode)
				self.BIT_b_r(b: 3, r: registers.D)
			case 0x5B:
				self.opCodePrint(code: code, func: "BIT_3_E", innerCode: innerCode)
				self.BIT_b_r(b: 3, r: registers.E)
			case 0x5C:
				self.opCodePrint(code: code, func: "BIT_3_H", innerCode: innerCode)
				self.BIT_b_r(b: 3, r: registers.H)
			case 0x5D:
				self.opCodePrint(code: code, func: "BIT_3_L", innerCode: innerCode)
				self.BIT_b_r(b: 3, r: registers.L)
			case 0x5E:
				self.opCodePrint(code: code, func: "BIT_3_HL", innerCode: innerCode)
				let param = memory.readHalf(address: registers.HL)
				self.BIT_b_r(b: 3, r: param)
			case 0x5F:
				self.opCodePrint(code: code, func: "BIT_3_A", innerCode: innerCode)
				self.BIT_b_r(b: 3, r: registers.A)
				
			case 0x60:
				self.opCodePrint(code: code, func: "BIT_4_B", innerCode: innerCode)
				self.BIT_b_r(b: 4, r: registers.B)
			case 0x61:
				self.opCodePrint(code: code, func: "BIT_4_C", innerCode: innerCode)
				self.BIT_b_r(b: 4, r: registers.C)
			case 0x62:
				self.opCodePrint(code: code, func: "BIT_4_D", innerCode: innerCode)
				self.BIT_b_r(b: 4, r: registers.D)
			case 0x63:
				self.opCodePrint(code: code, func: "BIT_4_E", innerCode: innerCode)
				self.BIT_b_r(b: 4, r: registers.E)
			case 0x64:
				self.opCodePrint(code: code, func: "BIT_4_H", innerCode: innerCode)
				self.BIT_b_r(b: 4, r: registers.H)
			case 0x65:
				self.opCodePrint(code: code, func: "BIT_4_L", innerCode: innerCode)
				self.BIT_b_r(b: 4, r: registers.L)
			case 0x66:
				self.opCodePrint(code: code, func: "BIT_4_HL", innerCode: innerCode)
				let param = memory.readHalf(address: registers.HL)
				self.BIT_b_r(b: 4, r: param)
			case 0x67:
				self.opCodePrint(code: code, func: "BIT_4_A", innerCode: innerCode)
				self.BIT_b_r(b: 4, r: registers.A)
				
			case 0x68:
				self.opCodePrint(code: code, func: "BIT_5_B", innerCode: innerCode)
				self.BIT_b_r(b: 5, r: registers.B)
			case 0x69:
				self.opCodePrint(code: code, func: "BIT_5_C", innerCode: innerCode)
				self.BIT_b_r(b: 5, r: registers.C)
			case 0x6A:
				self.opCodePrint(code: code, func: "BIT_5_D", innerCode: innerCode)
				self.BIT_b_r(b: 5, r: registers.D)
			case 0x6B:
				self.opCodePrint(code: code, func: "BIT_5_E", innerCode: innerCode)
				self.BIT_b_r(b: 5, r: registers.E)
			case 0x6C:
				self.opCodePrint(code: code, func: "BIT_5_H", innerCode: innerCode)
				self.BIT_b_r(b: 5, r: registers.H)
			case 0x6D:
				self.opCodePrint(code: code, func: "BIT_5_L", innerCode: innerCode)
				self.BIT_b_r(b: 5, r: registers.L)
			case 0x6E:
				self.opCodePrint(code: code, func: "BIT_5_HL", innerCode: innerCode)
				let param = memory.readHalf(address: registers.HL)
				self.BIT_b_r(b: 5, r: param)
			case 0x6F:
				self.opCodePrint(code: code, func: "BIT_5_A", innerCode: innerCode)
				self.BIT_b_r(b: 5, r: registers.A)
				
			case 0x70:
				self.opCodePrint(code: code, func: "BIT_6_B", innerCode: innerCode)
				self.BIT_b_r(b: 6, r: registers.B)
			case 0x71:
				self.opCodePrint(code: code, func: "BIT_6_C", innerCode: innerCode)
				self.BIT_b_r(b: 6, r: registers.C)
			case 0x72:
				self.opCodePrint(code: code, func: "BIT_6_D", innerCode: innerCode)
				self.BIT_b_r(b: 6, r: registers.D)
			case 0x73:
				self.opCodePrint(code: code, func: "BIT_6_E", innerCode: innerCode)
				self.BIT_b_r(b: 6, r: registers.E)
			case 0x74:
				self.opCodePrint(code: code, func: "BIT_6_H", innerCode: innerCode)
				self.BIT_b_r(b: 6, r: registers.H)
			case 0x75:
				self.opCodePrint(code: code, func: "BIT_6_L", innerCode: innerCode)
				self.BIT_b_r(b: 6, r: registers.L)
			case 0x76:
				self.opCodePrint(code: code, func: "BIT_6_HL", innerCode: innerCode)
				let param = memory.readHalf(address: registers.HL)
				self.BIT_b_r(b: 6, r: param)
			case 0x77:
				self.opCodePrint(code: code, func: "BIT_6_A", innerCode: innerCode)
				self.BIT_b_r(b: 6, r: registers.A)
				
			case 0x78:
				self.opCodePrint(code: code, func: "BIT_7_B", innerCode: innerCode)
				self.BIT_b_r(b: 7, r: registers.B)
			case 0x79:
				self.opCodePrint(code: code, func: "BIT_7_C", innerCode: innerCode)
				self.BIT_b_r(b: 7, r: registers.C)
			case 0x7A:
				self.opCodePrint(code: code, func: "BIT_7_D", innerCode: innerCode)
				self.BIT_b_r(b: 7, r: registers.D)
			case 0x7B:
				self.opCodePrint(code: code, func: "BIT_7_E", innerCode: innerCode)
				self.BIT_b_r(b: 7, r: registers.E)
			case 0x7C:
				self.opCodePrint(code: code, func: "BIT_7_H", innerCode: innerCode)
				self.BIT_b_r(b: 7, r: registers.H)
			case 0x7D:
				self.opCodePrint(code: code, func: "BIT_7_L", innerCode: innerCode)
				self.BIT_b_r(b: 7, r: registers.L)
			case 0x7E:
				self.opCodePrint(code: code, func: "BIT_7_HL", innerCode: innerCode)
				let param = memory.readHalf(address: registers.HL)
				self.BIT_b_r(b: 7, r: param)
			case 0x7F:
				self.opCodePrint(code: code, func: "BIT_7_A", innerCode: innerCode)
				self.BIT_b_r(b: 7, r: registers.A)
			default:
				self.opCodeNotImplementedPrint(code: code, innerCode: innerCode)
			}
//			Calls
		case 0xCD:
			let param = memory.readFull(address: registers.PC+1)
			self.CALL_nn(nn: param)
		case 0xC4:
			self.opCodePrint(code: code, func: "CALL_cc_nn")
			let param = memory.readFull(address: registers.PC+1)
			self.CALL_cc_nn(flag: .Z, nn: param, state: false)
		case 0xCC:
			self.opCodePrint(code: code, func: "CALL_cc_nn")
			let param = memory.readFull(address: registers.PC+1)
			self.CALL_cc_nn(flag: .Z, nn: param, state: true)
		case 0xD4:
			self.opCodePrint(code: code, func: "CALL_cc_nn")
			let param = memory.readFull(address: registers.PC+1)
			self.CALL_cc_nn(flag: .C, nn: param, state: false)
		case 0xDC:
			self.opCodePrint(code: code, func: "CALL_cc_nn")
			let param = memory.readFull(address: registers.PC+1)
			self.CALL_cc_nn(flag: .C, nn: param, state: true)
//			Restarts
		case 0xC7:
			self.opCodePrint(code: code, func: "RST_n")
			self.RST_n(n: 0x00)
		case 0xCF:
			self.opCodePrint(code: code, func: "RST_n")
			self.RST_n(n: 0x08)
		case 0xD7:
			self.opCodePrint(code: code, func: "RST_n")
			self.RST_n(n: 0x10)
		case 0xDF:
			self.opCodePrint(code: code, func: "RST_n")
			self.RST_n(n: 0x18)
		case 0xE7:
			self.opCodePrint(code: code, func: "RST_n")
			self.RST_n(n: 0x20)
		case 0xEF:
			self.opCodePrint(code: code, func: "RST_n")
			self.RST_n(n: 0x28)
		case 0xF7:
			self.opCodePrint(code: code, func: "RST_n")
			self.RST_n(n: 0x30)
		case 0xFF:
			self.opCodePrint(code: code, func: "RST_n")
			self.RST_n(n: 0x38)
//			Rotates
		case 0x0F:
			self.opCodePrint(code: code, func: "RRCA")
			self.RRCA()
		case 0x17:
			self.opCodePrint(code: code, func: "RLA")
			self.RLA()
//			Returns
		case 0xC9:
			self.opCodePrint(code: code, func: "RET")
			self.RET()
		default:
 			self.opCodeNotImplementedPrint(code: code)
		}
	}
}
// MARK: Misc
extension CPU: Misc {
	func NOP() {
		registers.PC += 1
	}
	
	func STOP() {
//		self.running = false
		registers.PC += 1
	}
	
	func CPL() {
		registers.setFlag(.N, state: true)
		registers.setFlag(.H, state: true)
		registers.A ^= UInt8(UINT8_MAX)
		registers.PC += 1
	}
}
// MARK: Load
extension CPU: Load {
//	8-bit Loads
	func LD_nn_n(n: UInt8, nn: RegisterMap.single) {
		registers.load(register: nn, with: n)
		registers.PC += 2
	}
	
	func LD(r1: RegisterMap.single, r2: RegisterMap.single) {
		registers.load(register: r1, with: r2)
		registers.PC += 1
	}
	
	func LDHL(r1: RegisterMap.single) {
		registers.load(register: r1, with: memory.readHalf(address: registers.HL))
		registers.PC += 1
	}
	
	func LDHL(r2: UInt8) {
		memory.write(address: registers.HL, data: r2)
		registers.PC += 1
	}
	
	func LDHL(n: UInt8) {
		memory.write(address: registers.HL, data: n)
		registers.PC += 2
	}
	
	func LD_A_n(n: RegisterMap.single) {
		registers.load(register: .A, with: n)
		registers.PC += 1
	}
	
	func LD_A_r(r: UInt8) {
		registers.load(register: .A, with: r)
		registers.PC += 1
	}
	
	func LD_A_n(n: UInt8) {
		registers.load(register: .A, with: n)
		registers.PC += 2
	}
	
	func LD_A_n(nn: UInt8) {
		registers.load(register: .A, with: nn)
		registers.PC += 3
	}
	
	func LD_n_A(n: RegisterMap.single) {
		registers.load(register: n, with: .A)
		registers.PC += 1
	}
	
	func LD_n_A(nn: UInt16) {
		memory.write(address: nn, data: registers.A)
		registers.PC += 3
	}
	
	func LD_n_A(n: UInt16) {
		memory.write(address: n, data: registers.A)
		registers.PC += 1
	}
	
	func LD_A_C() {
		registers.A = memory.readHalf(address: 0xFF00 | UInt16(registers.C))
		registers.PC += 1
	}
	
	func LD_C_A() {
		memory.write(address: (0xFF00 | UInt16(registers.C)), data: registers.A)
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
		memory.write(address: 0xFF00 | UInt16(n), data: registers.A)
		registers.PC += 2
	}
	
	func LDH_A_n(n: UInt8) {
		let data = memory.readHalf(address: 0xFF00 | UInt16(n))
		registers.load(register: .A, with: data)
		registers.PC += 2
	}
//	16-bit Loads
	func LD_n_nn(n: RegisterMap.combined, nn: UInt16) {
		registers.load(register: n, with: nn)
		registers.PC += 3
	}
	
	func LD_SP_HL() {
		registers.load(register: .SP, with: .HL)
		registers.PC += 1
	}
	
	func LDHL_SP_n(n: UInt8) {
		let val = Int(Int8(bitPattern: n))
		registers.HL =  UInt16(truncatingIfNeeded: Int(registers.SP) + val)
		// Flags affected
		registers.PC += 2
	}
	
	func LD_nn_SP(nn: UInt16) {
		registers.SP = nn
		registers.PC += 3
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
// MARK: ALU
extension CPU: ALU { //	Flags affected
	
//	8-bit ALU
	
	func ADD_A_n(n: UInt8) {
		let l = registers.A
		let r = n
		registers.setFlag(.H, state: (((l & 0xf) + (r & 0xf)) & 0x10) == 0x10)
		registers.A += r
		registers.setFlag(.Z, state: registers.A == 0)
		registers.setFlag(.N, state: false)
		
		registers.PC += 1
	}
	
	func ADDC_A_n(n: UInt8) {
		registers.PC += 1
	}
	
	func SUB_n(n: UInt8) {
		registers.A -= n
		registers.PC += 1
	}
	
	func SBC_A_n(n: UInt8) {
		registers.A -= n + UInt8(registers.getFlag(.C))
		registers.PC += 1
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
		registers.PC += 1
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
		registers.PC += 1
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
		registers.PC += 1
	}
	
	func CP_nn(nn: UInt8) {
		let res: Int8 = Int8(registers.A) - Int8(nn)
		
		registers.setFlag(.Z, state: res == 0)
		registers.setFlag(.N, state: true)
//		H - Set if no borrow from bit 4. NEED TO FIGURE OUT HOW TO DETECT BORROWING
		registers.setFlag(.C, state: registers.A < nn)

		registers.PC += 1
	}
	
	func CP_HL(n: UInt8) {
		let res: Int = Int(registers.A) - Int(n)
		
		registers.setFlag(.Z, state: res == 0)
		registers.setFlag(.N, state: true)
		//		H - Set if no borrow from bit 4. NEED TO FIGURE OUT HOW TO DETECT BORROWING
		registers.setFlag(.C, state: registers.A < n)
		
		registers.PC += 1
	}
	
	func CP_n(n: UInt8) {
		let res: Int = Int(registers.A) - Int(n)
		
		registers.setFlag(.Z, state: res == 0)
		registers.setFlag(.N, state: true)
		//		H - Set if no borrow from bit 4. NEED TO FIGURE OUT HOW TO DETECT BORROWING
		registers.setFlag(.C, state: registers.A < n)
		
		registers.PC += 2
	}
	
	func INC_n(n: RegisterMap.single) {
		let current = registers.mapRegister(register: n).pointee
		let new = current + 1
		registers.setFlag(.Z, state: new == 0)
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: (((current & 0xf) + (new & 0xf)) & 0x10) == 0x10)
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
	
	func ADD_HL_n(n: UInt16) {
		self.registers.HL += n
		// flags affected
		registers.PC += 1
	}
}
// MARK: Bit
extension CPU: Bit {
	func SET_b_r(b: Int, r: RegisterMap.single) {
		registers.mapRegister(register: r).pointee.setBit(at: b, to: 1)
		registers.PC += 2
	}
	
	func SET_b_HL(b: Int) {
		var value: UInt8 = memory.readHalf(address: registers.HL)
		value.setBit(at: b, to: 1)
		memory.write(address: registers.HL, data: value)
		registers.PC += 2
	}
	
	func BIT_b_r(b: Int, r: UInt8) {
		let bit = r.bit(at: b)
		if bit == 0 { registers.setFlag(.Z, state: true) }
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: true)
		registers.PC += 2
	}
	
	func RES_b_r(b: Int, r: RegisterMap.single) {
		registers.mapRegister(register: r).pointee.setBit(at: b, to: 0)
		registers.PC += 2
	}
	
	func RES_b_HL(b: Int) {
		var value: UInt8 = memory.readHalf(address: registers.HL)
		value.setBit(at: b, to: 0)
		memory.write(address: registers.HL, data: value)
		registers.PC += 2
	}
}
// MARK: Rotates
extension CPU: Rotates {
	func RRCA() {
		// Save old bit 0 of Register A in Carry Flag
		let oldBit0 = registers.A.isSet(0)
		registers.setFlag(.C, state: oldBit0)
		
		// Shift A to the right
		registers.A = registers.A.rotateRight()
		
		// Set if result is zero. I THINK :shrug:
		registers.setFlag(.Z, state: registers.A.isSet(0))
		
		registers.PC += 2
	}
	
	func RLCA() {
		// Save old bit 7 of Register A in Carry Flag
		let oldBit7 = registers.A.isSet(7)
		registers.setFlag(.C, state: oldBit7)
		
		// Shift A to the right
		registers.A = registers.A.rotateLeft()
		
		// Set if result is zero. I THINK :shrug:
		registers.setFlag(.Z, state: registers.A.isSet(7))
		
		// Reset other flags
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: false)
		
		registers.PC += 2
	}
	
	func RLA() {
		// Save old bit 7 of Register A in Carry Flag
		let oldBit7 = registers.A.isSet(7)
		registers.setFlag(.C, state: oldBit7)
		
		// Shift A to the left
		registers.A = registers.A.rotateLeft()
		
		// Set if result is zero. I THINK :shrug:
		registers.setFlag(.Z, state: !registers.A.isSet(Flag.C.hashValue))
		
		// Reset other flags
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: false)
		
		registers.PC += 1
	}
	
	func RRA() {
		// Save old bit 0 of Register A in Carry Flag
		let oldBit0 = registers.A.isSet(0)
		registers.setFlag(.C, state: oldBit0)
		
		// Shift A to the right
		registers.A = registers.A.rotateRight()
		
		// Set if result is zero. I THINK :shrug:
		registers.setFlag(.Z, state: registers.A.isSet(Flag.C.hashValue))
		
		// Reset other flags
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: false)
		
		registers.PC += 2
	}
	
	func RL_n(n: RegisterMap.single) {
		var r = registers.mapRegister(register: n).pointee
		let carry = r & 0x80
		r = (r << 1)
		if registers.getFlagState(.C) { r += 0x01 }
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: false)
		if(r == 0) { registers.setFlag(.Z, state: true) }
		if(carry > 0) { registers.setFlag(.C, state: true) }
		registers.PC += 2
	}
	
	func RL_HL() {
		var r = memory.readHalf(address: registers.HL)
		let carry = r & 0x80
		r = (r << 1)
		if registers.getFlagState(.C) { r += 0x01 }
		memory.write(address: registers.HL, data: r)
		registers.setFlag(.N, state: false)
		registers.setFlag(.H, state: false)
		if(r == 0) { registers.setFlag(.Z, state: true) }
		if(carry > 0) { registers.setFlag(.C, state: true) }
		registers.PC += 2
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
		registers.PC += UInt16(truncatingIfNeeded: Int(registers.PC) + val)
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
}
// MARK: Calls
extension CPU: Calls {
	func CALL_nn(nn: UInt16) {
		registers.SP -= 2
		memory.write(address: registers.SP, data: registers.PC+3)
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
// MARKL Returns
extension CPU: Returns {
	func RET() {
		registers.PC = memory.readFull(address: registers.SP)
		registers.SP += 2
	}
}
