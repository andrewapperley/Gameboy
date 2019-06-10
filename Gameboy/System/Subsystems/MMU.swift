//
//  MMU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-25.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

enum MemoryMap {
	static let BOOT_ROM = Range<UInt16>(0x0...0x0100)
	static let ROM_0 = Range<UInt16>(0x0100...0x3FFF)
	static let ROM_n = Range<UInt16>(0x4000...0x7FFF)
	static let VRAM = Range<UInt16>(0x8000...0x9FFF)
	static let ERAM = Range<UInt16>(0xA000...0xBFFF)
	static let WRAM_0 = Range<UInt16>(0xC000...0xCFFF)
	static let WRAM_n = Range<UInt16>(0xD000...0xDFFF)
	static let ECHO = Range<UInt16>(0xE000...0xFDFF)
	static let OAM = Range<UInt16>(0xFE00...0xFE9F)
	static let IO = Range<UInt16>(0xFF00...0xFF7F)
	static let HRAM = Range<UInt16>(0xFF80...0xFFFE)
	static let IER = 0xFFFF // Interrupt Enable Register
}

class MMU {
	private var biosActive = false
	private var memory: [UInt8] = Array<UInt8>(repeating: 0x0, count: 0xFFFF)
	
	func loadBios(_ bios: [UInt8]) {
		write(address: MemoryMap.BOOT_ROM.lowerBound, data: bios)
		self.biosActive = true
	}
	
	func loadRom(_ rom: [UInt8]) {
		write(address: MemoryMap.ROM_0.lowerBound, data: rom)
	}
	
	func readHalf(address: UInt16) -> UInt8 {
		return memory[Int(address)]
	}
	
	func readFull(address: UInt16) -> UInt16 {
		return UInt16(memory[Int(address)]) | UInt16(memory[Int(address+1)]) << 8
	}
	
	func write(address: UInt16, data: UInt8) {
		memory[Int(address)] = data
	}
	
	func write(address: UInt16, data: [UInt8]) {
		var ii: UInt16 = 0
		for i in data {
			memory[Int(address+ii)] = i
			ii += 1
		}
	}
	
	func write(address: UInt16, data: UInt16) {
		write(address: address, data: UInt8(data & 0xFF))
		write(address: address+1, data: UInt8(data >> 8))
	}
	
	func reset() {
		memory = Array<UInt8>(repeating: 0x0, count: 0xFFFF)
	}
	
	func toState() -> [UInt8] {
		return memory
	}
}
