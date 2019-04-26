//
//  Instructions.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-26.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

protocol Load {
	// Some OpCodes allow r2 to be a 16bit register...
	func LD(r1: UInt8, r2: UInt8)
	func LD_A_n(n: UInt8)
	func LD_n_A(n: UInt8)
	func LD_C_A()
	func LDD_A_HL()
	func LDD_HL_A()
}

protocol Read {
	
}
