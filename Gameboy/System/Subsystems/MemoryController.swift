//
//  MemoryController.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-04.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

protocol MemoryController {
	func read(address: UInt16) -> UInt8
	func write(address: UInt16, data: UInt8)
}

class MBC: MemoryController {
	var memory: [UInt8]
	
	init(memory: [UInt8]) {
		self.memory = memory
	}
	
	func read(address: UInt16) -> UInt8 {
		fatalError("Must subclass MBC")
	}
	
	func write(address: UInt16, data: UInt8) {
		fatalError("Must subclass MBC")
	}
}

class MBC1: MBC {
	
	override func read(address: UInt16) -> UInt8 {
		return memory[Int(address)]
	}
	
	override func write(address: UInt16, data: UInt8) {
		memory[Int(address)] = data
	}
}
