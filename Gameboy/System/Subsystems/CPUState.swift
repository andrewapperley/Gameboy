//
//  CPUState.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-09.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

struct StateFlags {
	let Z: Int
	let N: Int
	let H: Int
	let C: Int
}

struct StateRegisters {
	let A: UInt8
	let F: UInt8
	let B: UInt8
	let C: UInt8
	let D: UInt8
	let E: UInt8
	let H: UInt8
	let L: UInt8
	let SP: UInt16
	let PC: UInt16
	let flags: StateFlags
}

struct CPUState {
	let registers: StateRegisters
	let memory: [UInt8]
}
