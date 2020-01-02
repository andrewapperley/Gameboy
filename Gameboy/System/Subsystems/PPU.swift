//
//  PPU.swift
//  Gameboy
//
//  Created by Andrew Apperley on 2019-06-14.
//  Copyright © 2019 Andrew Apperley. All rights reserved.
//

import Foundation
import UIKit

class PPU {
	let memory: VMMU

	let WIDTH: CGFloat = 160
	let HEIGHT: CGFloat = 144
	
	init(memory: VMMU) {
		self.memory = memory
	}
	
	func render(delta: UInt) {
//		This is my next task
	}
}

extension MMU: VMMU {
	func readVMMU(address: UInt16) -> UInt8 {
		switch address {
		case MemoryMap.VRAM,
			 MemoryMap.OAM,
			 MemoryMap.LCD.LCDC,
			 MemoryMap.LCD.STAT,
			 MemoryMap.LCD.SCY,
			 MemoryMap.LCD.SCX,
			 MemoryMap.LCD.LY,
			 MemoryMap.LCD.LYC,
			 MemoryMap.LCD.BGP,
			 MemoryMap.LCD.OBP0,
			 MemoryMap.LCD.OBP1,
			 MemoryMap.LCD.WY,
			 MemoryMap.LCD.WX,
			 MemoryMap.LCD.TILES,
			 MemoryMap.LCD.SPT,
			 MemoryMap.LCD.BG_MAP_0,
			 MemoryMap.LCD.BG_MAP_1:
				return read(address: address)
		default:
			print("Attempted to read out of VMMU bounds at address: \(String(format:"0x%02X", address))")
			return UInt8(0)
		}
	}
	
	func writeVMMU(address: UInt16, data: UInt8) {
		switch address {
		case MemoryMap.VRAM,
			 MemoryMap.OAM,
			 MemoryMap.LCD.LCDC,
			 MemoryMap.LCD.STAT,
			 MemoryMap.LCD.SCY,
			 MemoryMap.LCD.SCX,
			 MemoryMap.LCD.LYC,
			 MemoryMap.LCD.DMA,
			 MemoryMap.LCD.BGP,
			 MemoryMap.LCD.OBP0,
			 MemoryMap.LCD.OBP1,
			 MemoryMap.LCD.WY,
			 MemoryMap.LCD.WX,
			 MemoryMap.LCD.TILES,
			 MemoryMap.LCD.SPT,
			 MemoryMap.LCD.BG_MAP_0,
			 MemoryMap.LCD.BG_MAP_1:
				write(address: address, data: data)
		default:
			print("Attempted to write out of VMMU bounds at address: \(String(format:"0x%02X", address)) with data: \(String(format:"0x%02X", data))")
		}
	}
}
