//
//  MMU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-25.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

enum MemoryMap {
	static let ECHO_RAM_OFFSET: UInt16 = 0x2000 // 0x2000 is the offset between echo ram and internal ram
	static let MEM_SIZE = 65536
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
	
	enum LCD {
		static let LCDC: UInt16 = 0xFF40 // LCD Control (R/W)
		static let STAT: UInt16 = 0xFF41 // LCDC Status (R/W)
		static let SCY: UInt16 = 0xFF42 //  Scroll Y (R/W)
		static let SCX: UInt16 = 0xFF43 //  Scroll X (R/W)
		static let LY: UInt16 = 0xFF44 //	LCDC Y-Coordinate (R)
		static let LYC: UInt16 = 0xFF45 //  LY Compare (R/W)
		static let DMA: UInt16 = 0xFF46 // 	DMA Transfer and Start Address (W)
		static let BGP: UInt16 = 0xFF47 //	BG Palette Data (R/W) - Non CGB Mode Only
		static let OBP0: UInt16 = 0xFF48 // Object Palette 0 Data (R/W) - Non CGB Mode Only
		static let OBP1: UInt16 = 0xFF49 //	Object Palette 1 Data (R/W) - Non CGB Mode Only
		static let WY: UInt16 = 0xFF4A //  	Window Y Position (R/W)
		static let WX: UInt16 = 0xFF4B //  	Window X Position minus 7 (R/W)
		static let TILES = Range<UInt16>(0x8800...0x97FF) // Tile Data
		static let SPT = Range<UInt16>(0x8000...0x8FFF) // Sprite Pattern Table
		static let BG_MAP_0 = Range<UInt16>(0x9800...0x9BFF) // First 32x32 BG Tile Map
		static let BG_MAP_1 = Range<UInt16>(0x9C00...0x9FFF) // Second 32x32 BG Tile Map
	}
	
	static let IF: UInt16 = 0xFF0F // IF – Interrupt Flag (R/W)
	static let HRAM = Range<UInt16>(0xFF80...0xFFFE)
	static let IER = 0xFFFF // Interrupt Enable Register
}

class MMU {
	var biosActive = false
	private var bios: [UInt8] = Array<UInt8>(repeating: 0x0, count: Int(MemoryMap.BOOT_ROM.upperBound))
	private var memory: [UInt8] = Array<UInt8>(repeating: 0x0, count: MemoryMap.MEM_SIZE)
	
	func loadBios(_ bios: [UInt8]) {
		self.bios = bios
		self.biosActive = true
	}
	
	func loadRom(_ rom: [UInt8]) {
		write(address: 0x0101, data: rom)
	}
	
	private func read(address: UInt16) -> UInt8 {
		switch address {
		case MemoryMap.BOOT_ROM.lowerBound..<MemoryMap.BOOT_ROM.upperBound where self.biosActive:
            return bios[Int(address)];
		case MemoryMap.VRAM:
            return memory[Int(address)];
		case 0...MemoryMap.ERAM.upperBound:
            return memory[Int(address)]; // THIS NEEDS TO BE CHANGED TO ACCESS CARTRIDGE
		case MemoryMap.WRAM_0.lowerBound...MemoryMap.WRAM_n.upperBound:
            return memory[Int(address)];
		case MemoryMap.ECHO: // echo ram access
			return memory[Int(address - MemoryMap.ECHO_RAM_OFFSET)]
		case MemoryMap.OAM.lowerBound...0xFFFF:
			return memory[Int(address)];
		default:
			return UInt8(0)
		}
	}
	
	func readHalf(address: UInt16) -> UInt8 {
		return read(address: address)
	}
	
	func readFull(address: UInt16) -> UInt16 {
		let l = UInt16(read(address: address))
		let h = UInt16(read(address: address+1))
		return l | (h << 8)
	}
	
	func write(address: UInt16, data: UInt8) {
		switch address {
		case MemoryMap.BOOT_ROM.lowerBound..<MemoryMap.BOOT_ROM.upperBound where self.biosActive:
            bios[Int(address)] = data;
        case  MemoryMap.VRAM:
            memory[Int(address)] = data;
        case 0...MemoryMap.ERAM.upperBound:
            memory[Int(address)] = data;  // THIS NEEDS TO BE CHANGED TO ACCESS CARTRIDGE
        case MemoryMap.WRAM_0.lowerBound...MemoryMap.WRAM_n.upperBound:
            memory[Int(address)] = data;
		case MemoryMap.ECHO: // echo ram access
            memory[Int(address - MemoryMap.ECHO_RAM_OFFSET)] = data;
		case MemoryMap.LCD.DMA:
            memory[Int(address)] = data;
        case 0xFF50 where data == 0x01:
            memory[Int(address)] = data;
            self.biosActive = false
		case MemoryMap.OAM.lowerBound...0xFFFF:
            memory[Int(address)] = data;
        default:
            print("Attempted to write out of bounds at address: \(String(format:"0x%02X", address)) with data: \(String(format:"0x%02X", data))")
        }
		memory[Int(address)] = data
	}
	
	func write(address: UInt16, data: [UInt8]) {
		var ii: UInt16 = 0
		for i in data {
			write(address: address+ii, data: i)
			ii += 1
		}
	}
	
	func write(address: UInt16, data: UInt16) {
		write(address: address, data: UInt8(data & 0xFF))
		write(address: address+1, data: UInt8(data >> 8))
	}
	
	func reset() {
		memory = Array<UInt8>(repeating: 0x0, count: MemoryMap.MEM_SIZE)
	}
	
	func toState() -> [UInt8] {
		return memory
	}
}

protocol VMMU {
//	Add functions that only return memory from the VRAM or OAM locations
//	Will also need write functions with the same restrictions
}

extension MMU: VMMU {
	
}

protocol AMMU {
	
}

extension MMU: AMMU {
	
}

