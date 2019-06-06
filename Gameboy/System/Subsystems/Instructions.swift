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

protocol Misc {
	func NOP()
}

protocol Load {	
	// - MARK: 8-Bit LOADS
	func LD_nn_n(nn: UInt8, n: RegisterMap.single)
	func LD(r1: RegisterMap.single, r2: RegisterMap.single)
	func LD(r1: RegisterMap.single, r2: RegisterMap.combined)
	func LD(r1: RegisterMap.combined, r2: RegisterMap.single)
	func LD_A_n(n: UInt8)
	func LD_A_n(nn: UInt16)
	func LD_n_A(n: UInt16)
	func LD_C_A()
	func LDD_A_HL()
	func LDD_HL_A()
	func LDI_A_HL()
	func LDI_HL_A()
	func LDH_n_A(n: UInt8)
	func LDH_A_n(n: UInt8)
	
	// - MARK: 16-Bit LOADS
	func LD_n_nn(n: RegisterMap.combined, nn: UInt16)
	func LD_SP_HL()
	func LDHL_SP_n(n: Int8)
	func LD_nn_SP(nn: UInt16)
	func PUSH_nn(nn: UInt16)
	func POP_nn(nn: RegisterMap.combined)
}

protocol ALU {
	// - MARK: 8-Bit ALU
	func ADD_A_n(n: RegisterMap.single)
	func ADD_A_n(n: RegisterMap.combined) // For adding HL register
	func ADDC_A_n(n: RegisterMap.single)
	func SUB_n(n: RegisterMap.single)
	func SUB_n(n: RegisterMap.combined) // For subtracting HL register
	func SBC_A_n(n: RegisterMap.single)
	func AND_n(n: RegisterMap.single)
	func AND_n(n: RegisterMap.combined)
	func OR_n(n: RegisterMap.single)
	func OR_n(n: RegisterMap.combined)
	func XOR_n(n: RegisterMap.single)
	func XOR_n(n: RegisterMap.combined)
	func CP_n(n: RegisterMap.single)
	func CP_n(n: RegisterMap.combined)
	func INC_n(n: RegisterMap.single)
	func INC_n(n: RegisterMap.combined)
	func DEC_n(n: RegisterMap.single)
	func DEC_n(n: RegisterMap.combined)
	
	// - MARK: 16-Bit ALU
}

protocol Jumps {
	func JP_nn(nn: UInt16)
}

protocol Restarts {
	func RST_n(n: UInt8)
}
