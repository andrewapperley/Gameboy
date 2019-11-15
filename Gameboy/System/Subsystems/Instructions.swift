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
	static func generateInstructionLookupTable() -> InstructionLookupTable
}

typealias InstructionLookupTable = Dictionary<UInt8, (CPU, UInt8) -> Void>
typealias InnerInstructionLookupTable = Dictionary<UInt8, (CPU, UInt8, UInt8) -> Void>

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
	
	func LD_n_A(n: RegisterMap.single) //checked
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
