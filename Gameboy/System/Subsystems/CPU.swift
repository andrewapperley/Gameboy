//
//  CPU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-23.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

class Registers {
	var A: UInt8 = 0x0
	var F: UInt8 = 0x0
	var B: UInt8 = 0x0
	var C: UInt8 = 0x0
	var D: UInt8 = 0x0
	var E: UInt8 = 0x0
	var H: UInt8 = 0x0
	var L: UInt8 = 0x0
	var SP: UInt16 = 0xFFFE
	var PC: UInt16 = 0x0100
	
	var AF: UInt16 { return UInt16((A << 8) | F) }
	var BC: UInt16 { return UInt16((B << 8) | C) }
	var DE: UInt16 { return UInt16((D << 8) | E) }
	var HL: UInt16 { return UInt16((H << 8) | L) }
}

class CPU {
	var registers: Registers = Registers()
	var memory: MMU = MMU()
	
	func start() {
		reset()
		guard
			let boot = readBootROM(),
			let rom = readROM(name: "game") else { return }

		memory.rom = boot
		memory.write(location: MemoryMap.ROM_0, data: rom)
	}
	
	func readBootROM() -> Data? {
		return readFile(name: "dmg_boot", ext: "bin")
	}
	
	func readROM(name: String) -> Data? {
		return readFile(name: name, ext: "gb")
	}
	
	private func readFile(name: String, ext: String) -> Data? {
		guard
			let path = Bundle.main.path(forResource: name, ofType: ext),
			let data = FileManager().contents(atPath: path)
			else {
				return nil
		}
		return data
	}
	
	private func reset() {
		registers = Registers()
		memory.reset()
	}
}
