//
//  Instructions.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-26.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

protocol InstructionInvoker {
	func fetchAndInvokeInstruction(with code: UInt8)
}

struct Instructions {
	typealias Operation = (cycles: UInt, pc: UInt16, (CPU, UInt8) -> Void)
	typealias InstructionLookupTable = Dictionary<UInt8, Operation>
	typealias InnerInstructionLookupTable = Dictionary<UInt8, Operation>

	static func generateInnerInstructionLookupTable() -> InnerInstructionLookupTable {
			return InnerInstructionLookupTable(uniqueKeysWithValues: [
	//			MARK: Rotates
				(0x10 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_B")
					cpu.RL_n(n: .B)
				}) as Operation),
				(0x11 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_C")
					cpu.RL_n(n: .C)
				}) as Operation),
				(0x12 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_D")
					cpu.RL_n(n: .D)
				}) as Operation),
				(0x13 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_E")
					cpu.RL_n(n: .E)
				}) as Operation),
				(0x14 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_L")
					cpu.RL_n(n: .L)
				}) as Operation),
				(0x15 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_H")
					cpu.RL_n(n: .H)
				}) as Operation),
				(0x16 as UInt8, (cycles: 4, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_HL")
					cpu.RL_HL()
				}) as Operation),
				(0x17 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_A")
					cpu.RL_n(n: .A)
				}) as Operation),
	//			MARK: Bits : Bit 0
				(0x40 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_0_B")
					cpu.BIT_b_r(b: 0, r: cpu.registers.B)
				}) as Operation),
				(0x41 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_0_C")
					cpu.BIT_b_r(b: 0, r: cpu.registers.C)
				}) as Operation),
				(0x42 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_0_D")
					cpu.BIT_b_r(b: 0, r: cpu.registers.D)
				}) as Operation),
				(0x43 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_0_E")
					cpu.BIT_b_r(b: 0, r: cpu.registers.E)
				}) as Operation),
				(0x44 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_0_H")
					cpu.BIT_b_r(b: 0, r: cpu.registers.H)
				}) as Operation),
				(0x45 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_0_L")
					cpu.BIT_b_r(b: 0, r: cpu.registers.L)
				}) as Operation),
				(0x46 as UInt8, (cycles: 4, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_0_HL")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.BIT_b_r(b: 0, r: param)
				}) as Operation),
				(0x47 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_0_A")
					cpu.BIT_b_r(b: 0, r: cpu.registers.A)
				}) as Operation),
	//			MARK: Bits : Bit 1
				(0x48 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_1_B")
					cpu.BIT_b_r(b: 1, r: cpu.registers.B)
				}) as Operation),
				(0x49 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_1_C")
					cpu.BIT_b_r(b: 1, r: cpu.registers.C)
				}) as Operation),
				(0x4A as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_1_D")
					cpu.BIT_b_r(b: 1, r: cpu.registers.D)
				}) as Operation),
				(0x4B as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_1_E")
					cpu.BIT_b_r(b: 1, r: cpu.registers.E)
				}) as Operation),
				(0x4C as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_1_H")
					cpu.BIT_b_r(b: 1, r: cpu.registers.H)
				}) as Operation),
				(0x4D as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_1_L")
					cpu.BIT_b_r(b: 1, r: cpu.registers.L)
				}) as Operation),
				(0x4E as UInt8, (cycles: 4, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_1_HL")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.BIT_b_r(b: 1, r: param)
				}) as Operation),
				(0x4F as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_1_A")
					cpu.BIT_b_r(b: 1, r: cpu.registers.A)
				}) as Operation),
	//			MARK: Bits : Bit 2
				(0x50 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_2_B")
					cpu.BIT_b_r(b: 2, r: cpu.registers.B)
				}) as Operation),
				(0x51 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_2_C")
					cpu.BIT_b_r(b: 2, r: cpu.registers.C)
				}) as Operation),
				(0x52 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_2_D")
					cpu.BIT_b_r(b: 2, r: cpu.registers.D)
				}) as Operation),
				(0x53 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_2_E")
					cpu.BIT_b_r(b: 2, r: cpu.registers.E)
				}) as Operation),
				(0x54 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_2_H")
					cpu.BIT_b_r(b: 2, r: cpu.registers.H)
				}) as Operation),
				(0x55 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_2_L")
					cpu.BIT_b_r(b: 2, r: cpu.registers.L)
				}) as Operation),
				(0x56 as UInt8, (cycles: 4, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_2_HL")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.BIT_b_r(b: 2, r: param)
				}) as Operation),
				(0x57 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_2_A")
					cpu.BIT_b_r(b: 2, r: cpu.registers.A)
				}) as Operation),
	//			MARK: Bits : Bit 3
				(0x58 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_3_B")
					cpu.BIT_b_r(b: 3, r: cpu.registers.B)
				}) as Operation),
				(0x59 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_3_C")
					cpu.BIT_b_r(b: 3, r: cpu.registers.C)
				}) as Operation),
				(0x5A as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_3_D")
					cpu.BIT_b_r(b: 3, r: cpu.registers.D)
				}) as Operation),
				(0x5B as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_3_E")
					cpu.BIT_b_r(b: 3, r: cpu.registers.E)
				}) as Operation),
				(0x5C as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_3_H")
					cpu.BIT_b_r(b: 3, r: cpu.registers.H)
				}) as Operation),
				(0x5D as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_3_L")
					cpu.BIT_b_r(b: 3, r: cpu.registers.L)
				}) as Operation),
				(0x5E as UInt8, (cycles: 4, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_3_HL")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.BIT_b_r(b: 3, r: param)
				}) as Operation),
				(0x5F as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_3_A")
					cpu.BIT_b_r(b: 3, r: cpu.registers.A)
				}) as Operation),
	//			MARK: Bits : Bit 4
				(0x60 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_4_B")
					cpu.BIT_b_r(b: 4, r: cpu.registers.B)
				}) as Operation),
				(0x61 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_4_C")
					cpu.BIT_b_r(b: 4, r: cpu.registers.C)
				}) as Operation),
				(0x62 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_4_D")
					cpu.BIT_b_r(b: 4, r: cpu.registers.D)
				}) as Operation),
				(0x63 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_4_E")
					cpu.BIT_b_r(b: 4, r: cpu.registers.E)
				}) as Operation),
				(0x64 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_4_H")
					cpu.BIT_b_r(b: 4, r: cpu.registers.H)
				}) as Operation),
				(0x65 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_4_L")
					cpu.BIT_b_r(b: 4, r: cpu.registers.L)
				}) as Operation),
				(0x66 as UInt8, (cycles: 4, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_4_HL")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.BIT_b_r(b: 4, r: param)
				}) as Operation),
				(0x67 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_4_A")
					cpu.BIT_b_r(b: 4, r: cpu.registers.A)
				}) as Operation),
	//			MARK: Bits : Bit 5
				(0x68 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_5_B")
					cpu.BIT_b_r(b: 5, r: cpu.registers.B)
				}) as Operation),
				(0x69 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_5_C")
					cpu.BIT_b_r(b: 5, r: cpu.registers.C)
				}) as Operation),
				(0x6A as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_5_D")
					cpu.BIT_b_r(b: 5, r: cpu.registers.D)
				}) as Operation),
				(0x6B as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_5_E")
					cpu.BIT_b_r(b: 5, r: cpu.registers.E)
				}) as Operation),
				(0x6C as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_5_H")
					cpu.BIT_b_r(b: 5, r: cpu.registers.H)
				}) as Operation),
				(0x6D as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_5_L")
					cpu.BIT_b_r(b: 5, r: cpu.registers.L)
				}) as Operation),
				(0x6E as UInt8, (cycles: 4, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_5_HL")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.BIT_b_r(b: 5, r: param)
				}) as Operation),
				(0x6F as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_5_A")
					cpu.BIT_b_r(b: 5, r: cpu.registers.A)
				}) as Operation),
	//			MARK: Bits : Bit 6
				(0x70 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_6_B")
					cpu.BIT_b_r(b: 6, r: cpu.registers.B)
				}) as Operation),
				(0x71 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_6_C")
					cpu.BIT_b_r(b: 6, r: cpu.registers.C)
				}) as Operation),
				(0x72 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_6_D")
					cpu.BIT_b_r(b: 6, r: cpu.registers.D)
				}) as Operation),
				(0x73 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_6_E")
					cpu.BIT_b_r(b: 6, r: cpu.registers.E)
				}) as Operation),
				(0x74 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_6_H")
					cpu.BIT_b_r(b: 6, r: cpu.registers.H)
				}) as Operation),
				(0x75 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_6_L")
					cpu.BIT_b_r(b: 6, r: cpu.registers.L)
				}) as Operation),
				(0x76 as UInt8, (cycles: 4, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_6_HL")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.BIT_b_r(b: 6, r: param)
				}) as Operation),
				(0x77 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_6_A")
					cpu.BIT_b_r(b: 6, r: cpu.registers.A)
				}) as Operation),
	//			MARK: Bits : Bit 7
				(0x78 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_7_B")
					cpu.BIT_b_r(b: 7, r: cpu.registers.B)
				}) as Operation),
				(0x79 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_7_C")
					cpu.BIT_b_r(b: 7, r: cpu.registers.C)
				}) as Operation),
				(0x7A as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_7_D")
					cpu.BIT_b_r(b: 7, r: cpu.registers.D)
				}) as Operation),
				(0x7B as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_7_E")
					cpu.BIT_b_r(b: 7, r: cpu.registers.E)
				}) as Operation),
				(0x7C as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_7_H")
					cpu.BIT_b_r(b: 7, r: cpu.registers.H)
				}) as Operation),
				(0x7D as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_7_L")
					cpu.BIT_b_r(b: 7, r: cpu.registers.L)
				}) as Operation),
				(0x7E as UInt8, (cycles: 4, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_7_HL")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.BIT_b_r(b: 7, r: param)
				}) as Operation),
				(0x7F as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "BIT_7_A")
					cpu.BIT_b_r(b: 7, r: cpu.registers.A)
				}) as Operation)
			])
		}
		
		static func generateInstructionLookupTable() -> InstructionLookupTable {
			return InstructionLookupTable(uniqueKeysWithValues: [
	//			MARK: Misc
				(0x00 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "NOP")
					cpu.NOP()
				}) as Operation),
				(0x10 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "STOP")
					cpu.STOP()
				}) as Operation),
				(0x2F as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CPL")
					cpu.CPL()
				}) as Operation),
				(0xF3 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DI")
					cpu.DI()
				}) as Operation),
	//			MARK: 8-bit Loads
				(0x2A as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LDI_A_HL")
					cpu.LDI_A_HL()
				}) as Operation),
				(0x3E as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.LD_nn_n(n: param, nn: .A)
				}) as Operation),
				(0x06 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_B_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.LD_nn_n(n: param, nn: .B)
				}) as Operation),
				(0x0E as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_C_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.LD_nn_n(n: param, nn: .C)
				}) as Operation),
				(0x16 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_D_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.LD_nn_n(n: param, nn: .D)
				}) as Operation),
				(0x1E as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_E_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.LD_nn_n(n: param, nn: .D)
				}) as Operation),
				(0x26 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_H_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.LD_nn_n(n: param, nn: .H)
				}) as Operation),
				(0x2E as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_L_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.LD_nn_n(n: param, nn: .L)
				}) as Operation),
				(0x44 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_B_H")
					cpu.LD(r1: .B, r2: .H)
				}) as Operation),
				(0x47 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_B_A")
					cpu.LD(r1: .B, r2: .A)
				}) as Operation),
				(0x4F as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_C_H")
					cpu.LD(r1: .C, r2: .H)
				}) as Operation),

				(0x57 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_D_A")
					cpu.LD(r1: .D, r2: .A)
				}) as Operation),
				(0x5F as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_E_A")
					cpu.LD(r1: .E, r2: .A)
				}) as Operation),
				(0x60 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_H_B")
					cpu.LD(r1: .H, r2: .B)
				}) as Operation),
				(0x67 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_H_A")
					cpu.LD(r1: .H, r2: .A)
				}) as Operation),
				(0x6F as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_L_A")
					cpu.LD(r1: .L, r2: .A)
				}) as Operation),
				(0x02 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_BC_A")
					cpu.LD_n_A(n: cpu.registers.BC)
				}) as Operation),
				(0x12 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_DE_A")
					cpu.LD_n_A(n: cpu.registers.DE)
				}) as Operation),
				(0x77 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_HL_A")
					cpu.LD_n_A(n: cpu.registers.HL)
				}) as Operation),
				(0xEA as UInt8, (cycles: 4, pc: 3, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_nn_A")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.LD_n_A(n: param)
				}) as Operation),
				(0x32 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LDD_HL_A")
					cpu.LDD_HL_A()
				}) as Operation),
				(0xE0 as UInt8, (cycles: 3, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LDH_n_A")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.LDH_n_A(n: param)
				}) as Operation),
				(0xE2 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_C")
					cpu.LD_A_C()
				}) as Operation),
				(0xF0 as UInt8, (cycles: 3, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LDH_A_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.LDH_A_n(n: param)
				}) as Operation),
				(0x7F as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_A")
					cpu.LD(r1: .A, r2: .A)
				}) as Operation),
				(0x78 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_B")
					cpu.LD(r1: .A, r2: .B)
				}) as Operation),
				(0x79 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_C")
					cpu.LD(r1: .A, r2: .C)
				}) as Operation),
				(0x7A as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_D")
					cpu.LD(r1: .A, r2: .D)
				}) as Operation),
				(0x7B as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_E")
					cpu.LD(r1: .A, r2: .E)
				}) as Operation),
				(0x7C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_H")
					cpu.LD(r1: .A, r2: .H)
				}) as Operation),
				(0x7D as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_L")
					cpu.LD(r1: .A, r2: .L)
				}) as Operation),
				(0x0A as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_(BC)")
					let param = cpu.memory.readHalf(address: cpu.registers.BC)
					cpu.LD_A_r(r: param)
				}) as Operation),
				(0x1A as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_(DE)")
					let param = cpu.memory.readHalf(address: cpu.registers.DE)
					cpu.LD_A_r(r: param)
				}) as Operation),
				(0x7E as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_(HL)")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.LD_A_r(r: param)
				}) as Operation),
				(0xFA as UInt8, (cycles: 4, pc: 3, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_A_(nn)")
					let address = cpu.memory.readFull(address: cpu.registers.PC+1)
					let param = cpu.memory.readHalf(address: address)
					cpu.LD_A_n(nn: param)
				}) as Operation),
				(0x22 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LDI_HL_A")
					cpu.LDI_HL_A()
				}) as Operation),
	//			MARK: 16-bit Loads
				(0x08 as UInt8, (cycles: 5, pc: 3, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_nn_SP")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.LD_nn_SP(nn: param)
				}) as Operation),
				(0x01 as UInt8, (cycles: 3, pc: 3, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_n_nn")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.LD_n_nn(n: .BC, nn: param)
				}) as Operation),
				(0x11 as UInt8, (cycles: 3, pc: 3, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_n_nn")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.LD_n_nn(n: .DE, nn: param)
				}) as Operation),
				(0x21 as UInt8, (cycles: 3, pc: 3, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_n_nn")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.LD_n_nn(n: .HL, nn: param)
				}) as Operation),
				(0x31 as UInt8, (cycles: 3, pc: 3, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_n_nn")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.LD_n_nn(n: .SP, nn: param)
				}) as Operation),
				(0xF9 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "LD_SP_HL")
					cpu.LD_SP_HL()
				}) as Operation),
	//			MARK: Jumps
				(0xC3 as UInt8, (cycles: 3, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "JP_nn")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.JP_nn(nn: param)
				}) as Operation),
				(0x18 as UInt8, (cycles: 2, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "JP_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.JR_n(n: param)
				}) as Operation),
				(0x20 as UInt8, (cycles: 2, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "JR_cc_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.JR_cc_n(flag: .Z, n: param, state: false)
				}) as Operation),
				(0x28 as UInt8, (cycles: 2, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "JR_cc_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.JR_cc_n(flag: .Z, n: param, state: true)
				}) as Operation),
				(0x30 as UInt8, (cycles: 2, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "JR_cc_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.JR_cc_n(flag: .C, n: param, state: false)
				}) as Operation),
				(0x38 as UInt8, (cycles: 2, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "JR_cc_n")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.JR_cc_n(flag: .C, n: param, state: true)
				}) as Operation),

	//			MARK: ALU
				(0x80 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "ADD_A_B")
					cpu.ADD_A_n(n: cpu.registers.B)
				}) as Operation),
				(0x8C as UInt8, (cycles: 1, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "ADC_A_H")
					cpu.ADC_A_n(n: cpu.registers.H)
				}) as Operation),
				(0x90 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SUB_B_A")
					cpu.SUB_n(n: .B)
				}) as Operation),
				(0x91 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SUB_C_A")
					cpu.SUB_n(n: .C)
				}) as Operation),
				(0x92 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SUB_D_A")
					cpu.SUB_n(n: .D)
				}) as Operation),
				(0x93 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SUB_E_A")
					cpu.SUB_n(n: .E)
				}) as Operation),
				(0x94 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SUB_H_A")
					cpu.SUB_n(n: .H)
				}) as Operation),
				(0x95 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SUB_L_A")
					cpu.SUB_n(n: .L)
				}) as Operation),
				(0x96 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SUB_(HL)_A")
					cpu.SUB_HL()
				}) as Operation),
				(0x97 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SUB_A_A")
					cpu.SUB_n(n: .A)
				}) as Operation),
				(0xD6 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SUB_#_A")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.SUB_n(n: param)
				}) as Operation),
				(0x9F as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SBC_A_A")
					cpu.SBC_A_n(n: cpu.registers.A)
				}) as Operation),
				(0x98 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SBC_A_B")
					cpu.SBC_A_n(n: cpu.registers.B)
				}) as Operation),
				(0x99 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SBC_A_C")
					cpu.SBC_A_n(n: cpu.registers.C)
				}) as Operation),
				(0x9A as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SBC_A_D")
					cpu.SBC_A_n(n: cpu.registers.D)
				}) as Operation),
				(0x9B as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SBC_A_E")
					cpu.SBC_A_n(n: cpu.registers.E)
				}) as Operation),
				(0x9C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SBC_A_H")
					cpu.SBC_A_n(n: cpu.registers.H)
				}) as Operation),
				(0x9D as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SBC_A_L")
					cpu.SBC_A_n(n: cpu.registers.L)
				}) as Operation),
				(0x9E as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SBC_A_HL")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.SBC_A_n(n: param)
				}) as Operation),
				(0xAF as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "XOR_A")
					cpu.XOR_n(n: cpu.registers.A)
				}) as Operation),
				(0xAE as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "XOR_HL")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.XOR_n(n: param)
				}) as Operation),
				(0xBF as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CP_A")
					cpu.CP_n(n: cpu.registers.A)
				}) as Operation),
				(0xB8 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CP_B")
					cpu.CP_n(n: cpu.registers.B)
				}) as Operation),
				(0xB9 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CP_C")
					cpu.CP_n(n: cpu.registers.C)
				}) as Operation),
				(0xBA as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CP_D")
					cpu.CP_n(n: cpu.registers.D)
				}) as Operation),
				(0xBB as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CP_E")
					cpu.CP_n(n: cpu.registers.E)
				}) as Operation),
				(0xBC as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CP_H")
					cpu.CP_n(n: cpu.registers.H)
				}) as Operation),
				(0xBD as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CP_L")
					cpu.CP_n(n: cpu.registers.L)
				}) as Operation),
				(0xBE as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CP_HL")
					let param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.CP_HL(n: param)
				}) as Operation),
				(0xFE as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CP_#")
					let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
					cpu.CP_n(n: param)
				}) as Operation),
				(0x1B as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_DE")
					cpu.DEC_n(n: .DE)
				}) as Operation),
				(0x3C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_A")
					cpu.INC_n(n: .A)
				}) as Operation),
				(0x03 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_BC")
					cpu.INC_n(n: .BC)
				}) as Operation),
				(0x04 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_B")
					cpu.INC_n(n: .B)
				}) as Operation),
				(0x0B as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_BC")
					cpu.DEC_n(n: .BC)
				}) as Operation),
				(0x0C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_C")
					cpu.INC_n(n: .C)
				}) as Operation),
				(0x13 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_DE")
					cpu.INC_n(n: .DE)
				}) as Operation),
				(0x14 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_D")
					cpu.INC_n(n: .D)
				}) as Operation),
				(0x1C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_E")
					cpu.INC_n(n: .E)
				}) as Operation),
				(0x23 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_HL")
					cpu.INC_n(n: .HL)
				}) as Operation),
				(0x24 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_H")
					cpu.INC_n(n: .H)
				}) as Operation),
				(0x2B as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_HL")
					cpu.DEC_n(n: .HL)
				}) as Operation),
				(0x2C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_L")
					cpu.INC_n(n: .L)
				}) as Operation),
				(0x33 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_SP")
					cpu.INC_n(n: .SP)
				}) as Operation),
				(0x34 as UInt8, (cycles: 3, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "INC_HL")
					cpu.INC_HL()
				}) as Operation),
				(0x3B as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_SP")
					cpu.DEC_n(n: .SP)
				}) as Operation),
				(0x3D as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_A")
					cpu.DEC_n(n: .A)
				}) as Operation),
				(0x05 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_B")
					cpu.DEC_n(n: .B)
				}) as Operation),
				(0x0D as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_C")
					cpu.DEC_n(n: .C)
				}) as Operation),
				(0x15 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_D")
					cpu.DEC_n(n: .D)
				}) as Operation),
				(0x1D as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_E")
					cpu.DEC_n(n: .E)
				}) as Operation),
				(0x25 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_H")
					cpu.DEC_n(n: .H)
				}) as Operation),
				(0x2D as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_L")
					cpu.DEC_n(n: .L)
				}) as Operation),
				(0x35 as UInt8, (cycles: 3, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "DEC_HL")
					cpu.DEC_HL()
				}) as Operation),
				(0x09 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "ADD_HL_BC")
					cpu.ADD_HL_n(n: cpu.registers.BC)
				}) as Operation),
				(0x19 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "ADD_HL_DE")
					cpu.ADD_HL_n(n: cpu.registers.DE)
				}) as Operation),
				(0x29 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "ADD_HL_HL")
					cpu.ADD_HL_n(n: cpu.registers.HL)
				}) as Operation),
				(0x39 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "ADD_HL_SP")
					cpu.ADD_HL_n(n: cpu.registers.BC)
				}) as Operation),
				(0xF5 as UInt8, (cycles: 4, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "PUSH_AF")
					cpu.PUSH_nn(nn: cpu.registers.AF)
				}) as Operation),
				(0xC5 as UInt8, (cycles: 4, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "PUSH_BC")
					cpu.PUSH_nn(nn: cpu.registers.BC)
				}) as Operation),
				(0xD5 as UInt8, (cycles: 4, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "PUSH_DE")
					cpu.PUSH_nn(nn: cpu.registers.DE)
				}) as Operation),
				(0xE5 as UInt8, (cycles: 4, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "PUSH_HL")
					cpu.PUSH_nn(nn: cpu.registers.HL)
				}) as Operation),
				(0xF1 as UInt8, (cycles: 3, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "POP_AF")
					cpu.POP_nn(nn: .AF)
				}) as Operation),
				(0xC1 as UInt8, (cycles: 3, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "POP_BC")
					cpu.POP_nn(nn: .BC)
				}) as Operation),
				(0xD1 as UInt8, (cycles: 3, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "POP_DE")
					cpu.POP_nn(nn: .DE)
				}) as Operation),
				(0xE1 as UInt8, (cycles: 3, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "POP_HL")
					cpu.POP_nn(nn: .HL)
				}) as Operation),
	//			MARK: Calls
				(0xCD as UInt8, (cycles: 3, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CALL_nn")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.CALL_nn(nn: param)
				}) as Operation),
				(0xC4 as UInt8, (cycles: 3, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CALL_cc_nn")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.CALL_cc_nn(flag: .Z, nn: param, state: false)
				}) as Operation),
				(0xCC as UInt8, (cycles: 3, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CALL_cc_nn")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.CALL_cc_nn(flag: .Z, nn: param, state: true)
				}) as Operation),
				(0xD4 as UInt8, (cycles: 3, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CALL_cc_nn")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.CALL_cc_nn(flag: .C, nn: param, state: false)
				}) as Operation),
				(0xDC as UInt8, (cycles: 3, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "CALL_cc_nn")
					let param = cpu.memory.readFull(address: cpu.registers.PC+1)
					cpu.CALL_cc_nn(flag: .C, nn: param, state: true)
				}) as Operation),
	//			MARK: Restarts
				(0xC7 as UInt8, (cycles: 8, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RST_n")
					cpu.RST_n(n: 0x00)
				}) as Operation),
				(0xCF as UInt8, (cycles: 8, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RST_n")
					cpu.RST_n(n: 0x08)
				}) as Operation),
				(0xD7 as UInt8, (cycles: 8, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RST_n")
					cpu.RST_n(n: 0x10)
				}) as Operation),
				(0xDF as UInt8, (cycles: 8, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RST_n")
					cpu.RST_n(n: 0x18)
				}) as Operation),
				(0xE7 as UInt8, (cycles: 8, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RST_n")
					cpu.RST_n(n: 0x20)
				}) as Operation),
				(0xEF as UInt8, (cycles: 8, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RST_n")
					cpu.RST_n(n: 0x28)
				}) as Operation),
				(0xF7 as UInt8, (cycles: 8, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RST_n")
					cpu.RST_n(n: 0x30)
				}) as Operation),
				(0xFF as UInt8, (cycles: 8, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RST_n")
					cpu.RST_n(n: 0x38)
				}) as Operation),
	//			MARK: Rotates
				(0x07 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RLCA")
					cpu.RLCA()
				}) as Operation),
				(0x0F as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RRCA")
					cpu.RRCA()
				}) as Operation),
				(0x17 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RLA")
					cpu.RL_n(n: .A)
				}) as Operation),
				(0x1F as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RR_A")
					cpu.RR_n(n: .A)
				}) as Operation),
	//			MARK: Returns
				(0xC9 as UInt8, (cycles: 2, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RET")
					cpu.RET()
				}) as Operation),
				(0xC0 as UInt8, (cycles: 2, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RET_cc")
					cpu.RET_cc(flag: .Z, state: false)
				}) as Operation),
				(0xC8 as UInt8, (cycles: 2, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RET_cc")
					cpu.RET_cc(flag: .Z, state: true)
				}) as Operation),
				(0xD0 as UInt8, (cycles: 2, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RET_cc")
					cpu.RET_cc(flag: .C, state: false)
				}) as Operation),
				(0xD8 as UInt8, (cycles: 2, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RET_cc")
					cpu.RET_cc(flag: .C, state: true)
				}) as Operation),
				(0xD9 as UInt8, (cycles: 2, pc: 0, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RETI")
					cpu.RETI()
				}) as Operation)
			])
		}
}

protocol Misc {
	// - MARK: MISC
	func NOP() // checked
	func STOP() // checked
	func CPL() // checked
	func DI()
}

protocol Load {	
	// - MARK: 8-Bit LOADS
	func LD_nn_n(n: UInt8, nn: RegisterMap.single) // checked
	func LD(r1: RegisterMap.single, r2: RegisterMap.single) // checked
	
	func LDHL(r1: RegisterMap.single) // checked
	func LDHL(r2: UInt8) // checked
	func LDHL(n: UInt8) // checked
	
	func LD_A_n(n: RegisterMap.single) //checked
	func LD_A_n(n: UInt8) //checked
	func LD_A_r(r: UInt8) //checked
	func LD_A_n(nn: UInt8) //checked
	
	func LD_n_A(n: UInt16) //checked
	
	func LD_A_C() //checked
	func LD_C_A() //checked
	
	func LDD_A_HL() //checked
	func LDD_HL_A() //checked
	func LDI_A_HL() //checked
	func LDI_HL_A() //checked
	func LDH_n_A(n: UInt8) //checked
	func LDH_A_n(n: UInt8) //checked
	
	// - MARK: 16-Bit LOADS
	func LD_n_nn(n: RegisterMap.combined, nn: UInt16) //checked
	func LD_SP_HL() //checked
	func LD_nn_SP(nn: UInt16) //checked
	func PUSH_nn(nn: UInt16) //checked
	func POP_nn(nn: RegisterMap.combined) //checked
}

protocol ALU {
	// - MARK: 8-Bit ALU
	func ADD_A_n(n: UInt8) //checked
	func ADC_A_n(n: UInt8) //checked
	func ADC_A_r(n: RegisterMap.single) //checked
	func ADC_A_HL() //checked
	func SUB_n(n: UInt8) //checked
	func SUB_n(n: RegisterMap.single) //checked
	func SUB_HL() //checked
	func SBC_A_n(n: UInt8)
	func AND_n(n: UInt8) //checked
	func OR_n(n: UInt8) //checked
	func XOR_n(n: UInt8) //checked
	func CP_n(n: UInt8) //checked
	func INC_n(n: RegisterMap.single) //checked
	func INC_HL() //checked
	func DEC_n(n: RegisterMap.single) //checked
	func DEC_HL() //checked
	
	// - MARK: 16-Bit ALU
	func INC_n(n: RegisterMap.combined) //checked
	func DEC_n(n: RegisterMap.combined) //checked
	
	func LDHL_SP_n(n: UInt8) //checked
	
	func ADD_HL_n(n: UInt16) //checked
}

protocol Bit {
	// - MARK: BIT
	func SET_b_r(b: Int, r: RegisterMap.single) //checked
	func SET_b_HL(b: Int) //checked
	
	func BIT_b_r(b: Int, r: UInt8) //checked
	
	func RES_b_r(b: Int, r: RegisterMap.single) //checked
	func RES_b_HL(b: Int) //checked
}

protocol Rotates {
	// - MARK: ROTATES
	func RRCA() //checked
	func RLCA() //checked
	func RL_n(n: RegisterMap.single) //checked
	func RR_n(n: RegisterMap.single) //checked
	func RL_HL() //checked
	func RR_HL() //checked
}

protocol Jumps {
	// - MARK: JUMPS
	func JP_nn(nn: UInt16) //checked
	func JR_n(n: UInt8) //checked
	func JP_HL() //checked
	func JR_cc_n(flag: Flag, n: UInt8, state: Bool) //checked
	func JR_cc_nn(flag: Flag, nn: UInt16, state: Bool) //checked
}

protocol Calls {
	// - MARK: CALLS
	func CALL_nn(nn: UInt16) //checked
	func CALL_cc_nn(flag: Flag, nn: UInt16, state: Bool) //checked
}

protocol Restarts {
	// - MARK: RESTARTS
	func RST_n(n: UInt8) //checked
}

protocol Returns {
	// - MARK: RETURNS
	func RET() //checked
	func RET_cc(flag: Flag, state: Bool) //checked
	func RETI() //checked
}
