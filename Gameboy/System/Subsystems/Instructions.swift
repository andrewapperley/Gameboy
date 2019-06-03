//
//  Instructions.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-26.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

protocol Load {	
	// - MARK: 8-Bit LOADS
	func LD_nn_n(nn: UInt8, n: RegisterMap.single)
	func LD(r1: RegisterMap.single, r2: RegisterMap.single)
	func LD(r1: RegisterMap.single, r2: RegisterMap.combined)
	func LD(r1: RegisterMap.combined, r2: RegisterMap.single)
	func LD_A_n(n: UInt8)
	func LD_A_n(n: UInt16)
	func LD_n_A(n: RegisterMap.single)
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
	func POP_nn(nn: UInt16)
}

protocol ALU {
	// - MARK: 8-Bit ALU
	func ADD_A_n(n: UInt8)
	func ADDC_A_n(n: UInt8)
	func SUB_n(n: UInt8)
	func SBC_A_n(n: UInt8)
	func AND_n(n: UInt8)
	func OR_n(n: UInt8)
	func XOR_n(n: UInt8)
	func CP_n(n: UInt8)
	func INC_n(n: UInt8)
	func DEC_n(n: UInt8)
	
	// - MARK: 16-Bit ALU
}
