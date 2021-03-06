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

	static func generateInnerInstructionLookupTable() -> InstructionLookupTable {
			return InstructionLookupTable(uniqueKeysWithValues: [
	//			MARK: Misc
	//			MARK: SWAP
	//			MARK: -
				(0x37 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SWAP_A")
					cpu.SWAP(n: &cpu.registers.A)
				}) as Operation),
				(0x30 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SWAP_B")
					cpu.SWAP(n: &cpu.registers.B)
				}) as Operation),
				(0x31 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SWAP_C")
					cpu.SWAP(n: &cpu.registers.C)
				}) as Operation),
				(0x32 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SWAP_D")
					cpu.SWAP(n: &cpu.registers.D)
				}) as Operation),
				(0x33 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SWAP_E")
					cpu.SWAP(n: &cpu.registers.E)
				}) as Operation),
				(0x34 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SWAP_H")
					cpu.SWAP(n: &cpu.registers.H)
				}) as Operation),
				(0x35 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SWAP_L")
					cpu.SWAP(n: &cpu.registers.L)
				}) as Operation),
				(0x36 as UInt8, (cycles: 4, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "SWAP_(HL)")
					var param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.SWAP(n: &param)
					cpu.memory.write(address: cpu.registers.HL, data: param)
				}) as Operation),
	//			MARK: Rotates & Shifts
	//			MARK: RLC n
	//			MARK: -
				(0x07 as UInt8, (cycles:2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RLC_A")
					cpu.RLC_n(n: &cpu.registers.A)
				}) as Operation),
				(0x00 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RLC_B")
					cpu.RLC_n(n: &cpu.registers.B)
				}) as Operation),
				(0x01 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RLC_C")
					cpu.RLC_n(n: &cpu.registers.C)
				}) as Operation),
				(0x02 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RLC_D")
					cpu.RLC_n(n: &cpu.registers.D)
				}) as Operation),
				(0x03 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RLC_E")
					cpu.RLC_n(n: &cpu.registers.E)
				}) as Operation),
				(0x04 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RLC_H")
					cpu.RLC_n(n: &cpu.registers.H)
				}) as Operation),
				(0x05 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RLC_L")
					cpu.RLC_n(n: &cpu.registers.L)
				}) as Operation),
				(0x06 as UInt8, (cycles: 4, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RLC_(HL)")
					var param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.RLC_n(n: &param)
					cpu.memory.write(address: cpu.registers.HL, data: param)
				}) as Operation),
	//			MARK: RL n
	//			MARK: -
				(0x17 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_A")
					cpu.RL_n(n: &cpu.registers.A)
				}) as Operation),
				(0x10 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_B")
					cpu.RL_n(n: &cpu.registers.B)
				}) as Operation),
				(0x11 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_C")
					cpu.RL_n(n: &cpu.registers.C)
				}) as Operation),
				(0x12 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_D")
					cpu.RL_n(n: &cpu.registers.D)
				}) as Operation),
				(0x13 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_E")
					cpu.RL_n(n: &cpu.registers.E)
				}) as Operation),
				(0x14 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_L")
					cpu.RL_n(n: &cpu.registers.L)
				}) as Operation),
				(0x15 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_H")
					cpu.RL_n(n: &cpu.registers.H)
				}) as Operation),
				(0x16 as UInt8, (cycles: 4, pc: 2, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RL_(HL)")
					cpu.RL_HL()
				}) as Operation),
	//			MARK: RRC n
	//			MARK: -
				(0x0F as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RRC_A")
					cpu.RRCA()
				}) as Operation),
				(0x08 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RRC_B")
					cpu.RRC_n(n: &cpu.registers.B)
				}) as Operation),
				(0x09 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RRC_C")
					cpu.RRC_n(n: &cpu.registers.C)
				}) as Operation),
				(0x0A as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RRC_D")
					cpu.RRC_n(n: &cpu.registers.D)
				}) as Operation),
				(0x0B as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RRC_E")
					cpu.RRC_n(n: &cpu.registers.E)
				}) as Operation),
				(0x0C as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RRC_H")
					cpu.RRC_n(n: &cpu.registers.H)
				}) as Operation),
				(0x0D as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RRC_L")
					cpu.RRC_n(n: &cpu.registers.L)
				}) as Operation),
				(0x0E as UInt8, (cycles: 4, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RR_(HL)")
					var param = cpu.memory.readHalf(address: cpu.registers.HL)
					cpu.RRC_n(n: &param)
					cpu.memory.write(address: cpu.registers.HL, data: param)
				}) as Operation),
	//			MARK: RR n
	//			MARK: -
				(0x1F as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RR_A")
					cpu.RR_n(n: &cpu.registers.A)
				}) as Operation),
				(0x18 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RR_B")
					cpu.RR_n(n: &cpu.registers.B)
				}) as Operation),
				(0x19 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RR_C")
					cpu.RR_n(n: &cpu.registers.C)
				}) as Operation),
				(0x1A as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RR_D")
					cpu.RR_n(n: &cpu.registers.D)
				}) as Operation),
				(0x1B as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RR_E")
					cpu.RR_n(n: &cpu.registers.E)
				}) as Operation),
				(0x1C as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RR_H")
					cpu.RR_n(n: &cpu.registers.H)
				}) as Operation),
				(0x1D as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RR_L")
					cpu.RR_n(n: &cpu.registers.L)
				}) as Operation),
				(0x1E as UInt8, (cycles: 4, pc: 1, { (cpu, code) in
					cpu.opCodePrint(code: code, func: "RR_(HL)")
					cpu.RR_HL()
				}) as Operation),
	//			MARK: SLA n
	//			MARK: -
	//			MARK: SRA n
	//			MARK: -
	//			MARK: SRL n
	//			MARK: -
	//			MARK: Bits : Bit 0
	//			MARK: -
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
	//			MARK: -
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
	//			MARK: -
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
	//			MARK: -
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
	//			MARK: -
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
	//			MARK: -
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
	//			MARK: -
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
	//			MARK: -
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
	//			MARK: SET BIT
	//			MARK: -
	//			MARK: RESET BIT
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
						(0xFB as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "EI")
							cpu.EI()
						}) as Operation),
						(0x3F as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "CCF")
							cpu.CCF()
						}) as Operation),
			//			MARK: 8-bit Loads
			//			MARK: -
			//			MARK: LD nn,n
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
			//			MARK: -
			//			MARK: LD A,r2
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
						(0x3E as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_A_n")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.LD_nn_n(n: param, nn: .A)
						}) as Operation),
			//			MARK: -
			//			MARK: LD B,r2
						(0x40 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_B_B")
							cpu.LD(r1: .B, r2: .B)
						}) as Operation),
						(0x41 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_B_C")
							cpu.LD(r1: .B, r2: .C)
						}) as Operation),
						(0x42 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_B_D")
							cpu.LD(r1: .B, r2: .D)
						}) as Operation),
						(0x43 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_B_E")
							cpu.LD(r1: .B, r2: .E)
						}) as Operation),
						(0x44 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_B_H")
							cpu.LD(r1: .B, r2: .H)
						}) as Operation),
						(0x45 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_B_L")
							cpu.LD(r1: .B, r2: .L)
						}) as Operation),
						(0x46 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_B_(HL)")
							let param = cpu.memory.readHalf(address: cpu.registers.HL)
							cpu.LD_nn_n(n: param, nn: .B)
						}) as Operation),
			//			MARK: -
			//			MARK: LD C,r2
						(0x48 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_C_B")
							cpu.LD(r1: .C, r2: .B)
						}) as Operation),
						(0x49 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_C_C")
							cpu.LD(r1: .C, r2: .C)
						}) as Operation),
						(0x4A as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_C_D")
							cpu.LD(r1: .C, r2: .D)
						}) as Operation),
						(0x4B as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_C_E")
							cpu.LD(r1: .C, r2: .E)
						}) as Operation),
						(0x4C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_C_H")
							cpu.LD(r1: .C, r2: .H)
						}) as Operation),
						(0x4D as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_C_L")
							cpu.LD(r1: .C, r2: .L)
						}) as Operation),
						(0x4E as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_C_(HL)")
							let param = cpu.memory.readHalf(address: cpu.registers.HL)
							cpu.LD_nn_n(n: param, nn: .C)
						}) as Operation),
			//			MARK: -
			//			MARK: LD D,r2
						(0x50 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_D_B")
							cpu.LD(r1: .D, r2: .B)
						}) as Operation),
						(0x51 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_D_C")
							cpu.LD(r1: .D, r2: .C)
						}) as Operation),
						(0x52 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_D_D")
							cpu.LD(r1: .D, r2: .D)
						}) as Operation),
						(0x53 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_D_E")
							cpu.LD(r1: .D, r2: .E)
						}) as Operation),
						(0x54 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_D_H")
							cpu.LD(r1: .D, r2: .H)
						}) as Operation),
						(0x55 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_D_L")
							cpu.LD(r1: .D, r2: .L)
						}) as Operation),
						(0x56 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_D_(HL)")
							let param = cpu.memory.readHalf(address: cpu.registers.HL)
							cpu.LD_nn_n(n: param, nn: .D)
						}) as Operation),
			//			MARK: -
			//			MARK: LD E,r2
						(0x58 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_E_B")
							cpu.LD(r1: .E, r2: .B)
						}) as Operation),
						(0x59 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_E_C")
							cpu.LD(r1: .E, r2: .C)
						}) as Operation),
						(0x5A as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_E_D")
							cpu.LD(r1: .E, r2: .D)
						}) as Operation),
						(0x5B as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_E_E")
							cpu.LD(r1: .E, r2: .E)
						}) as Operation),
						(0x5C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_D_H")
							cpu.LD(r1: .E, r2: .H)
						}) as Operation),
						(0x5D as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_E_L")
							cpu.LD(r1: .E, r2: .L)
						}) as Operation),
						(0x5E as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_E_(HL)")
							let param = cpu.memory.readHalf(address: cpu.registers.HL)
							cpu.LD_nn_n(n: param, nn: .E)
						}) as Operation),
			//			MARK: -
			//			MARK: LD H,r2
						(0x60 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_H_B")
							cpu.LD(r1: .H, r2: .B)
						}) as Operation),
						(0x61 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_H_C")
							cpu.LD(r1: .H, r2: .C)
						}) as Operation),
						(0x62 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_H_D")
							cpu.LD(r1: .H, r2: .D)
						}) as Operation),
						(0x63 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_H_E")
							cpu.LD(r1: .H, r2: .E)
						}) as Operation),
						(0x64 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_H_H")
							cpu.LD(r1: .H, r2: .H)
						}) as Operation),
						(0x65 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_H_L")
							cpu.LD(r1: .H, r2: .L)
						}) as Operation),
						(0x66 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_H_(HL)")
							let param = cpu.memory.readHalf(address: cpu.registers.HL)
							cpu.LD_nn_n(n: param, nn: .H)
						}) as Operation),
			//			MARK: -
			//			MARK: LD L,r2
						(0x68 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_L_B")
							cpu.LD(r1: .L, r2: .B)
						}) as Operation),
						(0x69 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_L_C")
							cpu.LD(r1: .L, r2: .C)
						}) as Operation),
						(0x6A as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_L_D")
							cpu.LD(r1: .L, r2: .D)
						}) as Operation),
						(0x6B as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_L_E")
							cpu.LD(r1: .L, r2: .E)
						}) as Operation),
						(0x6C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_L_H")
							cpu.LD(r1: .L, r2: .H)
						}) as Operation),
						(0x6D as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_L_L")
							cpu.LD(r1: .L, r2: .L)
						}) as Operation),
						(0x6E as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_L_(HL)")
							let param = cpu.memory.readHalf(address: cpu.registers.HL)
							cpu.LD_nn_n(n: param, nn: .L)
						}) as Operation),
			//			MARK: -
			//			MARK: LD (HL),r2
						(0x70 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_(HL)_B")
							cpu.LDHL(r2: cpu.registers.B)
						}) as Operation),
						(0x71 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_(HL)_C")
							cpu.LDHL(r2: cpu.registers.C)
						}) as Operation),
						(0x72 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_(HL)_D")
							cpu.LDHL(r2: cpu.registers.D)
						}) as Operation),
						(0x73 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_(HL)_E")
							cpu.LDHL(r2: cpu.registers.E)
						}) as Operation),
						(0x74 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_(HL)_H")
							cpu.LDHL(r2: cpu.registers.H)
						}) as Operation),
						(0x75 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_(HL)_L")
							cpu.LDHL(r2: cpu.registers.L)
						}) as Operation),
						(0x36 as UInt8, (cycles: 3, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_(HL)_n")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.LDHL(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: LD n,A
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
			//			MARK: -
			//			MARK: LD A,(C)
						(0xF2 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_A_(C)")
							cpu.LD_C_A()
						}) as Operation),
			//			MARK: -
			//			MARK: LD (C),A
						(0xE2 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_(C)_A")
							cpu.LD_A_C()
						}) as Operation),
			//			MARK: -
			//			MARK: LDD A,(HL)
						(0x3A as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LDD_A_(HL)")
							cpu.LDD_A_HL()
						}) as Operation),
			//			MARK: -
			//			MARK: LDD (HL),A
						(0x32 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LDD_HL_A")
							cpu.LDD_HL_A()
						}) as Operation),
			//			MARK: -
			//			MARK: LDI A,(HL)
						(0x2A as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LDI_A_HL")
							cpu.LDI_A_HL()
						}) as Operation),
			//			MARK: -
			//			MARK: LDI (HL),A
						(0x22 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LDI_HL_A")
							cpu.LDI_HL_A()
						}) as Operation),
			//			MARK: -
			//			MARK: LDH (n),A
						(0xE0 as UInt8, (cycles: 3, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LDH_(n)_A")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.LDH_n_A(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: LDH A,(n)
						(0xF0 as UInt8, (cycles: 3, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LDH_A_(n)")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.LDH_A_n(n: param)
						}) as Operation),
			//			MARK: 16-bit Loads
			//			MARK: -
			//			MARK: LD n,nn
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
			//			MARK: -
			//			MARK: LD SP,HL
						(0xF9 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_SP_HL")
							cpu.LD_SP_HL()
						}) as Operation),
			//			MARK: -
			//			MARK: LDHL SP,n
						(0xF8 as UInt8, (cycles: 3, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LDHL_SP_n")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.LDHL_SP_n(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: LD (nn),SP
						(0x08 as UInt8, (cycles: 5, pc: 3, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "LD_(nn)_SP")
							let param = cpu.memory.readFull(address: cpu.registers.PC+1)
							cpu.LD_nn_SP(nn: param)
						}) as Operation),
			//			MARK: -
			//			MARK: 8-Bit ALU
			//			MARK: -
			//			MARK: ADD A,n
						(0x87 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADD_A_A")
							cpu.ADD_A_n(n: cpu.registers.A)
						}) as Operation),
						(0x80 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADD_A_B")
							cpu.ADD_A_n(n: cpu.registers.B)
						}) as Operation),
						(0x81 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADD_A_C")
							cpu.ADD_A_n(n: cpu.registers.C)
						}) as Operation),
						(0x82 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADD_A_D")
							cpu.ADD_A_n(n: cpu.registers.D)
						}) as Operation),
						(0x83 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADD_A_E")
							cpu.ADD_A_n(n: cpu.registers.E)
						}) as Operation),
						(0x84 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADD_A_H")
							cpu.ADD_A_n(n: cpu.registers.H)
						}) as Operation),
						(0x85 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADD_A_L")
							cpu.ADD_A_n(n: cpu.registers.L)
						}) as Operation),
						(0x86 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADD_A_(HL)")
							let param = cpu.memory.readHalf(address: cpu.registers.HL)
							cpu.ADD_A_n(n: param)
						}) as Operation),
						(0xC6 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADD_A_#")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.ADD_A_n(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: ADC A,n
						(0x8F as UInt8, (cycles: 1, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADC_A_A")
							cpu.ADC_A_n(n: cpu.registers.A)
						}) as Operation),
						(0x88 as UInt8, (cycles: 1, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADC_A_B")
							cpu.ADC_A_n(n: cpu.registers.B)
						}) as Operation),
						(0x89 as UInt8, (cycles: 1, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADC_A_C")
							cpu.ADC_A_n(n: cpu.registers.C)
						}) as Operation),
						(0x8A as UInt8, (cycles: 1, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADC_A_D")
							cpu.ADC_A_n(n: cpu.registers.D)
						}) as Operation),
						(0x8B as UInt8, (cycles: 1, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADC_A_E")
							cpu.ADC_A_n(n: cpu.registers.E)
						}) as Operation),
						(0x8C as UInt8, (cycles: 1, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADC_A_H")
							cpu.ADC_A_n(n: cpu.registers.H)
						}) as Operation),
						(0x8D as UInt8, (cycles: 1, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADC_A_L")
							cpu.ADC_A_n(n: cpu.registers.L)
						}) as Operation),
						(0x8E as UInt8, (cycles: 1, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADC_A_(HL)")
							cpu.ADC_A_HL()
						}) as Operation),
						(0xCE as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADC_A_#")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.ADC_A_n(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: SUB n
						(0x97 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "SUB_A_A")
							cpu.SUB_n(n: .A)
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
						(0xD6 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "SUB_#_A")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.SUB_n(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: SBC A,n
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
			//			MARK: -
			//			MARK: AND n
						(0xA7 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "AND_A")
							cpu.AND_n(n: cpu.registers.A)
						}) as Operation),
						(0xA0 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "AND_B")
							cpu.AND_n(n: cpu.registers.B)
						}) as Operation),
						(0xA1 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "AND_C")
							cpu.AND_n(n: cpu.registers.C)
						}) as Operation),
						(0xA2 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "AND_D")
							cpu.AND_n(n: cpu.registers.D)
						}) as Operation),
						(0xA3 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "AND_E")
							cpu.AND_n(n: cpu.registers.E)
						}) as Operation),
						(0xA4 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "AND_H")
							cpu.AND_n(n: cpu.registers.H)
						}) as Operation),
						(0xA5 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "AND_L")
							cpu.AND_n(n: cpu.registers.L)
						}) as Operation),
						(0xA6 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "AND_(HL)")
							let param = cpu.memory.readHalf(address: cpu.registers.HL)
							cpu.AND_n(n: param)
						}) as Operation),
						(0xE6 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "AND_#")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.AND_n(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: OR n
						(0xB7 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "OR_A")
							cpu.OR_n(n: cpu.registers.A)
						}) as Operation),
						(0xB0 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "OR_B")
							cpu.OR_n(n: cpu.registers.B)
						}) as Operation),
						(0xB1 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "OR_C")
							cpu.OR_n(n: cpu.registers.C)
						}) as Operation),
						(0xB2 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "OR_D")
							cpu.OR_n(n: cpu.registers.D)
						}) as Operation),
						(0xB3 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "OR_E")
							cpu.OR_n(n: cpu.registers.E)
						}) as Operation),
						(0xB4 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "OR_H")
							cpu.OR_n(n: cpu.registers.H)
						}) as Operation),
						(0xB5 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "OR_L")
							cpu.OR_n(n: cpu.registers.L)
						}) as Operation),
						(0xB6 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "OR_(HL)")
							let param = cpu.memory.readHalf(address: cpu.registers.HL)
							cpu.OR_n(n: param)
						}) as Operation),
						(0xF6 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "OR_#")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.OR_n(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: XOR n
						(0xAF as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "XOR_A")
							cpu.XOR_n(n: cpu.registers.A)
						}) as Operation),
						(0xA8 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "XOR_B")
							cpu.XOR_n(n: cpu.registers.B)
						}) as Operation),
						(0xA9 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "XOR_C")
							cpu.XOR_n(n: cpu.registers.C)
						}) as Operation),
						(0xAA as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "XOR_D")
							cpu.XOR_n(n: cpu.registers.D)
						}) as Operation),
						(0xAB as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "XOR_E")
							cpu.XOR_n(n: cpu.registers.E)
						}) as Operation),
						(0xAC as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "XOR_H")
							cpu.XOR_n(n: cpu.registers.H)
						}) as Operation),
						(0xAD as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "XOR_L")
							cpu.XOR_n(n: cpu.registers.L)
						}) as Operation),
						(0xAE as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "XOR_(HL)")
							let param = cpu.memory.readHalf(address: cpu.registers.HL)
							cpu.XOR_n(n: param)
						}) as Operation),
						(0xEE as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "XOR_#")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.XOR_n(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: CP n
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
							cpu.opCodePrint(code: code, func: "CP_(HL)")
							let param = cpu.memory.readHalf(address: cpu.registers.HL)
							cpu.CP_HL(n: param)
						}) as Operation),
						(0xFE as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "CP_#")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.CP_n(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: INC n
						(0x3C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_A")
							cpu.INC_n(n: .A)
						}) as Operation),
						(0x04 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_B")
							cpu.INC_n(n: .B)
						}) as Operation),
						(0x0C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_C")
							cpu.INC_n(n: .C)
						}) as Operation),
						(0x14 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_D")
							cpu.INC_n(n: .D)
						}) as Operation),
						(0x1C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_E")
							cpu.INC_n(n: .E)
						}) as Operation),
						(0x24 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_H")
							cpu.INC_n(n: .H)
						}) as Operation),
						(0x2C as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_L")
							cpu.INC_n(n: .L)
						}) as Operation),
						(0x34 as UInt8, (cycles: 3, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_(HL)")
							cpu.INC_HL()
						}) as Operation),
			//			MARK: -
			//			MARK: DEC n
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
							cpu.opCodePrint(code: code, func: "DEC_(HL)")
							cpu.DEC_HL()
						}) as Operation),
			//			MARK: -
			//			MARK: 16-Bit ALU
			//			MARK: ADD HL,n
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
			//			MARK: -
			//			MARK: ADD SP,n
						(0xE8 as UInt8, (cycles: 4, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "ADD_SP_#")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.ADD_SP_n(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: INC nn
						(0x03 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_BC")
							cpu.INC_n(n: .BC)
						}) as Operation),
						(0x13 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_DE")
							cpu.INC_n(n: .DE)
						}) as Operation),
						(0x23 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_HL")
							cpu.INC_n(n: .HL)
						}) as Operation),
						(0x33 as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "INC_SP")
							cpu.INC_n(n: .SP)
						}) as Operation),
			//			MARK: -
			//			MARK: DEC nn
						(0x0B as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "DEC_BC")
							cpu.DEC_n(n: .BC)
						}) as Operation),
						(0x1B as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "DEC_DE")
							cpu.DEC_n(n: .DE)
						}) as Operation),
						(0x2B as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "DEC_HL")
							cpu.DEC_n(n: .HL)
						}) as Operation),
						(0x3B as UInt8, (cycles: 2, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "DEC_SP")
							cpu.DEC_n(n: .SP)
						}) as Operation),
			//			MARK: -
			//			MARK: PUSH nn
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
			//			MARK: -
			//			MARK: POP nn
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
			//			MARK: Rotates & Shifts
			//			MARK: -
			//			MARK: RLCA
						(0x07 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "RLCA")
							cpu.RLCA()
						}) as Operation),
			//			MARK: -
			//			MARK: RLA
						(0x17 as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "RLA")
							cpu.RL_n(n: &cpu.registers.A)
						}) as Operation),
			//			MARK: -
			//			MARK: RRCA
						(0x0F as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "RRCA")
							cpu.RRCA()
						}) as Operation),
			//			MARK: -
			//			MARK: RRA
						(0x1F as UInt8, (cycles: 1, pc: 1, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "RRA")
							cpu.RR_n(n: &cpu.registers.A)
						}) as Operation),
			//			MARK: -
			//			MARK: Jumps
			//			MARK: JP nn
						(0xC3 as UInt8, (cycles: 3, pc: 0, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "JP_nn")
							let param = cpu.memory.readFull(address: cpu.registers.PC+1)
							cpu.JP_nn(nn: param)
						}) as Operation),
			//			MARK: -
			//			MARK: JP cc,nn
						(0xC2 as UInt8, (cycles: 3, pc: 0, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "JR_cc_n")
							let param = cpu.memory.readFull(address: cpu.registers.PC+1)
							cpu.JR_cc_nn(flag: .Z, nn: param, state: false)
						}) as Operation),
						(0xCA as UInt8, (cycles: 3, pc: 0, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "JR_cc_n")
							let param = cpu.memory.readFull(address: cpu.registers.PC+1)
							cpu.JR_cc_nn(flag: .Z, nn: param, state: true)
						}) as Operation),
						(0xD2 as UInt8, (cycles: 3, pc: 0, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "JR_cc_n")
							let param = cpu.memory.readFull(address: cpu.registers.PC+1)
							cpu.JR_cc_nn(flag: .C, nn: param, state: false)
						}) as Operation),
						(0xDA as UInt8, (cycles: 3, pc: 0, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "JR_cc_n")
							let param = cpu.memory.readFull(address: cpu.registers.PC+1)
							cpu.JR_cc_nn(flag: .C, nn: param, state: true)
						}) as Operation),
			//			MARK: -
			//			MARK: JP (HL)
						(0xE9 as UInt8, (cycles: 1, pc: 0, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "JP_(HL)")
							cpu.JP_HL()
						}) as Operation),
			//			MARK: -
			//			MARK: JR n
						(0x18 as UInt8, (cycles: 2, pc: 2, { (cpu, code) in
							cpu.opCodePrint(code: code, func: "JR_n")
							let param = cpu.memory.readHalf(address: cpu.registers.PC+1)
							cpu.JR_n(n: param)
						}) as Operation),
			//			MARK: -
			//			MARK: JR cc,n
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
	func EI()
	func CCF()
	func DAA()
	func SCF()
	func HALT()
	func SWAP(n: inout UInt8) // checked
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
	func LDHL_SP_n(n: UInt8) //checked
	func LD_SP_HL() //checked
	func LD_nn_SP(nn: UInt16) //checked
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
	func PUSH_nn(nn: UInt16) //checked
	func POP_nn(nn: RegisterMap.combined) //checked
	
	// - MARK: 16-Bit ALU
	func INC_n(n: RegisterMap.combined) //checked
	func DEC_n(n: RegisterMap.combined) //checked
	func ADD_SP_n(n: UInt8)
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
	func RRC_n(n: inout UInt8) //checked
	func RLCA() //checked
	func RLC_n(n: inout UInt8) //checked
	func RL_n(n: inout UInt8) //checked
	func RR_n(n: inout UInt8) //checked
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
