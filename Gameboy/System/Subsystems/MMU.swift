//
//  MMU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-04-25.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation

struct MemoryMap {
	static let ROM_0 = Range<Data.Index>(0x0...0x3FFF)
	static let ROM_n = Range<Data.Index>(0x4000...0x7FFF)
	static let VRAM = Range<Data.Index>(0x8000...0x9FFF)
	static let ERAM = Range<Data.Index>(0xA000...0xBFFF)
	static let WRAM_0 = Range<Data.Index>(0xC000...0xCFFF)
	static let WRAM_n = Range<Data.Index>(0xD000...0xDFFF)
	static let ECHO = Range<Data.Index>(0xE000...0xFDFF)
	static let OAM = Range<Data.Index>(0xFE00...0xFE9F)
	static let IO = Range<Data.Index>(0xFF00...0xFF7F)
	static let HRAM = Range<Data.Index>(0xFF80...0xFFFE)
}

class MMU {
	var rom: Data = Data()
	private var memory: Data = Data(bytes: [0x0], count: 0xFFFF)
	
	func read(location: Range<Data.Index>) -> Data {
		return memory.subdata(in: location)
	}
	
//	This probably needs to change to a function that accepts a start address and the data
	func write(location: Range<Data.Index>, data: Data) {
		memory.replaceSubrange(location, with: data)
	}
	
	func reset() {
		memory = Data(bytes: [0x0], count: 0xFFFF)
	}
}

/*

rom_0: 0000 - 3FFF
rom_n: 4000 - 7FFF
VRAM: 8000 - 9FFF
External Ram: A000 - BFFF
WRAM_0: C000 - CFFF
WRAM_n: D000 - DFFF
Mirror of WRAM_0 (echo ram): E000 - FDFF
OAM: FE00 - FE9F
Not used: FEA0 - FEFF
I/O Registers: FF00 - FF7F
HRAM: FF80 - FFFE
Interupts: FFFF - FFFF (Figure this out)

*/
