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
	func toState() -> [UInt8]
}

class MBC: MemoryController {
	var memory: [UInt8]!
	
	init(memory: [UInt8]) {}
	
	func read(address: UInt16) -> UInt8 {
		fatalError("Must subclass MBC")
	}
	
	func write(address: UInt16, data: UInt8) {
		fatalError("Must subclass MBC")
	}
	
	func toState() -> [UInt8] {
		return memory
	}
}

class MBC0: MBC {
	override init(memory: [UInt8]) {
		super.init(memory: memory)
		self.memory = [UInt8](repeating: UInt8(0), count: 0xC000)
//		Take max size of rom data and copy it to MBC0 memory data
		self.memory[0...0x7FFF] = memory[0...0x7FFF]
	}
	
	override func read(address: UInt16) -> UInt8 {
		return memory[Int(address)]
	}
	
	override func write(address: UInt16, data: UInt8) {
		if address > 0x8000 { return }
		memory[Int(address)] = data
	}
}

class MBC1: MBC {
	/*
		0000-3FFF - ROM Bank 00 (Read Only)
		This area always contains the first 16KBytes of the cartridge ROM.

		4000-7FFF - ROM Bank 01-7F (Read Only)
		This area may contain any of the further 16KByte banks of the ROM, allowing to address up to 125 ROM Banks (almost 2MByte). As described below, bank numbers 20h, 40h, and 60h cannot be used, resulting in the odd amount of 125 banks.

		A000-BFFF - RAM Bank 00-03, if any (Read/Write)
		This area is used to address external RAM in the cartridge (if any). External RAM is often battery buffered, allowing to store game positions or high score tables, even if the gameboy is turned off, or if the cartridge is removed from the gameboy. Available RAM sizes are: 2KByte (at A000-A7FF), 8KByte (at A000-BFFF), and 32KByte (in form of four 8K banks at A000-BFFF).

		0000-1FFF - RAM Enable (Write Only)
		Before external RAM can be read or written, it must be enabled by writing to this address space. It is recommended to disable external RAM after accessing it, in order to protect its contents from damage during power down of the gameboy. Usually the following values are used:
		  00h  Disable RAM (default)
		  0Ah  Enable RAM
		Practically any value with 0Ah in the lower 4 bits enables RAM, and any other value disables RAM.

		2000-3FFF - ROM Bank Number (Write Only)
		Writing to this address space selects the lower 5 bits of the ROM Bank Number (in range 01-1Fh). When 00h is written, the MBC translates that to bank 01h also. That doesn't harm so far, because ROM Bank 00h can be always directly accessed by reading from 0000-3FFF.
		But (when using the register below to specify the upper ROM Bank bits), the same happens for Bank 20h, 40h, and 60h. Any attempt to address these ROM Banks will select Bank 21h, 41h, and 61h instead.

		4000-5FFF - RAM Bank Number - or - Upper Bits of ROM Bank Number (Write Only) This 2bit register can be used to select a RAM Bank in range from 00-03h, or to specify the upper two bits (Bit 5-6) of the ROM Bank number, depending on the current ROM/RAM Mode. (See below.)

		6000-7FFF - ROM/RAM Mode Select (Write Only)
		This 1bit Register selects whether the two bits of the above register should be used as upper two bits of the ROM Bank, or as RAM Bank Number.
		  00h = ROM Banking Mode (up to 8KByte RAM, 2MByte ROM) (default)
		  01h = RAM Banking Mode (up to 32KByte RAM, 512KByte ROM)
		The program may freely switch between both modes, the only limitiation is that only RAM Bank 00h can be used during Mode 0, and only ROM Banks 00-1Fh can be used during Mode 1.
	**/
	override func read(address: UInt16) -> UInt8 {
		switch address {
		case 0x0000...0x3FFF: // ROM Bank 00 (Read Only)
			return memory[Int(address)]
		case 0x4000...0x7FFF: // ROM Bank 01-7F (Read Only)
			return memory[Int(address)]
		case 0xA000...0xBFFF: // RAM Bank 00-03, if any (Read/Write)
			return memory[Int(address)]
		default:
			print("Attempted to read out of MBC1 range")
			return UInt8(0)
		}
	}
	
	override func write(address: UInt16, data: UInt8) {
		switch address {
		case 0x0000...0x1FFF: // RAM Bank 00-03, if any (Read/Write)
			memory[Int(address)] = data
		case 0xA000...0xBFFF: // RAM Enable (Write Only)
			memory[Int(address)] = data
		case 0x2000...0x3FFF: // ROM Bank Number (Write Only)
			memory[Int(address)] = data
		case 0x4000...0x5FFF: // RAM Bank Number - or - Upper Bits of ROM Bank Number (Write Only)
			memory[Int(address)] = data
		case 0x6000...0x7FFF: // ROM/RAM Mode Select (Write Only)
			memory[Int(address)] = data
		default:
			print("Attempted to write out of MBC1 range")
		}
	}
}

class MBC2: MBC {
	
	override func read(address: UInt16) -> UInt8 {
		return memory[Int(address)]
	}
	
	override func write(address: UInt16, data: UInt8) {
		memory[Int(address)] = data
	}
}

class MBC3: MBC {
	
	override func read(address: UInt16) -> UInt8 {
		return memory[Int(address)]
	}
	
	override func write(address: UInt16, data: UInt8) {
		memory[Int(address)] = data
	}
}
