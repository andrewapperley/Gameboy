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
	
	static let DIV: UInt16 = 0xFF04
	static let TIMA: UInt16 = 0xFF05
	static let TMA: UInt16 = 0xFF06
	static let TAC: UInt16 = 0xFF07
	static let JUMP_VBLANK: UInt16 = 0x0040
	static let JUMP_LCDC: UInt16 = 0x0048
	static let JUMP_TIMER: UInt16 = 0x0050
	static let JUMP_SERIAL: UInt16 = 0x0058
	static let JUMP_P10P13: UInt16 = 0x0060
	
	enum IF: UInt8 { // IF – Interrupt Flag (R/W)
		static let address: UInt16 = 0xFF0F
		case IF_P10P13 = 0x10
		case IF_SERIAL = 0x08
		case IF_TIMER = 0x04
		case IF_LCDC = 0x02
		case IF_VBLANK = 0x01
	}

	static let HRAM = Range<UInt16>(0xFF80...0xFFFE)
	static let IER: UInt16 = 0xFFFF // Interrupt Enable Register
}

class MMU {
	var interruptsAvailable = true
	private(set) var biosActive = false
	private var bios: [UInt8] = Array<UInt8>(repeating: 0x0, count: Int(MemoryMap.BOOT_ROM.upperBound))
	private var memory: [UInt8] = Array<UInt8>(repeating: 0x0, count: MemoryMap.MEM_SIZE)
	var memoryController: MemoryController?
	
	func loadBios(_ bios: [UInt8]) {
		self.bios = bios
		self.biosActive = true
	}
	
	func loadMemoryController(_ memoryController: MemoryController?) {
		self.memoryController = memoryController
	}
	
	internal func read(address: UInt16) -> UInt8 {
		switch address {
		case MemoryMap.BOOT_ROM.lowerBound..<MemoryMap.BOOT_ROM.upperBound where self.biosActive:
            return bios[Int(address)]
		case MemoryMap.VRAM:
            return memory[Int(address)]
		case 0...MemoryMap.ROM_n.upperBound:
			guard let memoryController = memoryController else { return UInt8(0) }
			return memoryController.read(address: address)
		case MemoryMap.WRAM_0.lowerBound...MemoryMap.WRAM_n.upperBound:
            return memory[Int(address)]
		case MemoryMap.ECHO: // echo ram access
			return memory[Int(address - MemoryMap.ECHO_RAM_OFFSET)]
		case MemoryMap.OAM.lowerBound...0xFFFF:
			return memory[Int(address)]
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
            bios[Int(address)] = data
        case  MemoryMap.VRAM:
            memory[Int(address)] = data
        case 0...MemoryMap.ERAM.upperBound:
			guard let memoryController = memoryController else { return }
			memoryController.write(address: address, data: data)
        case MemoryMap.WRAM_0.lowerBound...MemoryMap.WRAM_n.upperBound:
            memory[Int(address)] = data
		case MemoryMap.ECHO: // echo ram access
            memory[Int(address - MemoryMap.ECHO_RAM_OFFSET)] = data
		case MemoryMap.LCD.DMA:
            memory[Int(address)] = data
        case 0xFF50 where data == 0x01:
            memory[Int(address)] = data
            self.biosActive = false
		case MemoryMap.OAM.lowerBound...0xFFFF:
            memory[Int(address)] = data
        default:
            print("Attempted to write out of bounds at address: \(String(format:"0x%02X", address)) with data: \(String(format:"0x%02X", data))")
        }
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
	
	func writeInterrupt(_ flag: MemoryMap.IF) {
		let interrupts = readHalf(address: MemoryMap.IF.address)
		write(address: MemoryMap.IF.address, data: interrupts | flag.rawValue)
	}
	
	func setInitial() {
		write(address: UInt16(0xFF05), data: UInt8(0x00)) // TIMA
		write(address: UInt16(0xFF06), data: UInt8(0x00)) // TMA
		write(address: UInt16(0xFF07), data: UInt8(0x00)) // TAC
		write(address: UInt16(0xFF10), data: UInt8(0x80)) // NR10
		write(address: UInt16(0xFF11), data: UInt8(0xBF)) // NR11
		write(address: UInt16(0xFF12), data: UInt8(0xF3)) // NR12
		write(address: UInt16(0xFF14), data: UInt8(0xBF)) // NR14
		write(address: UInt16(0xFF16), data: UInt8(0x3F)) // NR21
		write(address: UInt16(0xFF17), data: UInt8(0x00)) // NR22
		write(address: UInt16(0xFF19), data: UInt8(0xBF)) // NR24
		write(address: UInt16(0xFF1A), data: UInt8(0x75)) // NR30
		write(address: UInt16(0xFF1B), data: UInt8(0xFF)) // NR31
		write(address: UInt16(0xFF1C), data: UInt8(0x95)) // NR32
		write(address: UInt16(0xFF1E), data: UInt8(0xBF)) // NR33
		write(address: UInt16(0xFF20), data: UInt8(0xFF)) // NR41
		write(address: UInt16(0xFF21), data: UInt8(0x00)) // NR42
		write(address: UInt16(0xFF22), data: UInt8(0x00)) // NR43
		write(address: UInt16(0xFF23), data: UInt8(0xBF)) // NR30
		write(address: UInt16(0xFF24), data: UInt8(0x77)) // NR50
		write(address: UInt16(0xFF25), data: UInt8(0xF3)) // NR51
		write(address: UInt16(0xFF26), data: UInt8(0xF1)) // NR52
		write(address: UInt16(0xFF40), data: UInt8(0x91)) // LCDC
		write(address: UInt16(0xFF42), data: UInt8(0x00)) // SCY
		write(address: UInt16(0xFF43), data: UInt8(0x00)) // SCX
		write(address: UInt16(0xFF45), data: UInt8(0x00)) // LYC
		write(address: UInt16(0xFF47), data: UInt8(0xFC)) // BGP
		write(address: UInt16(0xFF48), data: UInt8(0xFF)) // OBP0
		write(address: UInt16(0xFF49), data: UInt8(0xFF)) // OBP1
		write(address: UInt16(0xFF4A), data: UInt8(0x00)) // WY
		write(address: UInt16(0xFF4B), data: UInt8(0x00)) // WX
		write(address: UInt16(0xFFFF), data: UInt8(0x00)) // IE
	}
	
	func reset() {
		memory = Array<UInt8>(repeating: 0x0, count: MemoryMap.MEM_SIZE)
		setInitial()
	}
	
	func toState() -> MemoryState {
		return MemoryState(memory: memory, rom: memoryController?.toState())
	}
}

protocol VMMU {
	func readVMMU(address: UInt16) -> UInt8
	func writeVMMU(address: UInt16, data: UInt8)
}

protocol AMMU {
	
}

extension MMU: AMMU {
	
}

