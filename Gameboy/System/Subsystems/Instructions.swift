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
	func STOP()
	func CPL()
}

protocol Load {	
	// - MARK: 8-Bit LOADS
	func LD_nn_n(n: UInt8, nn: RegisterMap.single)
	func LD(r1: RegisterMap.single, r2: RegisterMap.single)
	
	func LDHL(r1: RegisterMap.single)
	func LDHL(r2: UInt8)
	func LDHL(n: UInt8)
	
	func LD_A_n(n: RegisterMap.single)
	func LD_A_n(n: UInt8)
	func LD_A_r(r: UInt8)
	func LD_A_n(nn: UInt8)
	
	func LD_n_A(n: RegisterMap.single)
	func LD_n_A(n: UInt16)
	
	func LD_A_C()
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
	func LDHL_SP_n(n: UInt8)
	func LD_nn_SP(nn: UInt16)
	func PUSH_nn(nn: UInt16)
	func POP_nn(nn: RegisterMap.combined)
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
	func CP_nn(nn: UInt8)
	func INC_n(n: RegisterMap.single)
	func DEC_n(n: RegisterMap.single)
	
	// - MARK: 16-Bit ALU
	func INC_n(n: RegisterMap.combined)
	func DEC_n(n: RegisterMap.combined)
	
	func ADD_HL_n(n: UInt16)
}

protocol Bit {
	func SET_b_r(b: Int, r: RegisterMap.single)
	func SET_b_HL(b: Int)
	
	func BIT_b_r(b: Int, r: UInt8)
	
	func RES_b_r(b: Int, r: RegisterMap.single)
	func RES_b_HL(b: Int)
}

protocol Rotates {
	func RRCA()
	func RLCA()
	func RLA()
	func RRA()
	func RL_n(n: RegisterMap.single)
	func RL_HL()
}

protocol Jumps {
	func JP_nn(nn: UInt16)
	func JR_n(n: UInt8)
	func JP_HL()
	func JR_cc_n(flag: Flag, n: UInt8, state: Bool)
}

protocol Calls {
	func CALL_nn(nn: UInt16)
	func CALL_cc_nn(flag: Flag, nn: UInt16, state: Bool)
}

protocol Restarts {
	func RST_n(n: UInt8)
}

protocol Returns {
	func RET()
}
